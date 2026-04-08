" UI-related settings.

set showmode
set cursorline
set list
set listchars=tab:\.\ ,eol:¬
set ruler
set laststatus=2
set relativenumber
set background=dark

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme gruvbox

augroup NewVimUiRedraw
  autocmd!
  autocmd VimEnter * redraw!
augroup END
