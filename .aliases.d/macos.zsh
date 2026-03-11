# Prevent the Mac from sleeping by keeping the display awake and preventing idle sleep
alias up="caffeinate -d -i"

# Clean up Homebrew and macOS caches and perform maintenance
brewclean() {
    find ~/Library/Caches -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
    rm -rf "$(brew --cache)"
    brew update && brew upgrade && brew cleanup -s && brew doctor
}
