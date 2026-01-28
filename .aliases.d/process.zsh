# Alias for 'ps aux' to list all processes with detailed information
alias psa="ps aux"

# Alias for 'btm -r 250' to run bottom with a refresh rate of 250 milliseconds in tree view
alias topp="btm -r 250 --tree"

# Function to kill all background jobs by iterating through job IDs and sending kill signals
kj() {
    for job in `jobs -l | awk -F'[][]' '{print $2}'`; do
        kill %$job
    done
}

# Function to kill the process listening on a specified TCP port
tcpkill(){
   [ -z $1 ] && echo "Use: tcpkill {tcp_port_number}" && return 1
   PID=$(lsof -nPiTCP:$1 -sTCP:LISTEN -t)
   if [[ ! -z $PID ]] ;then
      kill $PID && \
         echo "[OK] - Killed: $PID" || \
         echo "[Fail] - Failled to kill PID(s) $PID"
   else
      echo "[ERR] - No PID found for TCP PORT $1"
   fi
   unset PID
}
