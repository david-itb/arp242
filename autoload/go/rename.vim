if !exists("g:go_gorename_bin")
	let g:go_gorename_bin = "gorename"
endif

function! go#rename#Rename(...)
	let to = ""
	if a:0 == 0
		let ask = printf("vim-go: rename '%s' to: ",  expand("<cword>"))
		let to = input(ask)
	else
		let to = a:1
	endif

	"return with a warning if the bin doesn't exist
	let bin_path = go#tool#BinPath(g:go_gorename_bin) 
	if empty(bin_path) 
		return 
	endif

	let fname = expand('%:p:t')
	let pos = s:getpos(line('.'), col('.'))
	let cmd = printf('%s -offset %s:#%d -to %s',  bin_path, shellescape(fname), pos, to)

	let out = system(cmd)

	" strip out newline on the end that gorename puts. If now it will trigger
	" the 'Hit ENTER to continue' prompt
	let clean = split(out, '\n')

	if v:shell_error
		redraw | echon "vim-go: " | echohl Statement | echon clean[0] | echohl None
	else
		redraw | echon "vim-go: " | echohl Function | echon clean[0] | echohl None
	endif

	" refresh the buffer so we can see the new content
	silent execute ":e"
endfunction

func! s:getpos(l, c)
	if &encoding != 'utf-8'
		let buf = a:l == 1 ? '' : (join(getline(1, a:l-1), "\n") . "\n")
		let buf .= a:c == 1 ? '' : getline('.')[:a:c-2]
		return len(iconv(buf, &encoding, 'utf-8'))
	endif
	return line2byte(a:l) + (a:c-2)
endfun
