# ~/.zshrc - Main zsh configuration file
# Purpose: Customize shell behavior, load plugins/themes, configure PATHs and tooling,
# and keep practical defaults for development workflows.

### Uncomment the line below to enable zsh's startup profiler (zprof).
### Use this when you want to identify slow parts of your zsh startup.
#zmodload zsh/zprof

#############################################
# GENERAL SETTINGS / MISC
#############################################

# Ensure proper TTY setup for GPG-related tools (e.g., pass, gpg CLI).
# This makes sure GPG knows where to prompt for a passphrase.
export GPG_TTY=$(tty)               # default: GPG_TTY unset (no explicit TTY assigned)

# Make builds parallelized by default.
# This sets MAKEFLAGS to use one more than the number of CPU cores; many Makefiles will respect it.
# Note: On macOS, `nproc` may not be available; consider `sysctl -n hw.ncpu` if you see issues.
export MAKEFLAGS="-j$(( $(sysctl -n hw.ncpu) + 1 ))"  # default: MAKEFLAGS unset (no automatic -j)

#############################################
# APPENDING TO PATH
#############################################

# ---- MySQL client (Homebrew) ----
# If you need the MySQL client libraries and headers for builds, set these environment variables
# so compilers and pkg-config find the Homebrew-installed mysql-client.
#export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"
#export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
#or just run the following command which will link the binaries from /opt into the regular ~/homebrew/bin path
#brew link mysql-client --force

# Evaluate the output of Homebrew's shellenv command to set up environment variables (like PATH) for Homebrew in the Zsh shell.
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---- Visual Studio Code command-line launcher ----
# Add `code` launcher to PATH so you can open files or launch vscode from the terminal.
# Example: `code .` will open the current directory in VS Code.
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# ---- Codeium Windsurf ----
# Adds Codeium Windsurf's bin directory to PATH for access to its CLI tools.
# Example: `surf` command becomes available in the terminal.
export PATH="${HOME}/.codeium/windsurf/bin:$PATH"

# ---- Krew (kubectl plugin manager) ----
# Adds kubectl krew's bin directory to PATH, so kubectl plugins you installed via krew are available.
export PATH="${HOME}/.krew/bin:$PATH"

# ---- iTerm2 Shell Integration ----
# Source iTerm2 shell integration script if installed to get features like highlighted selection, prompt info, etc.
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#############################################
# OH-MY-ZSH AND THEME CONFIGURATION
#############################################

# Define Oh My Zsh installation path (used by oh-my-zsh bootstrap scripts).
export ZSH="$HOME/.oh-my-zsh"

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
{
  eval "$(starship init zsh)"
}

# ---- Oh-My-Zsh plugins configuration ----
# The `plugins` array lists which Oh-My-Zsh plugins to load.
# Each plugin enables completions, aliases, and helper functions that speed up common tasks.
plugins=(
    # git: core git aliases and helpers (commonly used)
    git
    # you-should-use: suggests a command you should have used from your history to improve consistency
    you-should-use
    # fast-syntax-highlighting: faster syntax highlighting for zsh (lighter weight than zsh-syntax-highlighting)
    fast-syntax-highlighting
    # thefuck: command auto-correction via thefuck CLI
    thefuck
    # zsh-autosuggestions: live suggestions from history as you type
    zsh-autosuggestions
    # git-auto-fetch: automatically fetch remote changes to keep git status accurate
    git-auto-fetch
    # zsh-vim-mode: a modal editing mode for the shell similar to vim
    zsh-vim-mode
    # fzf-zsh-plugin: fzf integration utilities for the shell
    fzf-zsh-plugin
)
# Default: in a fresh oh-my-zsh template: plugins=(git)

# Load Oh My Zsh framework which initializes themes, plugins and completions.
source $ZSH/oh-my-zsh.sh

#############################################
# SHELL BEHAVIOR & HISTORY CONFIG
#############################################

# Increase Zsh history size so more commands are preserved between sessions.
HISTSIZE=1000000       # Keep this many commands in memory (session)  # default: HISTSIZE=1000
SAVEHIST=1000000       # This is required to actually save them, needs to match with HISTSIZE  # default: SAVEHIST=1000

