typeset -U path
path=(./node_modules/.bin ~/bin $path)

if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
