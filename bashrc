if [ -f /etc/bashrc ]; then
    . /etc/bashrc 
fi

export LC_ALL=C

export LOC_INSTALL_DIR="/home/lear/oneata/local"
export LOC_PYTHON_DIR="$LOC_INSTALL_DIR/python"
export OPENCV_VER="2.2"

# PATH
export PATH="$LOC_INSTALL_DIR/bin:/usr/local/bin:/bin:/usr/bin"
export PATH="$PATH:$LOC_INSTALL_DIR/bin/Trolltech/Qt-4.7.4/bin"

# LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$LOC_INSTALL_DIR/lib"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$LOC_INSTALL_DIR/opencv/opencv$OPENCV_VER/lib"

# PKG_CONFIG_PATH
export PKG_CONFIG_PATH="$LOC_INSTALL_DIR/lib/pkconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$LOC_INSTALL_DIR/opencv/opencv$OPENCV_VER/lib/pkgconfig"

# LD_RUN_PATH
export LD_RUN_PATH="$LD_LIBRARY_PATH"

# Compilation flags
export CFLAGS="-I$LOC_INSTALL_DIR/include"
export LDFLAGS="-L$LOC_INSTALL_DIR/lib"
export CFLAGS="$CFLAGS -I$LOC_INSTALL_DIR/opencv/opencv$OPENCV_VER/include"
export LDFLAGS="$LDFLAGS -L$LOC_INSTALL_DIR/opencv/opencv$OPENCV_VER/lib"
export CPPFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS"

# ATLAS
export BLAS=/usr/lib64/atlas/libptf77blas.so
export LAPACK=/usr/lib64/atlas/liblapack.so
export ATLAS=/usr/lib64/atlas/libatlas.so

# MANPATH
export MANPATH="$LOC_INSTALL_DIR/share/man"
export MANPATH="$MANPATH:$LOC_INSTALL_DIR/video/share/man/"
export MANPATH="$MANPATH:/usr/local/share/man:/usr/share/man"

# PYTHONPATH
export PYTHONPATH="$LOC_PYTHON_DIR:$HOME/src/bigimbaz"
export PYTHONPATH="$PYTHONPATH:$HOME/src/bigimbaz/yael"
export PYTHONPATH="$PYTHONPATH:$LOC_PYTHON_DIR/lib/python2.7/site-packages"

export HISTFILESIZE=20000
export HISTSIZE=10000
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"

# Keybindings
bind '"\t":menu-complete'
bind '"\e[Z":menu-complete-backward'
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

stty werase undef
bind '"\C-w":unix-filename-rubout'

# Aliases
alias h='history | less'
alias l='/bin/ls -FC --color -v'
alias ls='/bin/ls -FC --color=auto -v'
alias ll='/bin/ls -Flh --color -v'
alias la='/bin/ls -FA --color -v'
alias lla='/bin/ls -FlA --color -v'
alias rm='/bin/rm -i'
alias ml='matlab -nodesktop'
alias ipy='ipython --pylab'
alias ntbk='cd /home/lear/oneata/notes/ipython_notebooks; ipython notebook --pylab=inline'

function pcalc {
  python -c "print $*"
}

# Print line number
function pl
{

  line_number=$1
  shift

  sed $line_number'q;d' $*

}

function find_grep
{
  find . -name "*" -exec grep -H "$1" '{}' \; | sed -e "/pytags/d" -e "/deprecated/d" -e "/ipython_log/d"
}

function count
{
  ls -1 $1 | wc -l
}

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "Don't know how to extract '$1'" ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# Extract git branch name
c_red='\e[0;31m'
c_green='\e[0;32m'
c_reset='\e[0m'

function parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    if git diff --quiet 2>/dev/null >&2 
    then
      gitver="($c_green$gitver$c_reset)"
    else
      gitver="($c_red$gitver$c_reset)"
    fi
  else
    return 0
  fi
  echo -e $gitver
}

# Load colors
eval `dircolors ~/.dircolors/dircolors.ansi-light`

# Define prompt
PS1="[\e[34m\h\e[0m][\w]\$(parse_git_branch)\n\$ "
