function! go#config#AutodetectGopath() abort
	return get(g:, 'go_autodetect_gopath', 0)
endfunction

function! go#config#ListTypeCommands() abort
  return get(g:, 'go_list_type_commands', {})
endfunction

function! go#config#VersionWarning() abort
  return get(g:, 'go_version_warning', 1)
endfunction

function! go#config#BuildTags() abort
  return get(g:, 'go_build_tags', '')
endfunction

function! go#config#SetBuildTags(value) abort
  if a:value == ""
    if exists('g:go_build_tags')
      unlet g:go_build_tags
    endif
    return
  endif

  let g:go_build_tags = a:value
endfunction

function! go#config#TestTimeout() abort
 return get(g:, 'go_test_timeout', '10s')
endfunction

function! go#config#TestShowName() abort
  return get(g:, 'go_test_show_name', 0)
endfunction

function! go#config#TermHeight() abort
  return get(g:, 'go_term_height', winheight(0))
endfunction

function! go#config#TermWidth() abort
  return get(g:, 'go_term_width', winwidth(0))
endfunction

function! go#config#TermMode() abort
  return get(g:, 'go_term_mode', 'vsplit')
endfunction

function! go#config#TermEnabled() abort
  return get(g:, 'go_term_enabled', 0)
endfunction

function! go#config#SetTermEnabled(value) abort
  let g:go_term_enabled = a:value
endfunction

function! go#config#TemplateUsePkg() abort
  return get(g:, 'go_template_use_pkg', 0)
endfunction

function! go#config#TemplateTestFile() abort
  return get(g:, 'go_template_test_file', "hello_world_test.go")
endfunction

function! go#config#TemplateFile() abort
  return get(g:, 'go_template_file', "hello_world.go")
endfunction

function! go#config#StatuslineDuration() abort
  return get(g:, 'go_statusline_duration', 60000)
endfunction

function! go#config#SnippetEngine() abort
  return get(g:, 'go_snippet_engine', 'automatic')
endfunction

function! go#config#PlayBrowserCommand() abort
    if go#util#IsWin()
        let go_play_browser_command = '!start rundll32 url.dll,FileProtocolHandler %URL%'
    elseif go#util#IsMac()
        let go_play_browser_command = 'open %URL%'
    elseif executable('xdg-open')
        let go_play_browser_command = 'xdg-open %URL%'
    elseif executable('firefox')
        let go_play_browser_command = 'firefox %URL% &'
    elseif executable('chromium')
        let go_play_browser_command = 'chromium %URL% &'
    else
        let go_play_browser_command = ''
    endif

    return get(g:, 'go_play_browser_command', go_play_browser_command)
endfunction

function! go#config#MetalinterDeadline() abort
  " gometalinter has a default deadline of 5 seconds only when asynchronous
  " jobs are not supported.

  let deadline = '5s'
  if go#util#has_job() && has('lambda')
    let deadline = ''
  endif

  return get(g:, 'go_metalinter_deadline', deadline)
endfunction

function! go#config#ListType() abort
  return get(g:, 'go_list_type', '')
endfunction

function! go#config#ListAutoclose() abort
  return get(g:, 'go_list_autoclose', 1)
endfunction

function! go#config#InfoMode() abort
  return get(g:, 'go_info_mode', 'gocode')
endfunction

function! go#config#GuruScope() abort
  let scope = get(g:, 'go_guru_scope', [])

  if !empty(scope)
    " strip trailing slashes for each path in scope. bug:
    " https://github.com/golang/go/issues/14584
    let scopes = go#util#StripTrailingSlash(scope)
  endif

  return scope
endfunction

function! go#config#SetGuruScope(scope) abort
  if empty(a:scope)
    if exists('g:go_guru_scope')
      unlet g:go_guru_scope
    endif
  else
    let g:go_guru_scope = a:scope
  endif
endfunction

function! go#config#GocodeUnimportedPackages() abort
  return get(g:, 'go_gocode_unimported_packages', 0)
endfunction

let s:sock_type = (has('win32') || has('win64')) ? 'tcp' : 'unix'
function! go#config#GocodeSocketType() abort
  return get(g:, 'go_gocode_socket_type', s:sock_type)
endfunction

function! go#config#GocodeProposeBuiltins() abort
  return get(g:, 'go_gocode_propose_builtins', 1)
endfunction

function! go#config#GocodeAutobuild() abort
  return get(g:, 'go_gocode_autobuild', 1)
