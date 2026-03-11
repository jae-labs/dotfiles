# Delete last 1000 GitHub Actions runs in the current repository using GitHub CLI
alias ghrund="gh run list --limit 1000 --json databaseId -q '.[].databaseId' | xargs -I{} gh run delete {}"

# Open GitHub CLI with dash externsion on the current repository
alias gdash="gh dash"

# Create a pull request using GitHub CLI with a title and body after pushing the current branch. And open it in the browser.
ghpr() { git push -u origin HEAD && gh pr create --web --title "$1" --body "$2"; }

