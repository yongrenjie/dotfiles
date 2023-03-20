function! ocaml#ToggleImplIntf() abort
    let fname = expand('%:p')
    if fname =~ '\v\.ml$'
        let is_ml = 1
        let new_fname = fname . "i"
    elseif fname =~ '\v\.mli$'
        let is_ml = 0
        let new_fname = fname[:-2]
    else
        echoerr 'Not in .ml or .mli file'
        return
    endif

    " Get current top-level definition/declaration
    let identifier = v:null
    let search_string = ''
    if is_ml
        let identifier_lineno = search('\v^(let|type)', 'bcnW')
        if identifier_lineno != 0
            let line = getline(identifier_lineno)
            let identifier = matchlist(line, '\v^(let|type)\s*([A-Za-z_][A-Za-z0-9_'']*)')
            if len(identifier) >= 3
                if identifier[1] == 'let'
                    let search_string = 'val ' . identifier[2]
                elseif identifier[1] == 'type'
                    let search_string = 'type '. identifier[2]
                endif
            endif
        endif
    else
        " in mli file
        let identifier_lineno = search('\v^(val|type)', 'bcnW')
        if identifier_lineno != 0
            let line = getline(identifier_lineno)
            let identifier = matchlist(line, '\v^(val|type)\s*([A-Za-z_][A-Za-z0-9_'']*)')
            if len(identifier) >= 3
                if identifier[1] == 'val'
                    let search_string = 'let ' . identifier[2]
                elseif identifier[1] == 'type'
                    let search_string = 'type '. identifier[2]
                endif
            endif
        endif
    endif

    execute 'edit ' . fnamemodify(new_fname, ':~:.')
    echomsg search_string
    if !empty(search_string)
        call search(search_string, 'cw')
    endif
endfunction
