set nocompatible

let s:vimrc_dir = expand('<sfile>:p:h')
let s:config_dir = s:vimrc_dir . '/.vim/vimrc'
let s:repo_local_config = s:vimrc_dir . '/.vim/local.vim'
let s:home_local_config = expand('~/.vim/local.vim')

if filereadable(s:repo_local_config)
  execute 'source' fnameescape(s:repo_local_config)
endif

if filereadable(s:home_local_config)
  execute 'source' fnameescape(s:home_local_config)
endif

execute 'source' fnameescape(s:config_dir . '/core.vim')
execute 'source' fnameescape(s:config_dir . '/ui.vim')
execute 'source' fnameescape(s:config_dir . '/mappings.vim')
execute 'source' fnameescape(s:config_dir . '/plugins.vim')
execute 'source' fnameescape(s:config_dir . '/languages.vim')

unlet s:config_dir
unlet s:home_local_config
unlet s:repo_local_config
unlet s:vimrc_dir
