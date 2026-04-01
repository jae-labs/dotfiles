sshs () {
  if [ ! -z $1 ]; then
    ssh -t $1 screen -DRq $(whoami)-session
  else
    echo "Usage: sshs <host>"
  fi
}

