if exists("g:go_loaded_gotools")
  finish
endif
let g:go_loaded_gotools = 1

function! GoFiles()
 let out=system("go list -f $'{{range $f := .GoFiles}}{{$.Dir}}/{{$f}}\n{{end}}'")
 return out
endfunction

function! s:GoDeps()
 let out=system("go list -f $'{{range $f := .Deps}}{{$f}}\n{{end}}'")
 return out
endfunction

function! g:GoCatchErrors(out, name)
	let errors = []
	for line in split(a:out, '\n')
			let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\s*\(.*\)')
			if !empty(tokens)
					call add(errors, {"filename": @%,
													 \"lnum":     tokens[2],
													 \"text":     tokens[3]})
			endif
	endfor
	if empty(errors)
			% | " Couldn't detect error format, output errors
	endif
	if !empty(errors)
			call setqflist(errors, 'r')
	endif
	echohl Error | echomsg a:name . " returned error" | echohl None
endfunction

function! s:GoRun(...)
  let default_makeprg = &makeprg
  if !len(a:000)
    let &makeprg = "go run " . join(split(GoFiles(), '\n'), ' ')
  else
    let &makeprg = "go run " . expand(a:1)
  endif
	make
  let &makeprg = default_makeprg
endfunction

function! s:GoBuild()
  let default_makeprg = &makeprg
	let gofiles = join(split(GoFiles(), '\n'), ' ')
  if v:shell_error
    let &makeprg = "go build . errors"
  else
    let &makeprg = "go build -o /dev/null " . gofiles
  endif
	make
  let &makeprg = default_makeprg
endfunction

function! s:GoTest()
  let out = system("go test .")
  if v:shell_error
		call g:GoCatchErrors(out, "Go test")
  else
    call setqflist([])
  endif
  cwindow
endfunction

function! s:GoVet()
	let out = s:ExecuteInCurrentDir('go vet')
	let errors = []
	for line in split(out, '\n')
			let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\s*\(.*\)')
			if !empty(tokens)
					call add(errors, {"filename": @%,
													 \"lnum":     tokens[2],
													 \"text":     tokens[3]})
			endif
	endfor
	if !empty(errors)
			call setqflist(errors, 'r')
	endif
  cwindow
endfunction

" Executed the command and returns the output in the directory of the current
" file and returns back to original cwd
function! s:ExecuteInCurrentDir(cmd) abort
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let dir = getcwd()
  try
    execute cd.'`=expand("%:p:h")`'
		let out = system(a:cmd)
  finally
    execute cd.'`=dir`'
  endtry
	return out
endfunction


if !hasmapto('<Plug>(go-run)')
	nnoremap <silent> <Plug>(go-run) :call <SID>GoRun(expand('%'))<CR>
endif

if !hasmapto('<Plug>(go-build)')
	nnoremap <silent> <Plug>(go-build) :call <SID>GoBuild()<CR>
endif

if !hasmapto('<Plug>(go-test)')
	nnoremap <silent> <Plug>(go-test) :call <SID>GoTest()<CR>
endif

if !hasmapto('<Plug>(go-vet)')
	nnoremap <silent> <Plug>(go-vet) :call <SID>GoVet()<CR>
endif

if !hasmapto('<Plug>(go-files)')
	nnoremap <silent> <Plug>(go-files) :call <SID>GoFiles()<CR>
endif

if !hasmapto('<Plug>(go-deps)')
	nnoremap <silent> <Plug>(go-deps) :call <SID>GoDeps()<CR>
endif


command! GoFiles echo GoFiles()
command! GoDeps echo s:GoDeps()
command! GoTest call s:GoTest()
command! GoVet call s:GoVet()
command! -nargs=* -range GoRun call s:GoRun(<f-args>)
command! -range GoBuild call s:GoBuild()
