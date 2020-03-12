" Justfile syntax with regions of other languages

let b:current_syntax = ''
unlet b:current_syntax

syntax keyword  justType            alias

syntax match    specialChar         '\v[^\\]\@'
syntax match    justComment         '#.*$'              display contains=@spell
syntax match    justVarName         '\v[A-Z_]'
syntax match    justVarNameSub      '\v[a-z]'           contained
syntax match    justOperator        '\v:\='
syntax match    justOperator        '\v\='
syntax match    justOperator        '\v\+'

syntax region   justTarget          start='\v^[A-Za-z]' skip='\v\+\=' end='\v:'he=e-1   contains=justString
syntax region   justVarSub          start='{{' end='}}'                                 contains=justVarNameSub
syntax region   justString          start=+'+ skip=+\\'+ end=+'+                        keepend
syntax region   justString          start=+"+ skip=+\\"+ end=+"+                        keepend

" Embedded shell script
" syntax include @sh      syntax/sh.vim
" syntax include @py      syntax/python.vim
" syntax region shEmbed   matchgroup=Shebang start='#!/usr/bin/env sh'       end='#\n' contains=@sh
" syntax region shEmbed   matchgroup=Shebang start='#!/bin/sh'               end='#\n' contains=@sh
" syntax region bashEmbed matchgroup=Shebang start='#!/usr/bin/env bash'     end='#\n' contains=@sh
" syntax region py3Embed  matchgroup=Shebang start='#!/usr/bin/env python3'  end='#\n' contains=@py

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link     justString          String
hi def link     justTarget          Keyword
hi def link     justType            Typedef
hi def link     specialChar         Special
hi def link     justComment         Comment
hi def link     justCommand         String
hi def link     justLabel           Keyword
hi def link     justVarSub          Structure
hi def link     justVarName         Identifier
hi def link     justVarNameSub      Constant
hi def link     justOperator        Operator
" hi def link     Shebang             SpecialComment

let b:current_syntax = 'just'