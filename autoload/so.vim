" =============================================================================
" File: vim-so.vim
" Description: Query the Stack Overflow API from Vim.
" Mantainer: Chris Allen Lane (https://chris-allen-lane.com)
" Url: https://github.com/cheat/so.vim
" License: MIT
" Version: 1.0.0
" Last Changed: August 8, 2020
" =============================================================================

" track answers received from Stack Overflow
let s:answers = []

" track answer index
let s:answer_idx = 0

" send a search query to the Stack Overflow API
"{{{
function! so#search(search)
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " new search: reset the answer index
  let s:answer_idx = 0

  " fail if the filetype is unknown
  if &filetype == ""
    call s:warn('query aborted: `filetype` is unknown')
    return
  endif

  " query the Stack Overflow API
  let json = system(printf("%s --json -t %s '%s'", s:bin(), &filetype, a:search))

  " decode and store the JSON response
  let s:answers = json_decode(json)

  " paste the answer
  call s:paste(s:answers[s:answer_idx]['code'])
endfunction
"}}}

" paste the next answer
"{{{
function! so#next()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " if the answers list is empty, display a warning
  if len(s:answers) == 0
    let s:answer_idx = 0
    call s:warn('no answers available')
    return
  endif

  " increment the answer counter
  let s:answer_idx += 1

  " if the answer counter is OOB, point to the last answer
  if len(s:answers) <= s:answer_idx 
    let s:answer_idx = len(s:answers) - 1
    call s:warn('no next answer')
    return
  endif

  " paste the answer
  silent undo
  call s:paste(s:answers[s:answer_idx]['code'])
endfunction
"}}}

" paste the previous answer
"{{{
function! so#prev()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " if the answers list is empty, display a warning
  if len(s:answers) == 0
    let s:answer_idx = 0
    call s:warn('no answers available')
    return
  endif

  " decrement the answer counter
  let s:answer_idx -= 1

  " if the answer counter is OOB, point to the first answer
  if s:answer_idx < 0
    let s:answer_idx = 0
    call s:warn('no previous answer')
    return
  endif

  " paste the answer
  silent undo
  call s:paste(s:answers[s:answer_idx]['code'])
endfunction
"}}}

" opens the stack overflow thread associated with the current answer in a
" browser
"{{{
function! so#view()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " fail if the browser is unset
  if exists('g:so_browser') == 0
    call s:warn('`g:so_browser` is not set: cannot view URL')
    return
  endif

  " fail if the specified browser is not on the PATH
  if executable(g:so_browser) == 0
    call s:warn('browser `' . g:so_browser . '` is not available on the $PATH')
    return 0
  endif

  " if the answers list is empty, display a warning
  if len(s:answers) == 0
    let s:answer_idx = 0
    call s:warn('no answers available')
    return
  endif

  silent execute "!" g:so_browser shellescape(s:answers[s:answer_idx]['link'], '#')
endfunction
"}}}

" helper function that returns the path to the so executable
"{{{
function! s:bin()
  return get(g:, 'so_bin', 'so')
endfunction
"}}}

" helper function that pastes answer text into the buffer
"{{{
function! s:paste(text)
  call s:info("answer", s:answer_idx + 1, "of", len(s:answers))
  silent put = a:text
endfunction
"}}}

" helper that ensurs that the plugin has been properly configured
"{{{
function! s:configured()
  " ensure that `so` is available on the `$PATH`
  if executable(s:bin()) == 0
    call s:warn(s:bin() . ' is not available on the $PATH')
    return 0
  endif

  " if we make it here, we're properly configured
  return 1
endfunction
"}}}

" helper function that displays info
"{{{
function! s:info(...)
  echo 'so:' join(a:000)
endfunction
"}}}

" helper function that displays a warning
"{{{
function! s:warn(...)
  echohl WarningMsg
  echo 'so:' join(a:000)
  echohl None
endfunction
"}}}
