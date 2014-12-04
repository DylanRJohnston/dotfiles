# Configuration Dotfiles Installation #

Installs a bunch of common dot files and directories that live in your home directory. Not sure if anyone else will use this, it's mainly for me to keep track and keep in sync various workstations I use.

## How to use ##
 - `git clone https://github.com/DylanRJohnston/dotfiles.git`
 - `./install.sh`
 - Manually merge conflicting directories like .ssh and .vim #TODO make this automatic

## Notes ##
 - Files are symbolically linked back to the git directory. So changes made in place to your configuration files will be seen in a git diff.
 - All files in this directory are symlinked with the a prepended . making them hidden. Currently no support for linking non hidden configuration files.
 - Files in .ignore and not linked. Allows for tracking of files like iTerm2Colors which do not live in your home directory but are imported by the iTerm2 application. 
