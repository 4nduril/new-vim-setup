" Core editor behavior and defaults.

set t_Co=256
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set scrolloff=3
set hidden
set wildmenu
set wildmode=list:longest
set ttyfast
set backspace=indent,eol,start
set undofile
set updatetime=300
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
set showmatch
set wrap
set mouse=a
set splitbelow
set splitright

let s:state_root = expand('~/.vim_bkp-files')
let s:undo_dir = s:state_root . '/.undo'
let s:backup_dir = s:state_root . '/.backup'
let s:swap_dir = s:state_root . '/.swp'

for s:dir in [s:undo_dir, s:backup_dir, s:swap_dir]
  if !isdirectory(s:dir)
    call mkdir(s:dir, 'p')
  endif
endfor

let &undodir = s:undo_dir . '//'
let &backupdir = s:backup_dir . '//'
let &directory = s:swap_dir . '//'

filetype plugin on
filetype indent on
syntax on

unlet s:backup_dir
unlet s:dir
unlet s:state_root
unlet s:swap_dir
unlet s:undo_dir
