# George

## Usage

```
Commands:
  michael auth                # Authorize michael with github API token
  michael help [COMMAND]      # Describe available commands or one specific command
  michael repos [SUBCOMMAND]  # Follow repositories and list opened PRs
  michael version             # michael version

  michael repos edit            # Edit list of repos to follow
  michael repos help [COMMAND]  # Describe subcommands or one specific subcommand
  michael repos prs             # List open PRs

  michael repos prs
    Options:
      -h, [--help], [--no-help]                    # Display usage information
      -e, [--show-empty], [--no-show-empty]        # List watched repos that have no open PRs
      -s, [--skip-self], [--no-skip-self]          # Skip PRs created by the current user
      -p, [--hide-approved], [--no-hide-approved]  # Hide PRs that are approved and have no requests for changes
      -n, [--needs-review], [--no-needs-review]    # Show only ones which do not have any reviews yet
      -t, [--actionable], [--no-actionable]        # List only actionable PRs. These are PRs which you did not
                                                     review yet, or ones which were updated after your review

```