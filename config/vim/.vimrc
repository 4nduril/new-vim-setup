set nocompatible

let s:vimrc_dir = expand('<sfile>:p:h')
let s:vim_runtime_dir = s:vimrc_dir . '/.vim'
let s:config_dir = s:vim_runtime_dir . '/vimrc'
let s:repo_local_config = s:vim_runtime_dir . '/local.vim'
let s:home_local_config = expand('~/.vim/local.vim')

execute 'set runtimepath^=' . fnameescape(s:vim_runtime_dir)
execute 'set packpath^=' . fnameescape(s:vim_runtime_dir)

if filereadable(s:repo_local_config)
  execute 'source' fnameescape(s:repo_local_config)
endif

if filereadable(s:home_local_config)
      \ && resolve(fnamemodify(s:home_local_config, ':p')) !=# resolve(fnamemodify(s:repo_local_config, ':p'))
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
unlet s:vim_runtime_dir
unlet s:vimrc_dir
