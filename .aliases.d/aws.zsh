# List EC2 instances in a human-readable table.
alias adesci="aws ec2 describe-instances | jq -r '([\"name\",\"state\",\"id\",\"az\",\"priv_ip\",\"pub_ip\",\"ca\",\"type\"] | (., map(length*\"-\"))), (.Reservations[].Instances[] | [(.Tags // {} | from_entries | .Name), .State.Name, .InstanceId, .Placement.AvailabilityZone, .PrivateIpAddress, .PublicIpAddress // \"NULL\", .LaunchTime, .InstanceType]) | @csv' | sed -e 's/,,/,\"NULL\",/g' -e 's/,/  |  /g' -e 's/^/|  /g' -e 's/$/  |/g' -e 's/\"//g' | column -t"

# Login to AWS SSO
alias alogin="aws-sso login"

# Open the AWS SSO console for a selected profile.
acon() {
  local profile=$(aws configure list-profiles | grep ':' | fzf)
  if [[ -n "$profile" ]]; then
    aws-sso console --profile "$profile"
  else
    return 0
  fi
}

# `awssm` remembers your last profile/region choice in the `default` AWS CLI profile
# (~/.aws/config), via `aws configure set/get`
_awssm_persist() {
  aws configure set region "$1" --profile default >/dev/null
  aws configure set awssm_selector "$2" --profile default >/dev/null
}

# Reapply the last profile/region chosen via `awssm`, if any.
_awssm_reapply() {
  local selector=$(_awssm_config_get awssm_selector)
  [[ -n "$selector" ]] || return 0
  local region=$(_awssm_config_get region)
  export AWS_DEFAULT_REGION="$region"
  export AWS_REGION="$region"
  if [[ "$selector" == *:* ]]; then
    unset AWS_PROFILE
    aws-sso-profile "$selector" 2>/dev/null
  else
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset ${(k)parameters[(I)AWS_SSO*]} 2>/dev/null
    export AWS_PROFILE="$selector"
    _awssm_load_cached_creds "$selector"
  fi
}

# Read a key from the [default] profile in ~/.aws/config directly, skipping the
# ~250ms interpreter-startup cost of shelling out to `aws configure get`.
_awssm_config_get() {
  awk -v key="$1" '
    /^\[default\]/ { in_default=1; next }
    /^\[/ { in_default=0 }
    in_default && $1 == key { print $3; exit }
  ' ~/.aws/config
}

# Cache exported credentials on disk, trusting the cache until its embedded
# AWS_CREDENTIAL_EXPIRATION is actually close to expiring (no fixed TTL) —
# avoids re-invoking the aws CLI (~250ms startup) on every shell start.
_awssm_load_cached_creds() {
  local selector="$1"
  local cache_file="$HOME/.cache/awssm/${selector}.env"
  mkdir -p "${cache_file:h}"
  if [[ -f "$cache_file" ]]; then
    local expiry=$(awk -F= '/AWS_CREDENTIAL_EXPIRATION/{print $2}' "$cache_file")
    local expiry_epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "${expiry%%+*}" +%s 2>/dev/null)
    if [[ -n "$expiry_epoch" ]] && (( expiry_epoch - $(date +%s) > 300 )); then
      source "$cache_file"
      return
    fi
  fi
  aws configure export-credentials --format env --profile "$selector" > "$cache_file" 2>/dev/null
  source "$cache_file"
}

# Set AWS Profile and Region interactively.
awssm() {
  local regions=$(curl -s -q https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r .prefixes.[].region | sort -h | uniq | grep -v GLOBAL)
  local profile=$(aws configure list-profiles | fzf --header="Select AWS Profile")
  [[ -z "$profile" ]] && return 0
  local region=$(printf "%s\n" "${regions[@]}" | fzf --header="Select AWS Region")
  [[ -z "$region" ]] && return 0
  echo "Setting up **$profile** in **$region**..."
  export AWS_DEFAULT_REGION="$region"
  export AWS_REGION="$region"
  aws configure set region "$region" --profile "$profile"
  if [[ "$profile" == *:* ]]; then
    unset AWS_PROFILE
    aws-sso-profile "$profile"
  else
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset ${(k)parameters[(I)AWS_SSO*]} 2>/dev/null
    export AWS_PROFILE="$profile"
    eval $(aws configure export-credentials --format env)
  fi
  _awssm_persist "$region" "$profile"
}

# Get the AWS caller identity.
alias awhoami="aws sts get-caller-identity"

# Lookup recent CloudTrail events for a specific resource name. Usage: actrail <resource-name>
actrail() {
    aws cloudtrail lookup-events --max-results 3 --lookup-attributes AttributeKey=ResourceName,AttributeValue="$1" | jq
}

# List Auto Scaling lifecycle hooks, or complete a lifecycle action for an instance. Usage: No arguments lists all hooks, or provide <instance> <hook> [asg-name] to complete the action.
alifecycle() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        asgs=($(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].AutoScalingGroupName' --output text))
        for asg in "${asgs[@]}"; do
            echo "Auto Scaling Group: $asg"
            aws autoscaling describe-lifecycle-hooks --auto-scaling-group-name "$asg" --query 'LifecycleHooks[].LifecycleHookName' --output text
        done
    else
        local instance_id="$1"
        local hook_name="$2"
        local asg_name="${3:-}"
        if [ -z "$asg_name" ]; then
            asg_name=$(aws ec2 describe-instances --instance-ids "$instance_id" \
                --query 'Reservations[].Instances[].Tags[?Key==`aws:autoscaling:groupName`].Value' --output text)
            if [ -z "$asg_name" ]; then
                echo "Auto Scaling Group name not provided and could not be determined for instance $instance_id."
                return 1
            fi
        fi
        aws autoscaling complete-lifecycle-action \
            --lifecycle-action-result CONTINUE \
            --instance-id "$instance_id" \
            --lifecycle-hook-name "$hook_name" \
            --auto-scaling-group-name "$asg_name"
    fi
}

# Decode an STS encoded authorization message and pretty-print the resulting JSON.
adecode() {
    aws sts decode-authorization-message --encoded-message "$1" --query DecodedMessage --output text | jq '.'
}
