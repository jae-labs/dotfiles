# Unalias ghrund if it was previously defined as an alias (avoids Zsh parse errors during reload)
unalias ghrund 2>/dev/null

# Delete last 1000 GitHub Actions runs in the current repository (or a given repo) using GitHub CLI
ghrund() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  echo "Fetching workflow runs for ${repo:-current repository}..."
  local runs
  if [ -n "$repo" ]; then
    runs=$(gh run list -R "$repo" --limit 1000 --json databaseId -q '.[].databaseId' 2>/dev/null)
  else
    runs=$(gh run list --limit 1000 --json databaseId -q '.[].databaseId' 2>/dev/null)
  fi

  if [ -z "$runs" ]; then
    echo "No workflow runs found."
    return 0
  fi

  echo "Deleting workflow runs in parallel..."
  if [ -n "$repo" ]; then
    echo "$runs" | xargs -P 10 -I {} gh run delete -R "$repo" {}
  else
    echo "$runs" | xargs -P 10 -I {} gh run delete {}
  fi
  echo "All workflow runs have been deleted successfully."
}

# Open GitHub CLI with dash extension on the current repository
alias gdash="gh dash"

# Create a pull request using GitHub CLI with a title and body after pushing the current branch. And open it in the browser.
ghpr() { git push -u origin HEAD && gh pr create --web --title "$1" --body "$2"; }

# Delete all deployments in the current repository (or a given repo) using GitHub CLI
ghdeployd() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  if [ -z "$repo" ]; then
    echo "Error: Not in a git repository and no repository specified."
    echo "Usage: ghdeployd [owner/repo]"
    return 1
  fi

  echo "Fetching deployments for $repo..."
  local deployments=$(gh api --paginate "/repos/$repo/deployments" --jq '.[].id' 2>/dev/null)
  if [ -z "$deployments" ]; then
    echo "No deployments found for $repo."
    return 0
  fi

  echo "Deleting deployments for $repo in parallel..."
  echo "$deployments" | xargs -P 10 -I {} zsh -c '
    id="$1"
    repo="$2"
    echo "Making deployment $id inactive..."
    gh api -X POST "/repos/$repo/deployments/$id/statuses" -f state=inactive >/dev/null 2>&1
    echo "Deleting deployment $id..."
    gh api -X DELETE "/repos/$repo/deployments/$id" >/dev/null 2>&1
  ' -- {} "$repo"
  echo "All deployments for $repo have been deleted successfully."
}

# Delete all releases in the current repository (or a given repo) using GitHub CLI
ghreleased() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  if [ -z "$repo" ]; then
    echo "Error: Not in a git repository and no repository specified."
    echo "Usage: ghreleased [owner/repo]"
    return 1
  fi

  echo "Fetching releases for $repo..."
  local releases=$(gh release list -R "$repo" --limit 1000 --json tagName --jq '.[].tagName' 2>/dev/null)
  if [ -z "$releases" ]; then
    echo "No releases found for $repo."
    return 0
  fi

  echo "Deleting releases for $repo in parallel..."
  echo "$releases" | xargs -P 10 -I {} zsh -c '
    tag="$1"
    repo="$2"
    echo "Deleting release $tag..."
    gh release delete -R "$repo" -y "$tag" >/dev/null 2>&1
  ' -- {} "$repo"
  echo "All releases for $repo have been deleted successfully."
}

# Delete all tags in the current repository (or a given repo) using GitHub CLI
ghtagd() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  if [ -z "$repo" ]; then
    echo "Error: Not in a git repository and no repository specified."
    echo "Usage: ghtagd [owner/repo]"
    return 1
  fi

  echo "Fetching tags for $repo..."
  local tags=$(gh api --paginate "/repos/$repo/tags" --jq '.[].name' 2>/dev/null)
  if [ -z "$tags" ]; then
    echo "No tags found for $repo."
    return 0
  fi

  echo "Deleting tags for $repo in parallel..."
  echo "$tags" | xargs -P 10 -I {} zsh -c '
    tag="$1"
    repo="$2"
    echo "Deleting tag $tag..."
    gh api -X DELETE "/repos/$repo/git/refs/tags/$tag" >/dev/null 2>&1
  ' -- {} "$repo"
  echo "All tags for $repo have been deleted successfully."
}

# Delete all remote branches in the current repository (or a given repo) except main/master/default branch
ghbranchd() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  if [ -z "$repo" ]; then
    echo "Error: Not in a git repository and no repository specified."
    echo "Usage: ghbranchd [owner/repo]"
    return 1
  fi

  echo "Fetching default branch for $repo using GitHub CLI..."
  local default_branch=$(gh repo view "$repo" --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null)
  if [ -z "$default_branch" ]; then
    echo "Error: Failed to fetch the default branch via GitHub CLI."
    return 1
  fi

  echo "Default branch is: $default_branch"

  echo "Fetching remote branches for $repo..."
  local branches=$(gh api --paginate "/repos/$repo/branches" --jq '.[].name' 2>/dev/null)
  if [ -z "$branches" ]; then
    echo "No remote branches found for $repo."
    return 0
  fi

  # Filter out only the default branch
  local branches_to_delete=""
  echo "$branches" | while read -r branch; do
    [ -z "$branch" ] && continue
    if [ "$branch" != "$default_branch" ]; then
      branches_to_delete="${branches_to_delete}${branch}"$'\n'
    fi
  done

  if [ -z "$branches_to_delete" ]; then
    echo "No remote branches to delete (excluding $default_branch)."
    return 0
  fi

  echo "Deleting remote branches for $repo in parallel..."
  echo "$branches_to_delete" | sed '/^$/d' | xargs -P 10 -I {} zsh -c '
    branch="$1"
    repo="$2"
    echo "Deleting remote branch $branch..."
    gh api -X DELETE "/repos/$repo/git/refs/heads/$branch" >/dev/null 2>&1
  ' -- {} "$repo"
  echo "All remote branches for $repo (excluding $default_branch) have been deleted successfully."
}

# Run all deletion cleanups concurrently in the background and wait for completion
ghalld() {
  local repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"
  if [ -z "$repo" ]; then
    echo "Error: Not in a git repository and no repository specified."
    echo "Usage: ghalld [owner/repo]"
    return 1
  fi

  echo "Starting concurrent execution of all cleanups for $repo..."
  
  ghdeployd "$repo" &
  ghtagd "$repo" &
  ghreleased "$repo" &
  ghrund "$repo" &
  ghbranchd "$repo" &
  
  wait
  echo "All cleanup tasks completed successfully for $repo!"
}
