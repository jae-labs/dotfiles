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
  fi
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
