augroup NewVimTemplateFiletypes
  autocmd!
  autocmd BufRead,BufNewFile *.ejs setfiletype html
  autocmd BufRead,BufNewFile *.dust setfiletype html
augroup END
