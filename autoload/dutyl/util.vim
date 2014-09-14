"Checks if the path is an absolute path
function! dutyl#util#isPathAbsolute(path) abort
    if has('win32')
        return a:path=~':' || a:path[0]=='%' "Absolute paths in Windows contain : or start with an environment variable
    else
        return a:path[0]=~'\v^[/~$]' "Absolute paths in Linux start with ~(home),/(root dir) or $(environment variable)
    endif
endfunction

"Exactly what it says on the tin
function! dutyl#util#cleanPathFromLastCharacterIfPathSeparator(path) abort
    let l:lastCharacter=a:path[len(a:path)-1]
    if '/'==l:lastCharacter || '\'==l:lastCharacter
        return a:path[0:-2]
    else
        return a:path
    endif
endfunction

"Glob a list of paths
function! dutyl#util#globPaths(paths) abort
    let l:result=[]
    for l:path in a:paths
        let l:result+=glob(l:path,1,1)
    endfor
    return l:result
endfunction

"Convert a list of paths and path patterns to a list of absolute, concrete
"paths without the last path separator.
function! dutyl#util#normalizePaths(paths) abort
    let l:result=dutyl#util#globPaths(a:paths)
    let l:result=map(l:result,'fnamemodify(v:val,":p")')
    let l:result=map(l:result,'dutyl#util#cleanPathFromLastCharacterIfPathSeparator(v:val)')
    let l:result=dutyl#util#unique(l:result)
    return l:result
endfunction

"Use with argument 's' to split the window horizontally or with 'v' to split
"vertically.
function! dutyl#util#splitWindowBasedOnArgument(splitType)
    if 's'==a:splitType
        split
    elseif 'v'==a:splitType
        vsplit
    endif
endfunction

"Split based on any newline character.
function! dutyl#util#splitLines(text) abort
    if type([])==type(a:text)
        return a:text
    elseif type('')==type(a:text)
        return split(a:text,'\v\r\n|\n|\r')
    endif
endfunction

"Exactly what it says on the tin. Arguments:
" - newItems: a list in the same format as the one you send to
"   setqflist/setloclist
" - targetList: 'c'/'q' for the quickfix list, 'l' for the location list
" - jump: nonzero value to automatically jump to the first entry
function! dutyl#util#setQuickfixOrLocationList(newItems,targetList,jump) abort
    if 'c'==a:targetList || 'q'==a:targetList
        call setqflist(a:newItems)
    elseif 'l'==a:targetList
        call setloclist(0,a:newItems)
    endif
    if a:jump && !empty(a:newItems)
        if 'c'==a:targetList || 'q'==a:targetList
            cc 1
        elseif 'l'==a:targetList
            ll 1
        endif
    endif
endfunction

"Exactly what it says on the tin
function! dutyl#util#unique(list) abort
    if exists('*uniq') "Use built-in uniq if possible
        return uniq(a:list)
    endif
    if empty(a:list)
        return []
    endif
    let l:sorted=sort(a:list)
    let l:result=[l:sorted[0]]
    for l:entry in l:sorted[1:]
        if l:entry!=l:result[-1]
            call add(l:result,l:entry)
        endif
    endfor
    return l:result
endfunction
