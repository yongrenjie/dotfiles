" Macro parameters
syntax match ltx_parameters "#[1-9]"
highlight link ltx_parameters Identifier

" LaTeX 3 macros.
if exists("b:is_sty")
    if b:is_sty
        syntax match l3_macros "\\[A-Za-z_]*[:]\=[DNncVvoxfTFpw]*"
        " In principle the : has to be there, but I don't like the colour
        " changing halfway through when typing a command.
        highlight link l3_macros Statement
    endif
endif

