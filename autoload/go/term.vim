if has('nvim') && !exists("g:go_term_mode")
  let g:go_term_mode = 'vsplit'
endif

" new creates a new terminal with the given command. Mode is set based on the
" global variable g:go_term_mode, which is by default set to :vsplit
function! go#term#new(bang, cmd) abort
  return go#term#newmode(a:bang, a:cmd, g:go_term_mode)
endfunction

" new creates a new terminal with the given command and window mode.
function! go#term#newmode(bang, cmd, mode) abort
  let mode = a:mode
  if empty(mode)
    let mode = g:go_term_mode
  endif

  let state = {
        \ 'cmd': a:cmd,
        \ 'bang' : a:bang,
        \ 'winnr': winnr(),
        \ 'stdout': [],
        \ 'stderr': []
      \ }

  " execute go build in the files directory
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let dir = getcwd()

  execute cd . fnameescape(expand("%:p:h"))

  execute mode.' __go_term__'

  setlocal filetype=goterm
  setlocal bufhidden=delete
  setlocal winfixheight
  setlocal noswapfile
  setlocal nobuflisted

  " explicitly bind callbacks to state so that within them, self will always
  " refer to state. See :help Partial for more information.
  let job = {
        \ 'on_stdout': function('s:on_stdout', [], state),
        \ 'on_stderr': function('s:on_stderr', [], state),
        \ 'on_exit' : function('s:on_exit', [], state),
        \ }

  let state.id = termopen(a:cmd, job)
  let state.termwinnr = winnr()

  execute cd . fnameescape(dir)

  startinsert

  " resize new term if needed.
  let height = get(g:, 'go_term_height', winheight(0))
  let width = get(g:, 'go_term_width', winwidth(0))

  " Adjust the window width or height depending on whether it's a vertical or
  " horizontal split.
  if mode =~ "vertical" || mode =~ "vsplit" || mode =~ "vnew"
    exe 'vertical resize ' . width
  elseif mode =~ "split" || mode =~ "new"
    exe 'resize ' . height
  endif

  " we also need to resize the pty, so there you go...
  call jobresize(state.id, width, height)

  stopinsert

  if state.winnr !=# winnr()
    exe state.winnr . "wincmd w"
  endif

  return state.id
endfunction

function! s:on_stdout(job_id, data, event) dict abort
  call extend(self.stdout, a:data)
endfunction

function! s:on_stderr(job_id, data, event) dict abort
    call extend(self.stderr, a:data)
endfunction

function! s:on_exit(job_id, exit_status, event) dict abort
  let l:listtype = go#list#Type("_term")

  " usually there is always output so never branch into this clause
  if empty(self.stdout)
    call s:cleanlist(self.winnr, l:listtype)
    return
  endif

  let errors = go#tool#ParseErrors(self.stdout)
  let errors = go#tool#FilterValids(errors)

  if !empty(errors)
    " close terminal; we don't need it anymore
    execute self.termwinnr . "close"

    if self.winnr !=# winnr()
      execute self.winnr . "wincmd w"
    endif

    call go#list#Populate(l:listtype, errors, self.cmd)
    call go#list#Window(l:listtype, len(errors))
    if !self.bang
      call go#list#JumpToFirst(l:listtype)
    endif

    return
  endif

  call s:cleanlist(self.winnr, l:listtype)
endfunction

function s:cleanlist(winnr, listtype) abort
  " There are no errors. Clean and close the list. Jump to the window to which
  " the location list is attached, close the list, and then jump back to the
  " current window.
  let l:winnr = winnr()
  execute a:winnr . "wincmd w"
  call go#list#Clean(a:listtype)
  execute l:winnr . "wincmd w"
endfunction

" vim: sw=2 ts=2 et
