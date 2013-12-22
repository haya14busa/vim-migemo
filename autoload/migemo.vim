" vim:set ts=8 sts=2 sw=2 tw=0:
"
" migemo.vim
"   Direct search for Japanese with Romaji --- Migemo support script.
"
" Maintainer:  MURAOKA Taro <koron@tka.att.ne.jp>
" Modified:    Yasuhiro Matsumoto <mattn_jp@hotmail.com>
" Last Change: 22 Dec 2013.
"
let s:save_cpo = &cpo
set cpo&vim

function! s:has_vimproc()
    if !exists('s:exists_vimproc')
        try
            silent call vimproc#version()
            let s:exists_vimproc = 1
        catch
            let s:exists_vimproc = 0
        endtry
    endif

    return s:exists_vimproc
endfunction

function! migemo#system(...)
    return call(s:has_vimproc() ? 'vimproc#system' : 'system', a:000)
endfunction

function! s:SearchDict2(name)
  let path = $VIM . ',' . &runtimepath
  let dict = globpath(path, "dict/".a:name)
  if dict == ''
    let dict = globpath(path, a:name)
  endif
  if dict == ''
    for path in [
          \ '/usr/local/share/migemo/',
          \ '/usr/local/share/cmigemo/',
          \ '/usr/local/share/',
          \ '/usr/share/cmigemo/',
          \ '/usr/share/',
          \ ]
      let path = path . a:name
      if filereadable(path)
        let dict = path
        break
      endif
    endfor
  endif
  let dict = matchstr(dict, "^[^\<NL>]*")
  return dict
endfunction

function! s:SearchDict()
  for path in [
        \ 'migemo/'.&encoding.'/migemo-dict',
        \ &encoding.'/migemo-dict',
        \ 'migemo-dict',
        \ ]
    let dict = s:SearchDict2(path)
    if dict != ''
      return dict
    endif
  endfor
  echoerr 'a dictionary for migemo is not found'
  echoerr 'your encoding is '.&encoding
endfunction

if has('migemo')
  if &migemodict == '' || !filereadable(&migemodict)
    let &migemodict = s:SearchDict()
  endif

  " eXg
  function! migemo#SearchChar(dir)
    let input = nr2char(getchar())
    let pat = migemo(input)
    call search('\%(\%#.\{-\}\)\@<='.pat)
    noh
  endfunction
else
  " non-builtin version
  let g:migemodict = s:SearchDict()
  function! migemo#MigemoSearch(word)
    if executable('cmigemo') == ''
      echohl ErrorMsg
      echo 'Error: cmigemo is not installed'
      echohl None
      return
    endif

    let retval = a:word != '' ? a:word : input('MIGEMO:')
    if retval == ''
      return
    endif
    let retval =  migemo#system('cmigemo -v -w "'.retval.'" -d "'.g:migemodict.'"')
    if retval == ''
      return
    endif

    let @/ = retval
    let v:errmsg = ''
    silent! normal n
    if v:errmsg != ''
      echohl ErrorMsg
      echo v:errmsg
      echohl None
    endif
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
