" This file is automatically generated by test-syntax from testing.vim

scriptencoding utf-8
call gopher#init#config()

fun! Test_basic() abort
    call TestSyntax(g:test_packdir . '/syntax/testdata/basic.go',
        \ [
        \ [['goPackage', 1, 8]],
        \ [],
        \ [['goImport', 1, 7], ['goString', 8, 12]],
        \ [],
        \ [['goDeclaration', 1, 5]],
        \ [['goVar', 2, 5], ['goType', 10, 16], ['goString', 19, 29]],
        \ [],
        \ [],
    \ ])
endfun

fun! Test_fmt() abort
    call TestSyntax(g:test_packdir . '/syntax/testdata/fmt.go',
        \ [
        \ [['goPackage', 1, 8]],
        \ [],
        \ [['goImport', 1, 7], ['goString', 8, 12]],
        \ [],
        \ [['goVar', 1, 4], ['goString', 21, 21], ['goFormatSpecifier', 22, 22], ['goString', 24, 25], ['goString', 27, 30]],
    \ ])
endfun

fun! Test_builtin() abort
    call TestSyntax(g:test_packdir . '/syntax/testdata/builtin.go',
        \ [
        \ [['goPackage', 1, 8]],
        \ [],
        \ [['goImport', 1, 7], ['goString', 8, 12]],
        \ [],
        \ [['goVar', 1, 4], ['goBuiltins', 5, 8], ['goDecimalInt', 11, 11]],
        \ [],
        \ [['goDeclaration', 1, 5], ['goBuiltins', 6, 12]],
        \ [],
        \ [['goDeclaration', 1, 5]],
        \ [['goBuiltins', 2, 8], ['goDecimalInt', 12, 12]],
        \ [['goBuiltins', 11, 17]],
        \ [['goBuiltins', 6, 12]],
        \ [],
        \ [['goBuiltins', 14, 17], ['goString', 18, 20]],
        \ [],
        \ [],
        \ [['goDeclaration', 1, 5]],
        \ [],
        \ [['goDeclaration', 1, 5], ['goType', 20, 23]],
        \ [],
        \ [['goDeclaration', 1, 5], ['goType', 21, 24], ['goType', 31, 34]],
        \ [],
        \ [['goDeclaration', 1, 5]],
        \ [['goType', 7, 10]],
        \ [['goType', 7, 10]],
        \ [],
        \ [],
        \ [],
        \ [['goDeclaration', 1, 5]],
        \ [],
        \ [['goType', 8, 11]],
        \ [['goVar', 2, 5], ['goType', 8, 11], ['goDecimalInt', 14, 14]],
        \ [['goVar', 2, 5], ['goType', 10, 13], ['goDecimalInt', 14, 15]],
        \ [['goVar', 2, 5], ['goType', 8, 10]],
        \ [['goType', 8, 12], ['goString', 13, 16]],
        \ [['goType', 14, 17], ['goDecimalInt', 18, 19], ['goType', 22, 25], ['goDecimalInt', 26, 27]],
        \ [],
        \ [['goConditional', 2, 4], ['goType', 10, 14], ['goBoolean', 15, 19]],
        \ [],
        \ [],
        \ [],
        \ [['goDeclaration', 1, 5], ['goType', 17, 20]],
        \ [],
    \ ])
endfun