endfunction

function! go#config#EchoCommandInfo() abort
  return get(g:, 'go_echo_command_info', 1)
endfunction

function! go#config#DocUrl() abort
  let godoc_url = get(g:, 'go_doc_url', 'https://godoc.org')
  if godoc_url isnot 'https://godoc.org'
    " strip last '/' character if available
    let last_char = strlen(godoc_url) - 1
    if godoc_url[last_char] == '/'
      let godoc_url = strpart(godoc_url, 0, last_char)
    endif
    " custom godoc installations expect /pkg before package names
    let godoc_url .= "/pkg"
  endif
  return godoc_url
endfunction

function! go#config#DefReuseBuffer() abort
  return get(g:, 'go_def_reuse_buffer', 0)
endfunction

function! go#config#DefMode() abort
  return get(g:, 'go_def_mode', 'guru')
endfunction

function! go#config#DeclsIncludes() abort
  return get(g:, 'go_decls_includes', 'func,type')
endfunction

function! go#config#Debug() abort
  return get(g:, 'go_debug', [])
endfunction

function! go#config#DebugWindows() abort
  return get(g:, 'go_debug_windows', {
            \ 'stack': 'leftabove 20vnew',
            \ 'out':   'botright 10new',
            \ 'vars':  'leftabove 30vnew',
            \ }
         \ )

endfunction

function! go#config#DebugAddress() abort
  return get(g:, 'go_debug_address', '127.0.0.1:8181')
endfunction

function! go#config#DebugCommands() abort
  " make sure g:go_debug_commands is set so that it can be added to easily.
  let g:go_debug_commands = get(g:, 'go_debug_commands', {})
  return g:go_debug_commands
endfunction

function! go#config#SetDebugDiag(value) abort
  let g:go_debug_diag = a:value
endfunction

function! go#config#AutoSameids() abort
    return get(g:, 'go_auto_sameids', 0)
endfunction

function! go#config#SetAutoSameids(value) abort
  let g:go_auto_sameids = a:value
endfunction

function! go#config#AddtagsTransform() abort
  return get(g:, 'go_addtags_transform', "snakecase")
endfunction

function! go#config#TemplateAutocreate() abort
  return get(g:, "go_template_autocreate", 1)
endfunction

function! go#config#SetTemplateAutocreate(value) abort
  let g:go_template_autocreate = a:value
endfunction

function! go#config#MetalinterCommand() abort
  return get(g:, "go_metalinter_command", "")
endfunction

function! go#config#MetalinterAutosaveEnabled() abort
  return get(g:, 'go_metalinter_autosave_enabled', ['vet', 'golint'])
endfunction

function! go#config#MetalinterEnabled() abort
  return get(g:, "go_metalinter_enabled", ['vet', 'golint', 'errcheck'])
endfunction

function! go#config#MetalinterDisabled() abort
  return get(g:, "go_metalinter_disabled", [])
endfunction

function! go#config#GolintBin() abort
  return get(g:, "go_golint_bin", "golint")
endfunction

function! go#config#ErrcheckBin() abort
  return get(g:, "go_errcheck_bin", "errcheck")
endfunction

function! go#config#MetalinterAutosave() abort
  return get(g:, "go_metalinter_autosave", 0)
endfunction

function! go#config#SetMetalinterAutosave(value) abort
  let g:go_metalinter_autosave = a:value
endfunction

function! go#config#ListHeight() abort
  return get(g:, "go_list_height", 0)
endfunction

function! go#config#FmtAutosave() abort
	return get(g:, "go_fmt_autosave", 1)
endfunction

function! go#config#SetFmtAutosave(value) abort
  let g:go_fmt_autosave = a:value
endfunction

function! go#config#AsmfmtAutosave() abort
  return get(g:, "go_asmfmt_autosave", 0)
endfunction

function! go#config#SetAsmfmtAutosave(value) abort
  let g:go_asmfmt_autosave = a:value
endfunction

function! go#config#DocMaxHeight() abort
  return get(g:, "go_doc_max_height", 20)
endfunction

function! go#config#AutoTypeInfo() abort
  return get(g:, "go_auto_type_info", 0)
endfunction

function! go#config#SetAutoTypeInfo(value) abort
  let g:go_auto_type_info = a:value
endfunction

function! go#config#AlternateMode() abort
  return get(g:, "go_alternate_mode", "edit")
endfunction

" vim: sw=2 ts=2 et
