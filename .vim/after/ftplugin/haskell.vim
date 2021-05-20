let maplocalleader='\'

" Quickly test in ghci. I think there should be a better way of doing this
" using something like makeprg, for example.
nnoremap <buffer> <localleader>m :below term ++close ++rows=15 ghci % <CR>
let g:asyncrun_open=10
nnoremap <silent><buffer> <localleader>h :w<CR> :AsyncRun cd $SOURCE_DIR; cabal haddock; cd - <CR>

" Formatting.
set textwidth=80
set tabstop=2
set shiftwidth=2
set formatprg=brittany

setlocal iskeyword+=@-@,',$,<,>,\",!,\|,/,~,%,^

iabbrev itext import Data.Text (Text)<CR>import qualified Data.Text as T
iabbrev itio import qualified Data.Text.IO as TIO
iabbrev imap import Data.Map (Map)<CR>import qualified Data.Map as M
iabbrev iset import Data.Set (Set)<CR>import qualified Data.Set as S
iabbrev iim import Data.IntMap (IntMap)<CR>import qualified Data.IntMap as IM
iabbrev iintmap import Data.IntMap (IntMap)<CR>import qualified Data.IntMap as IM
iabbrev iis import Data.IntSet (IntSet)<CR>import qualified Data.IntSet as IS
iabbrev iintset import Data.IntSet (IntSet)<CR>import qualified Data.IntSet as IS
iabbrev ine import Data.List.NonEmpty (NonEmpty)<CR>import qualified Data.List.NonEmpty as NE
