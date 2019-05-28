These are theevocater's dotfiles!

I've included a little setup script that links everything.

It's safe to run at any given time, as it will ask before trampling any files.

## Install
run setup.sh from wherever

## Commands:
* symlinks
  * This creates all the symlinks to the various files in the repo.
* git
  * Downloads the correct git completion files. Run when git is updated.
* sb
  * Syncs all the submodules. Mostly for vim
  * also builds the command-t c extension
* ct
  * Builds the command-t c extension
* ssh
  * sets up ssh configs and such
* font
  * Installs the hasklig font.
* all
  * Runs all of the above. Useful for provisioning a new machine

## Terminal Colorscheme
I use
[solarized](https://github.com/tomislav/osx-terminal.app-colors-solarized) as
my main color scheme. I've borrowed @tomislav's and modified it to use hasklig
as the font.

## TODO
add tests for symlink_home
rewrite new setup.sh
