" Test for :mksession, :mkview and :loadview in latin1 encoding

set encoding=latin1
scriptencoding latin1

if !has('multi_byte') || !has('mksession')
  finish
endif

func Test_mksession()
  tabnew
  let wrap_save = &wrap
  set sessionoptions=buffers splitbelow fileencoding=latin1
  call setline(1, [
    \   'start:',
    \   'no multibyte chAracter',
    \   '	one leaDing tab',
    \   '    four leadinG spaces',
    \   'two		consecutive tabs',
    \   'two	tabs	in one line',
    \   'one � multibyteCharacter',
    \   'a� �  two multiByte characters',
    \   'A���  three mulTibyte characters'
    \ ])
  let tmpfile = 'Xtemp'
  exec 'w! ' . tmpfile
  /^start:
  set wrap
  vsplit
  norm! j16|
  split
  norm! j16|
  split
  norm! j16|
  split
  norm! j8|
  split
  norm! j8|
  split
  norm! j16|
  split
  norm! j16|
  split
  norm! j16|
  wincmd l

  set nowrap
  /^start:
  norm! j16|3zl
  split
  norm! j016|3zl
  split
  norm! j016|3zl
  split
  norm! j08|3zl
  split
  norm! j08|3zl
  split
  norm! j016|3zl
  split
  norm! j016|3zl
  split
  norm! j016|3zl
  split
  call wincol()
  mksession! Xtest_mks.out
  let li = filter(readfile('Xtest_mks.out'), 'v:val =~# "\\(^ *normal! 0\\|^ *exe ''normal!\\)"')
  let expected = [
    \   'normal! 016|',
    \   'normal! 016|',
    \   'normal! 016|',
    \   'normal! 08|',
    \   'normal! 08|',
    \   'normal! 016|',
    \   'normal! 016|',
    \   'normal! 016|',
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 8 . '|'",
    \   "  normal! 08|",
    \   "  exe 'normal! ' . s:c . '|zs' . 8 . '|'",
    \   "  normal! 08|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|",
    \   "  exe 'normal! ' . s:c . '|zs' . 16 . '|'",
    \   "  normal! 016|"
    \ ]
  call assert_equal(expected, li)
  tabclose!

  call delete('Xtest_mks.out')
  call delete(tmpfile)
  let &wrap = wrap_save
endfunc

func Test_mksession_winheight()
  new
  set winheight=10 winminheight=2
  mksession! Xtest_mks.out
  source Xtest_mks.out

  call delete('Xtest_mks.out')
endfunc

" vim: shiftwidth=2 sts=2 expandtab
