# Changes directory using zoxide
alias cd="z"

# Changes directory interactively using zoxide
alias cdi="zi"

# Goes to the home directory
alias home="cd ~"

# Goes up one directory level
alias ..="cd .."

# Goes up two directory levels
alias ...="cd ../.."

# Goes up three directory levels
alias ....="cd ../../.."

# Goes up four directory levels
alias .....="cd ../../../.."

# Goes up five directory levels
alias ......="cd ../../../../.."

# Exits the shell
alias x="exit"

# Goes up one directory level (fixes common typo)
alias cd..="cd .."

# Goes to the home directory
alias ~="cd ~" # `cd` is probably faster to type though

# mv, rm, cp
# Moves files with verbose output
alias mv='mv -v'

# Removes files recursively and with verbose output
alias rm='rm -rf -v'

# Copies files with verbose output
alias cp='cp -v'

# Clears the screen
alias cls='clear' # Good 'ol Clear Screen command

# Lists files in long format with icons, git status, hidden files and group directories
alias l="eza --color=always -l --icons --git -a --group-directories-first"

# Lists files as a tree with icons, git status, and hidden files using eza, ignoring .git
alias ltree="eza --color=always -a --tree --icons --git -I '.git'"

# Follows the content of a file in real-time
alias tailf="tail -f"

# Searches for patterns with color output
alias grep="grep --color=auto"

# Searches for patterns using ripgrep.
alias rgrep="rg"

# Searches for patterns using ripgrep.
alias gre="rg"

# Searches with ripgrep to include hidden files, ignoring .gitignore and .git folder. By default rg respects .gitignore files.
alias rg="rg --hidden --no-ignore --glob '!.git/*'"

# Finds files, directories or links using fd, including hidden ones, ignoring .gitignore and .git folder. By default fd respects .gitignore files.
alias fd="fd -t f -t d -t l --hidden --no-ignore --exclude .git"

# Rsync with archive mode, verbose, human-readable sizes and progress
alias rsync="rsync -avh --progress"

# Use GNU sed (gsed) from Homebrew instead of the macOS BSD sed
alias sed="/opt/homebrew/bin/gsed"

# Use GNU awk (gawk) from Homebrew instead of the macOS mawk/awk
alias awk="/opt/homebrew/bin/gawk"

# Show free disk space for each mounted filesystem, using human-readable suffixes (e.g. 1K, 234M, 2G).
alias df='df -h'

# Show disk usage for files and directories with human-readable sizes.
alias du='du -h'

# Copies the contents of a file to the clipboard
pbc() { cat $1 | pbcopy }
