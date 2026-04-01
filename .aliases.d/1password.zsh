# 1Password alias for loading secrets into the environment
op_load_secrets(){
  eval "$(op inject -i ~/.op.env | sed 's/^/export /')"
}

# 1Password alias for showing secrets in the terminal
alias op_show_secrets="op inject -i ~/.op.env"
