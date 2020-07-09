if exists("b:current_syntax")
    finish
endif

" Easy keyword matches
syntax keyword brukGradBlk BLKGRAD UNBLKGRAD
syntax keyword brukAcqu ze zd st0 st exit
syntax match brukAcqu "go=\?" nextgroup=brukLabelName
syntax match brukAcqu "goscnp=\?" nextgroup=brukLabelName
syntax match brukFileMgmt "wr #\d\+"
syntax match brukFileMgmt "if #\d\+"
highlight link brukGradBlk Conditional
highlight link brukAcqu Conditional
highlight link brukFileMgmt Conditional

" Decoupling
syntax match brukDecouple "cpd[1-8]:f\d"
syntax match brukDecouple "do:f\d"
highlight link brukDecouple Boolean

" Operators
syntax match brukOperator "\V+\|*\|-\|/\|="
highlight link brukOperator Operator

" Durations and other constants
" Here we need a negative lookahead to not match the goto labels.
syntax match brukNumber "\(^\)\@<!\<\d\+\(\.\d\+\)\?\>"
syntax keyword brukNumber PI EA
syntax match brukTime "\<\d\+\(\.\d\+\)\?[smu]\>"
highlight link brukTime Number
highlight link brukNumber Number

" Looping commands
syntax match brukLoop "lo to" nextgroup=brukLabelName skipwhite
syntax match brukLabelName "\S\+" contained nextgroup=brukTimes skipwhite
syntax match brukTimes "times" contained nextgroup=brukLoopCounter skipwhite
syntax match brukLoopCounter "\S\+" contained contains=brukNumber
highlight link brukLoop Repeat
" highlight link brukLabelName Repeat
highlight link brukTimes Repeat
" highlight link brukLoopCounter Repeat

" Definitions
syntax region brukDefine matchgroup=String start="^\"" end="\"" oneline
            \ contains=brukParameter,brukTime,brukNumber,brukOperator
syntax match brukParameter "[^="]\+\ze=" contained
highlight link brukParameter Identifier

" Power levels
syntax match brukPowerLevel "pl\d\{1,2}:f\d"
highlight link brukPowerLevel Statement

" Gradients
syntax match brukGradients "p\d\{1,2}:gp\d\{1,2}"
" highlight link brukGradients String

" Pulses
" This one matches generic pulses.
syntax match brukPulse "(p\d\{1,2}\(:sp\d\{1,2}\)\? ph\d\{1,2})" nextgroup=brukPulseChannel
syntax match brukPulse "(p\d\{1,2}\(:sp\d\{1,2}\)\? ph\d\{1,2} p\d\{1,2}\(:sp\d\{1,2}\)\? ph\d\{1,2})" nextgroup=brukPulseChannel
" Just for personal use here...
syntax match brukPulse "(p\d\{1,2}\(:sp\d\{1,2}\)\? phASAP\d\{1,2})" nextgroup=brukPulseChannel
syntax match brukPulse "p\d\{1,2}\(:sp\d\{1,2}\)\? ph\d\{1,2}"
syntax match brukPulseChannel ":f\d\{1,2}" contained
highlight link brukPulse String
highlight link brukPulseChannel Delimiter

" C preprocessor stuff
" There's probably a smarter way to do it, see e.g. the C syntax file that
" ships with Vim, but I don't want to get too far ahead of myself.
syntax match brukIncluded "#include <.\+>" contains=brukIncludedFile
syntax match brukIncluded "#include \".\+\"" contains=brukIncludedFile
syntax match brukIncludedFile "<.\+>" contained
syntax match brukIncludedFile "\".\+\"" contained
highlight link brukIncluded Include
highlight link brukIncludedFile String

syntax match brukIfdef "#ifdef [A-Za-z0-9_]\+"
syntax match brukElse "#else"
syntax match brukEndif "#endif"
highlight link brukIfdef Structure
highlight link brukElse Structure
highlight link brukEndif Structure

syntax match brukDefineDelay "define delay" nextgroup=brukDelayName skipwhite
syntax match brukDelayName "\S\+" contained
highlight link brukDefineDelay Structure
highlight link brukDelayName Identifier

" Comments
syntax region brukComment start=";" end="$" oneline
syntax region brukComment start="//" end="$" oneline
syntax region brukComment start="/\*" end="\*/"
highlight link brukComment Comment

" Fast syncing. I don't think there's anything inside here that stretches over
" lines, except for C-style multiline comments.
syntax sync match brukSync grouphere NONE '$'
syntax sync maxlines=5

let b:current_syntax = "bruker"
