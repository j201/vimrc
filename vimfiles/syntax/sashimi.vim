if exists("b:current_syntax")
  finish
endif

syn keyword keywords fn let if module import export

hi def link keywords Keyword
