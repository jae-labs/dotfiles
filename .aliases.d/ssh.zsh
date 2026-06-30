# SSH into a named screen session on a remote host, or create one if it doesn't exist.
sshs () {
  if [ ! -z $1 ]; then
    ssh -t $1 screen -DRq $(whoami)-session
  else
    echo "Usage: sshs <host>"
  fi
}

# Reverse SSH tunnel to access Nomad UI on a remote host.
rnomad() {
  # Default to "ubuntu@oci-prod-1" if no argument is provided.
  local target="${1:-ubuntu@oci-prod-1}"
  ssh -N -L 4646:127.0.0.1:4646 "$target" &
  echo "http://127.0.0.1:4646"
}
