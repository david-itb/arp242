if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'go'
let s:save_cpo = &cpoptions
set cpoptions-=C

" CompilerSet makeprg=go
let &l:makeprg = gopher#str#fold_space(printf('go %s %s %s %s',
      \ gopher#bufsetting('gopher_build_command', 'install'),
      \ gopher#system#join(gopher#bufsetting('gopher_build_flags', [])),
      \ gopher#bufsetting('gopher_build_tags', -1) is# -1 ? '' :
      \     gopher#system#join(['-tags', join(gopher#bufsetting('gopher_build_tags', []), ',')]),
      \ gopher#bufsetting('gopher_build_package', '')))

setl errorformat =%-G#\ %.%#                   " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
setl errorformat+=%-G%.%#panic:\ %m            " Ignore lines containing 'panic: message'
setl errorformat+=%Ecan\'t\ load\ package:\ %m " Start of multiline error string is 'can\'t load package'
setl errorformat+=%A%f:%l:%c:\ %m              " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
setl errorformat+=%A%f:%l:\ %m                 " Start of multiline unspecified string is 'filename:linenumber:'
setl errorformat+=%C%*\\s%m                    " Continuation of multiline error message is indented
setl errorformat+=%-G%.%#                      " All lines not matching any of the above patterns are ignored

let &cpoptions = s:save_cpo
unlet s:save_cpo
