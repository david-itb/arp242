" This file is automatically generated by test-syntax from testing.vim

fun! Test_invalid_numbers() abort
    call TestSyntax(g:test_packdir . '/syntax/testdata/invalid_numbers.go',
        \ [
        \ [['goBuildTagStart', 1, 1], ['goBuildTag', 3, 3], ['goBuildKeyword', 4, 4], ['goBuildTag', 10, 20]],
        \ [],
        \ [['goPackage', 1, 8]],
        \ [],
        \ [['goVar', 1, 4]],
        \ [['goOctalError', 22, 25]],
        \ [['goOctalError', 22, 26]],
        \ [['goOctalError', 22, 30]],
        \ [['goBinaryError', 22, 27]],
        \ [['goHexError', 22, 25]],
        \ [],
        \ [['goComment', 3, 58]],
        \ [],
        \ [['goDecimalInt', 22, 24]],
        \ [['goDecimalInt', 22, 25]],
        \ [['goFloat', 22, 26]],
        \ [['goFloat', 22, 26]],
        \ [],
    \ ])
endfun
