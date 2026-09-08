# Get external IP address in JSON format (or use /ip for plain-text IP)
alias myip="curl https://ipinfo.io/json"

# Run an internet speed test using the speedtest-cli script downloaded from GitHub
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

# Perform an Nmap scan with default scripts, version detection, and output to a file named 'nmap'
alias nm="nmap -sC -sV -oN nmap"

# List all listening TCP ports with associated processes
alias tcplisten='lsof -PniTCP -sTCP:LISTEN'

# Edit the system's hosts file using the default editor with sudo privileges
alias hosts='sudo $EDITOR /etc/hosts'

# Set up an SSH tunnel to forward local port 9090 to the remote Prometheus server on port 9090, connecting via port 29, and display the targets URL
alias rprom="ssh -N -L \*:9090:localhost:9090 remoteserver -p 29 &; echo http://localhost:9090/targets"

# Start a Ruby HTTP server in the current directory on port 8000
alias server_ruby='ruby -run -e httpd . -p 8000'

# Start a Python HTTP server in the current directory on port 4445
alias server_python='python -m http.server 4445'

# Expose a local HTTP server to the internet using ngrok (requires ngrok to be installed and authenticated)
alias expose="ngrok http"

# Get ASN information for a given IP address using Team Cymru's WHOIS service
ans(){
   whois -h whois.cymru.com $1
}
