# George

## Usage

```
Commands:
  george auth                # Authorize george with github API token
  george help [COMMAND]      # Describe available commands or one specific command
  george repos [SUBCOMMAND]  # Follow repositories and list opened PRs
  george version             # george version

  george repos edit            # Edit list of repos to follow
  george repos help [COMMAND]  # Describe subcommands or one specific subcommand
  george repos prs             # List open PRs

  george repos prs
    Options:
      -h, [--help], [--no-help]                    # Display usage information
      -e, [--show-empty], [--no-show-empty]        # List watched repos that have no open PRs
      -s, [--skip-self], [--no-skip-self]          # Skip PRs created by the current user
      -p, [--hide-approved], [--no-hide-approved]  # Hide PRs that are approved and have no requests for changes
      -n, [--needs-review], [--no-needs-review]    # Show only ones which do not have any reviews yet
      -t, [--actionable], [--no-actionable]        # List only actionable PRs. These are PRs which you did not
                                                     review yet, or ones which were updated after your review

```