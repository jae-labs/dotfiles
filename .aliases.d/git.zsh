# Display a concise summary of the git repository status, showing the current branch, staged/unstaged changes, and untracked files.
alias gs="git status -sb"

# Fetch the main branch from origin and merge it into the current branch.
alias gmm="git fetch origin main:main && git merge main"

# Show differences between the working directory and the index (staged changes).
alias gd="git diff"

# Stage files for the next commit.
alias ga="git add"

# Commit staged changes with a message.
alias gc="git commit -m "

# Reset the index and working directory to the last commit (mixed reset by default).
alias gr="git reset"

# Fetch updates from the remote repository without merging.
alias gf="git fetch"

# List all branches in the repository.
alias gb="git branch"

# Show differences between the current branch and its upstream branch.
alias gdiff="git diff @{u}"

# Force delete a branch.
alias gbD="git branch -D"

# Pull changes from the remote repository and merge them into the current branch.
alias gpull="git pull"

# Display a graphical representation of the commit history in a compact format.
alias gl='git log --oneline --graph --all'

# Display a detailed graphical log of all commits, including statistics and summaries.
alias gla='git log --stat --graph --summary --oneline --all'

# Push local commits to the remote repository.
alias gpush="git push"

# Switch to the main branch.
alias gcm="git checkout main"

# Create and switch to a new branch.
alias gcob="git checkout -b"

# Switch to an existing branch or commit.
alias gco="git checkout"

# Show what would be removed by a clean operation without actually deleting files.
alias gclean="git clean -xdn"

# Forcefully remove untracked files and directories from the working directory.
alias gcleanf="git clean -xdf"

# Clean up the repository by switching to the main branch, deleting all other branches, expiring reflog entries, performing garbage collection, and removing untracked files.
alias gcleanff="(git checkout main 2>/dev/null || git checkout master) && git fetch -p && git pull && git branch --format '%(refname:short)' | grep -vE '^(main|master)$' | xargs git branch -D 2>/dev/null; git reflog expire --expire=now --all; git gc --prune=now; git clean -xdf"

# Display a graphical log of commits with decorations for branches and tags.
alias gg="git log --graph --oneline --decorate --all"

# Stage all changes in the working directory, including new, modified, and deleted files.
alias gaa="git add -A"

# Commit all staged changes with a message.
alias gca="git commit -am"

# List all branches with verbose information, including tracking details.
alias gbr="git branch -avv"

# Switch back to the previously checked out branch.
alias gprev="git checkout -"

# Fetch updates from all remotes and prune deleted branches.
alias gfa="git fetch --all --prune"

# Pull changes from the remote repository, rebasing local commits and automatically stashing/unstashing changes.
alias gup="git pull --rebase --autostash"

# Force push local commits to the remote repository, but only if the remote hasn't diverged.
alias gpf="git push --force-with-lease"

# Stash uncommitted changes for later retrieval.
alias gst="git stash"

# Apply the most recent stash and remove it from the stash list.
alias gstp="git stash pop"

# List all stashed changes.
alias gstl="git stash list"

# Reset the index and working directory to the specified commit, discarding all changes.
alias grh="git reset --hard"

# Display the size of the git repository, including pack files and loose objects.
alias gsize="git count-objects -vH"

# List all git configuration settings.
alias gcf="git config --list"

# Clone a repository into a new directory.
alias gcl="git clone"

# Apply the changes from a specific commit to the current branch.
alias gcp="git cherry-pick"

# Show who last modified each line of a file, ignoring whitespace changes.
alias gblame="git blame -w"

# Summarize commit counts by author.
alias gsl="git shortlog -sn"

# Show differences between files with word-level highlighting.
alias gdw="git diff --word-diff"

# Show differences between the index and the last commit (staged changes).
alias gdst="git diff --staged"

# Push the specified branch (or current branch) to the origin remote.
gpo() { git push origin "${1:-$(git rev-parse --abbrev-ref HEAD)}"; }

