" vim:set ts=8 sts=2 sw=2 tw=0:
"
" migemo.vim
"   Direct search for Japanese with Romaji --- Migemo support script.
"
" Maintainer:  MURAOKA Taro <koron@tka.att.ne.jp>
" Modified:    Yasuhiro Matsumoto <mattn_jp@hotmail.com>
" Last Change: 22 Dec 2013.

" Japanese Description:

if exists('plugin_migemo_disable')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if has('migemo')
  nnoremap <silent> <Plug>(migemo-searchchar) :call migemo#SearchChar(0)<CR>
  if !hasmapto('<Plug>(migemo-searchchar)') && empty(maparg('<Leader>f', 'n'))
    nmap <silent> <Leader>f <Plug>(migemo-searchchar)
  endif
else
  command! -nargs=* Migemo call migemo#MigemoSearch(<q-args>)
  nnoremap <silent> <Plug>(migemo-migemosearch) :call migemo#MigemoSearch('')<CR>
  if !hasmapto('<Plug>(migemo-migemosearch)') && empty(maparg('<Leader>mi', 'n'))
    nmap <silent> <Leader>mi <Plug>(migemo-migemosearch)
  endif
endi

let &cpo = s:save_cpo
unlet s:save_cpo
