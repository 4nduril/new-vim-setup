set nocompatible

let s:vimrc_dir = expand('<sfile>:p:h')
let s:config_dir = s:vimrc_dir . '/.vim/vimrc'

execute 'source' fnameescape(s:config_dir . '/core.vim')
execute 'source' fnameescape(s:config_dir . '/ui.vim')
execute 'source' fnameescape(s:config_dir . '/mappings.vim')
execute 'source' fnameescape(s:config_dir . '/plugins.vim')
execute 'source' fnameescape(s:config_dir . '/languages.vim')

let s:local_config = expand('~/.vim/local.vim')
if filereadable(s:local_config)
  execute 'source' fnameescape(s:local_config)
endif

unlet s:local_config
unlet s:config_dir
unlet s:vimrc_dir
