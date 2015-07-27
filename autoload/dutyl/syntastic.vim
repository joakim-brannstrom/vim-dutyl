function! dutyl#syntastic#updateSyntasticDMDPath() abort
    " Allows the user to toggle activation of event processing in runtime.
    if exists('g:dutyl_disableSyntasticEvent')
        return
    endif

    " If dutyl can't provide compiler flags fallback on syntastic/D internal
    " handling.
    try
        let l:dutyl = dutyl#core#requireFunctions('importPaths', 'stringImportPaths')
        let l:importPaths = l:dutyl.importPaths()
        let l:stringImportPaths = l:dutyl.stringImportPaths()
        let g:syntastic_d_dmd_external_configure = 1
    catch "Fallback
        let g:syntastic_d_dmd_external_configure = 0
        return
    endtry

    let l:dmdFlags = ''
    for l:path in l:importPaths
        let l:dmdFlags = l:dmdFlags.' -I'.l:path
    endfor
    for l:path in l:stringImportPaths
        let l:dmdFlags = l:dmdFlags.' -J'.l:path
    endfor

    let g:syntastic_d_dmd_post_args = l:dmdFlags
endfunction
