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
