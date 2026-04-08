# Minimal Bash compatibility config. Zsh is the primary managed shell.

case $- in
  *i*) ;;
  *) return ;;
esac

export EDITOR=vim

case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) PATH="$HOME/bin:$PATH" ;;
esac

case ":$PATH:" in
  *":./node_modules/.bin:"*) ;;
  *) PATH="./node_modules/.bin:$PATH" ;;
esac
export PATH

alias l='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias _='sudo'
alias ...='../..'

if command -v lsd > /dev/null 2>&1; then
  alias ls='lsd'
fi

if command -v bat > /dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat > /dev/null 2>&1; then
  alias cat='batcat'
fi

if [[ -f ~/.bashrc.local ]]; then
  # shellcheck disable=SC1090
  . ~/.bashrc.local
fi