# History options for better usability across multiple terminal instances:
# - unsetopt HIST_SAVE_BY_COPY: Preserve the history file's inode (not rename it) when zsh saves history.
#   This avoids issues with programs tailing or watching the HISTFILE. Some prefer to set it; this config unsets it.
unsetopt HIST_SAVE_BY_COPY  # default: HIST_SAVE_BY_COPY may be unset by default in many setups

# - sharehistory: Share history across sessions in near-real-time.
#   Commands executed in one session are immediately visible in another session.
setopt sharehistory  # default: sharehistory off

# - incappendhistory: Append each command to the history file as it is entered (incremental append).
setopt incappendhistory  # default: incappendhistory off

# Do not record a command if it already exists anywhere in the history.
# This avoids cluttering your history with repeated commands.
setopt hist_ignore_all_dups  # default: hist_ignore_all_dups off

# Remove extra spaces from commands before saving them to history.
# Commands that differ only by spacing are treated as identical.
setopt hist_reduce_blanks  # default: hist_reduce_blanks off

# Don't ask if user is sure when running rm with wildcards (like bash)
setopt rmstarsilent  # default: rmstarsilent off

# If wildcard pattern has no matches, return an empty string (like bash)
setopt no_nomatch  # default: nomatch behavior errors out

# Ignore commands that start with a space (for secret or experimental commands)
setopt HIST_IGNORE_SPACE  # default: HIST_IGNORE_SPACE off

# Expire duplicates first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST  # default: HIST_EXPIRE_DUPS_FIRST off

# --- Background Process Handling ---
# Default behavior: Background jobs run at lower priority (niced).
setopt NO_BG_NICE         # Run background jobs at full priority.  # default: BG_NICE (background jobs nicified)

# Completion system setup:
# - `compinit` is zsh's completion system. Autoload and initialize it.
# - Use cached completion definitions to speed up startup; `cache-path` sets where the cached definitions are stored.
autoload -Uz compinit
zstyle ':completion:*' use-cache on     # default: use-cache off
zstyle ':completion:*' cache-path ~/.zcompdump  # default: no cache-path set

# `compinit -c` loads the cached comps system and avoids expensive recomputation at every shell startup.
# if you add or update completions, remove the cache file to force a rebuild or run compinit without -c.
# compinit -c (lowercase c)
#   Tells compinit to create a cache file if one doesn’t exist.
#   If the cache file already exists, it uses it.
#   If you update completions and want to force a rebuild, you’d need to remove the cache manually.
# compinit -C (uppercase C)
#   Tells compinit to only read the cached file and never rebuild it.
#   If the cache file doesn’t exist, compinit -C will fail.
# Default: compinit (rebuilds if needed)
compinit -C  # load from cache, skip unnecessary rebuilds

# Only load bashcompinit if you need bash-style completions (commented out unless specifically needed).
#autoload -Uz bashcompinit && bashcompinit

# Prevent slow syntax highlighting when pasting very long lines by setting a sane max length.
# This is particularly helpful when accidentally pasting large JSON payloads into the prompt.
# Default: unlimited / not set
export ZSH_HIGHLIGHT_MAXLENGTH=40

# Set iTerm2 terminal title to a custom value
DISABLE_AUTO_TITLE="true"
precmd() {
  print -Pn "\e]0;[ iTerm2 ]\a"
}

#############################################
# MISE
#############################################

# Activate Mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

#############################################
# CUSTOM ALIASES (files sourced from ~/.aliases.d)
#############################################

# Directory containing user alias files. Keeping aliases in separate files helps keep them organized and easy to maintain.
ALIAS_DIR="$HOME/.aliases.d"

# Only source alias files if the directory exists.
if [ -d "$ALIAS_DIR" ]; then
    # Loop through readable `.zsh` files in alphabetical order and source each one.
    # Uses the zsh glob `N` modifier to avoid errors when there are no matches.
    for alias_file in "$ALIAS_DIR"/*.zsh(N); do
        [ -r "$alias_file" ] && source "$alias_file"
    done
fi

### Zsh Profiling
# To profile zsh startup, uncomment the zmodload/zprof line at the top and uncomment `zprof` below:
#zprof
