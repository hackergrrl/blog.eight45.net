---
layout: post
title:  "Fork Github Repositories Easily"
date:   2016-03-10 23:40:47
---
# The dream

Perhaps I'm browsing a repository on GitHub and discover a bug I'd like to submit a pull request for. Say I've found a typo in the README.md on https://github.com/noffle/electron-speech. The dream is to open up a terminal and type

```
$ fork noffle/electron-speech
```

and be transported to (in my case) `~/Projects/Forks/electron-speech` with my own `noffle` (my GitHub username) remote in addition to the repo's normal `origin` remote.

# hub

[`hub`](https://github.com/github/hub) is a command line program written by the folks at GitHub to simply many common git<->GitHub interactions[1].

After installing and examining the documentation, you may notice that `hub` already provides a subcommand called `fork`. This does most of the legwork for us: it will make a GitHub fork of the cloned repo you're currently in and add a remote to that fork named after your GitHub username.

# Wrapping `hub fork` up pretty

Let's write a bash function to do the heavy lifting around the `hub fork` command to parse an argument of the form `username/repo`, clone it into where ever you prefer your forked repos to be, perform the fork, and finally set your shell's current directory there:

```sh
#!/bin/bash

function fork() {
  if [ "$#" -ne 1 ]; then
    echo "USAGE: fork author/repo"
  fi

  # Move to where forks live and clone the original repo.
  cd $GITHUB_FORKS_DIR
  git clone https://github.com/${1}.git

  # Strip the "author/" prefix from "author/repo" for the directory name
  cd $(echo $1 | sed 's/.*\///')

  hub fork
}
```

I've saved this to `~/bin/funcs.sh`[2] on my machine and load it in my `.bashrc`:

```
echo "source ${HOME}/bin/funcs.sh" >> ~/.bashrc
```


You should also set `$GITHUB_FORKS_DIR` to where ever you'd like your forked repos to appear. You could add this as well to the end of your `.bashrc`:

```
$ echo 'export GITHUB_FORKS_DIR="${HOME}/Projects/Forks"' >> ~/.bashrc
```

# Ready to fork

Let's try this out!

```
stephen // ~ $ fork noffle/electron-speech
Cloning into 'electron-speech'...
remote: Counting objects: 70, done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 70 (delta 11), reused 0 (delta 0), pack-reused 48
Unpacking objects: 100% (70/70), done.
Checking connectivity... done.
Updating noffle
From https://github.com/noffle/electron-speech
 * [new branch]      master     -> noffle/master
new remote: noffle

stephen // electron-speech $ git remote
origin
noffle
```

Woohoo! Now we can create a new branch, make our edits, commit, and push to our remote. We can then use `hub pull-request` to submit our changes to the original repo.

I've had great mileage with this bash function -- it brings the process of wanting to fix or edit something on someone else's repo down to a single step, letting me move faster without needing to manually enter steps each time. This can really add up when you're writing PRs in bulk!


# Footnotes

 [1] `hub` advertises itself as wanting to replace your existing `git` command. I don't find this desirable: `hub` best serves me by augmenting what other commands on my system do, not by eclipsing them.


 [2] We use a function instead of a standalone bash script because having a script named e.g. `fork.sh` that we invoke will create a subshell. Operations like `cd` in subshells are localized: this would mean after running `fork` our original shell would still be in the directory it started in!
