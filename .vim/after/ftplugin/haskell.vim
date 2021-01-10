let maplocalleader='\'

" Quickly test in ghci. I think there should be a better way of doing this
" using something like makeprg, for example.
nnoremap <buffer> <localleader>m :below term ++close ++rows=15 ghci % <CR>

" Formatting.
set tabstop=2
set shiftwidth=2
set formatprg=brittany

" Hoogle lookup, from /u/pdr77
setlocal keywordprg=hoogle-info   " requires hoogle and lambdabot executables
" nnoremap <silent> K <Cmd>call ReadMan(expand('<cword>'))<CR>
setlocal iskeyword+=@-@,',$,<,>,\",!,\|,/,~,%,^

iabbrev itext import Data.Text (Text)<CR>import qualified Data.Text as T
iabbrev imap import Data.Map (Map)<CR>import qualified Data.Map as M
iabbrev iset import Data.Set (Set)<CR>import qualified Data.Set as S