# Perform a soft reset to the specified commit (or one commit back), keeping changes staged.
gundo() { git reset --soft "${1:-HEAD~1}"; }

# Nuke the entire git history of the default branch (main or master) after user confirmation.
gnukehistory() {
  # 1. Dynamically find the default branch name
  local base_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Fallback to 'main' if detection fails
  [[ -z "$base_branch" ]] && base_branch="main"

  # 2. Safety Check: Ensure user is on the base branch
  if [[ "$current_branch" != "$base_branch" ]]; then
    echo -e "Error: You must be on the '$base_branch' branch to nuke its history."
    return 1
  fi

  # 3. Warning and Confirmation
  echo -e "WARNING: This will PERMANENTLY DELETE all history on '$base_branch'."
  echo -n "Are you absolutely sure you want to proceed? (y/n): "
  read confirmation
  if [[ "$confirmation" != "y" ]]; then
    echo "Aborted."
    return 1
  fi

  # 4. Execute the Flattening
  echo "Pulling latest changes..."
  git pull origin "$base_branch" && \
  echo "Creating orphan branch..." && \
  git checkout --orphan latest_branch && \
  git add -A && \
  git commit -am "Initial commit" && \
  echo "Reconstructing $base_branch..." && \
  git branch -D "$base_branch" && \
  git branch -m "$base_branch" && \
  echo "Force pushing to origin..." && \
  git push -uf origin "$base_branch"

  echo -e "Success: History has been flattened."
}

# Squash all commits on the current branch into a single commit and force push to the remote.
gsquash() {
  local base_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  echo -e "Target base: $base_branch"
  echo -n "Squash all commits into a single commit and FORCE PUSH? (y/n): "
  read confirmation
  if [[ "$confirmation" != "y" ]]; then
    echo "Aborted."
    return 1
  fi
  echo -n "Enter the new commit message: "
  read commit_msg
  if [[ -z "$commit_msg" ]]; then
    echo "Error: Message required. Aborting."
    return 1
  fi
  git reset --soft "$base_branch" && \
  git commit -am "$commit_msg" && \
  git push --force-with-lease
}

# Interactive commit message generator using gum for structured input.
gci() {
    local ctype breaking scope summary description message exitmsg
    exitmsg="Aborted."
    ctype=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert") || { echo "$exitmsg"; return; }
    breaking=$(gum choose "" "!") || { echo "$exitmsg"; return; }
    scope=$(gum input --placeholder "scope") || { echo "$exitmsg"; return; }
    [ -n "$scope" ] && scope="($scope)"
    summary=$(gum input --value "$ctype$scope$breaking: " --placeholder "Summary of this change") || { echo "$exitmsg"; return; }
    description=$(gum write --placeholder "Details of this change") || { echo "$exitmsg"; return; }
    message=$summary$'\n\n'$description
    gum confirm "$(printf '%s\n\nCommit changes?' "$message")" || { echo "$exitmsg"; return; }
    git commit -m "$message"
}

# Generate a commit message using AI for staged changes and commit after user confirmation.
gcai() {
    added_files=$(git diff --cached --name-only)
    if [ -z "$added_files" ]; then
        echo "No staged files found. Aborting."
        return 1
    fi
    commit_msg=$(gum spin --spinner dot --title "Generating commit message..." -- zsh -c 'git --no-pager diff --cached | gemini --model gemini-2.5-flash-lite "Summarize this change in a concise git commit message. Follow Git semantic commit conventions and standards. Raw text no markdowns" 2>/dev/null')
    if [ -z "$commit_msg" ]; then
        echo "Commit message is empty. Aborting."
        return 1
    fi
    echo -e "\n-------------------------\n"
    echo "$commit_msg"
    echo -e "\n-------------------------\n"
    local confirm
    read -r "confirm?Proceed with this commit? [y/N]: "
    case "$confirm" in
        [yY] | [yY][eE][sS])
            git commit -m "$commit_msg"
            ;;
        *)
            echo "Abort: commit canceled by user."
            return 1
            ;;
    esac
}
