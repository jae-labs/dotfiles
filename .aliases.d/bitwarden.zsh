# Bitwarden alias for loading secrets into the environment
bw_load_secrets() {
  local item key

  BW_SESSION_FILE="$HOME/.bw-session"

  if [[ -f "$BW_SESSION_FILE" ]]; then
    export BW_SESSION=$(cat "$BW_SESSION_FILE")
  fi

  item=$(bw get item "ENV_VARS")

  # read keys from .env, ignore comments/empty lines
  while IFS='=' read -r key _; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    export "$key"=$(echo "$item" | jq -r ".fields[] | select(.name==\"$key\") | .value")
  done < ~/.bw.env
}

# Unlock Bitwarden and save session to file
bw_unlock() {
  export BW_SESSION=$(bw unlock --raw)
  echo "$BW_SESSION" > "$BW_SESSION_FILE"
  chmod 600 "$BW_SESSION_FILE"
}

