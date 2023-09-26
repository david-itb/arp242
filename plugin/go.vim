" install necessary Go tools
if exists("g:go_loaded_install")
    finish
endif
let g:go_loaded_install = 1

" these packages are used by vim-go and can be automatically installed if
" needed by the user with GoInstallBinaries
let s:packages = [
            \ "github.com/nsf/gocode",
            \ "golang.org/x/tools/cmd/goimports",
            \ "code.google.com/p/rog-go/exp/cmd/godef",
            \ "golang.org/x/tools/cmd/oracle",
            \ "golang.org/x/tools/cmd/gorename",
            \ "github.com/golang/lint/golint",
            \ "github.com/kisielk/errcheck",
            \ "github.com/jstemmer/gotags",
            \ ]

" Commands
command! GoErrCheck call go#errcheck#Run()

command! GoInstallBinaries call s:GoInstallBinaries(-1)
command! GoUpdateBinaries call s:GoInstallBinaries(1)

" IsWin returns 1 if current OS is Windows or 0 otherwise
function! IsWin()
    let win = ['win16', 'win32', 'win32unix', 'win64', 'win95']
    for w in win
        if (has(w))
            return 1
        endif
    endfor

    return 0
endfunction

" PathSep returns the appropriate path separator based on OS.
function! PathSep()
    if IsWin()
        return ";"
    endif

    return ":"
endfunction

" DefaultGoPath returns the default GOPATH.
" If there is only one GOPATH it returns that, otherwise it returns the first one.
function! DefaultGoPath()
    let go_paths = split($GOPATH, PathSep())

    if len(go_paths) == 1
        return $GOPATH
    endif

    return go_paths[0]
endfunction

" GetBinPath returns the binary path of installed go tools
function! GetBinPath()
    let bin_path = ""

    " check if our global custom path is set, if not check if $GOBIN is set so
    " we can use it, otherwise use $GOPATH + '/bin'
    if exists("g:go_bin_path")
        let bin_path = g:go_bin_path
    elseif $GOBIN != ""
        let bin_path = $GOBIN
    elseif $GOPATH != ""
        let bin_path = expand(DefaultGoPath() . "/bin/")
    else
        " could not find anything
    endif

    return bin_path
endfunction

" GoInstallBinaries downloads and install all necessary binaries stated in the
" packages variable. It uses by default $GOBIN or $GOPATH/bin as the binary
" target install directory. GoInstallBinaries doesn't install binaries if they
" exist, to update current binaries pass 1 to the argument.
function! s:GoInstallBinaries(updateBinaries)
    if $GOPATH == ""
        echohl Error
        echomsg "vim.go: $GOPATH is not set"
        echohl None
        return
    endif

    let err = s:CheckBinaries()
    if err != 0
        return
    endif

    let go_bin_path = GetBinPath()

    " change $GOBIN so go get can automatically install to it
    let $GOBIN = go_bin_path

    " old_path is used to restore users own path
    let old_path = $PATH

    " vim's executable path is looking in PATH so add our go_bin path to it
    let $PATH = $PATH . ":" .go_bin_path

    for pkg in s:packages
        let basename = fnamemodify(pkg, ":t")
        let binname = "go_" . basename . "_bin"

        let bin = basename
        if exists("g:{binname}")
            let bin = g:{binname}
        endif

        if !executable(bin) || a:updateBinaries == 1
            if a:updateBinaries == 1
                echo "vim-go: Updating ". basename .". Reinstalling ". pkg . " to folder " . go_bin_path
            else
                echo "vim-go: ". basename ." not found. Installing ". pkg . " to folder " . go_bin_path
            endif

            let out = system("go get -u -v ".shellescape(pkg))
            if v:shell_error
                echo "Error installing ". pkg . ": " . out
            endif
        endif
    endfor

    " restore back!
    let $PATH = old_path
endfunction

" CheckBinaries checks if the necessary binaries to install the Go tool
" commands are available.
function! s:CheckBinaries()
    if !executable('go')
        echohl Error | echomsg "vim-go: go executable not found." | echohl None
        return -1
    endif

    if !executable('git')
        echohl Error | echomsg "vim-go: git executable not found." | echohl None
        return -1
    endif

    if !executable('hg')
        echohl Error | echomsg "vim.go: hg (mercurial) executable not found." | echohl None
        return -1
    endif
endfunction

" vim:ts=4:sw=4:et
