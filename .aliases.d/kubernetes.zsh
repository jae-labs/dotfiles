# Alias for kubectl command
alias k='kubectl'

# Alias to get resources with kubectl
alias kg='kubectl get'

# Alias to describe resources with kubectl
alias kd='kubectl describe'

# Alias to delete resources with kubectl
alias krm='kubectl delete'

# Alias to delete resources from a file with kubectl
alias krmf='kubectl delete -f'

# Alias to follow logs with kubectl
alias klo='kubectl logs -f'

# Alias to get pods with kubectl
alias kgpo='kubectl get pod'

# Alias to describe pods with kubectl
alias kdpo='kubectl describe pod'

# Alias to get nodes with kubectl
alias kgno='kubectl get nodes'

# Alias to describe nodes with kubectl
alias kdno='kubectl describe node'

# Alias to get deployments with kubectl
alias kgdep='kubectl get deployment'

# Alias to describe deployments with kubectl
alias kddep='kubectl describe deployment'

# Alias to get ingresses with kubectl
alias kging='kubectl get ingress'

# Alias to describe configmaps with kubectl
alias kdcm='kubectl describe configmap'

# Alias to switch Kubernetes context using kubectx
alias kc="kubectx"

# Alias to switch Kubernetes namespace using kubens
alias kns="kubens"

# Alias to retrieve Kubernetes dashboard URL and token
alias dashboard='url=$(kubectl get ing -n kubernetes-dashboard kubernetes-dashboard -o jsonpath="{.spec.rules[].host}") && token=$(kubectl -n kube-system get secret $(kubectl -n kube-system get sa dashboard-admin -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}") && echo -e "\nURL:   ${url}\n\nToken: ${token}"'

# Keep the shell's AWS profile/region in sync with the current kube context.
_kubesync_last_context=$(awk '/^current-context:/{print $2; exit}' ~/.kube/config 2>/dev/null)
_kubesync_aws() {
  local ctx=$(awk '/^current-context:/{print $2; exit}' ~/.kube/config 2>/dev/null)
  [[ -z "$ctx" || "$ctx" == "$_kubesync_last_context" ]] && return
  _kubesync_last_context="$ctx"

  local info=$(kubectl config view --minify --raw -o json 2>/dev/null | jq -r '
    .users[0].user.exec as $e
    | ($e.env[]? | select(.name=="AWS_PROFILE") | .value) as $p
    | ($e.args as $a | $a[($a | index("--region"))+1]) as $r
    | "\($p)\t\($r)"
  ' 2>/dev/null)
  [[ -z "$info" ]] && return   # context has no AWS-backed exec credential (e.g. orbstack)

  local profile="${info%%$'\t'*}"
  local region="${info##*$'\t'}"
  [[ -z "$profile" || "$profile" == "null" ]] && return

  echo "kube context '$ctx' -> aws profile '$profile' ($region)"
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  unset ${(k)parameters[(I)AWS_SSO*]} 2>/dev/null
  export AWS_PROFILE="$profile"
  export AWS_REGION="$region"
  export AWS_DEFAULT_REGION="$region"
  _awssm_load_cached_creds "$profile"
  _awssm_persist "$region" "$profile"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _kubesync_aws
