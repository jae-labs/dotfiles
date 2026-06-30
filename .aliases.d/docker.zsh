# Alias to list running Docker containers
alias dps="docker ps"

# Alias to list all Docker containers (including stopped ones)
alias dpsa="docker ps -a"

# Alias to list Docker images
alias dils="docker image ls"

# Alias to list Docker volumes
alias dvls="docker volume ls"

# Alias to prune the Docker system by removing unused data
alias dsp="docker system prune"

# Alias to prune unused Docker images
alias dip="docker image prune"

# Alias to remove a Docker image
alias dirm="docker image rm"

# Alias to show Docker disk usage with verbose output
alias dsdf="docker system df -v"

# Alias to display real-time statistics for running containers
alias ds="docker stats"

# Alias to remove a Docker container
alias drm="docker rm"

# Alias to remove a Docker image
alias drmi="docker rmi"

# Alias to execute a command interactively in a running container
alias dexec="docker exec -it"

# Alias to run a Docker container interactively
alias drun="docker run -it"

# Alias to show logs from a Docker container
alias dlogs="docker logs"

# Alias to build a Docker image from a Dockerfile
alias dbuild="docker build"

# Alias to start a stopped Docker container
alias dstart="docker start"

# Alias to stop a running Docker container
alias dstop="docker stop"

# Alias to restart a Docker container
alias drestart="docker restart"

# Alias to pull a Docker image from a registry
alias dpull="docker pull"

# Alias to push a Docker image to a registry
alias dpush="docker push"

# Alias to inspect details of a Docker container, image, or volume
alias dinspect="docker inspect"

# Alias to commit changes in a container to a new image
alias dcommit="docker commit"

# Alias to tag a Docker image with a new name
alias dtag="docker tag"

# Alias to list Docker networks
alias dnetworkls="docker network ls"

# Alias to remove a Docker network
alias dnetworkrm="docker network rm"

# Alias to attach to a running Docker container
alias dattach="docker attach"

# Alias to display running processes inside a container
alias dtop="docker top"

# Alias to copy files or folders between a container and the local filesystem
alias dcp="docker cp"
