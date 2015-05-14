## Here are some misc. commandlets that some folks don't often think to use.

Start with two files with some space-delimited data
```bash
gmaciolek@testsvr:~$ cat foo1; echo; cat foo2  
f1col1line1 f1col2line1 f1col3line1
f1col2line2 f1col2line2 f1col3line2
f1col2line3 f1col2line3 f1col3line3

f2col1line1 f2col2line1 f2col3line1
f2col2line2 f2col2line2 f2col3line2
f2col2line3 f2col2line3 f2col3line3
```
Prepend (10-digit formatted) incrementing numbers
```bash
gmaciolek@testsvr:~$ awk '{printf("%010d %s\n", NR, $0)}'
gmaciolek@testsvr:~$ awk '{printf("%010d %s\n", NR, $0)}'
````
Display multiple files w/names "starting with line 1"
````bash
gmaciolek@testsvr:~$ tail -n +1 foo1 foo1e foo2 foo2e
==> foo1 <==
f1col1line1 f1col2line1 f1col3line1
f1col2line2 f1col2line2 f1col3line2
f1col2line3 f1col2line3 f1col3line3

==> foo1e <==
0000000001 f1col1line1 f1col2line1 f1col3line1
0000000002 f1col2line2 f1col2line2 f1col3line2
0000000003 f1col2line3 f1col2line3 f1col3line3

==> foo2 <==
f2col1line1 f2col2line1 f2col3line1
f2col2line2 f2col2line2 f2col3line2
f2col2line3 f2col2line3 f2col3line3

==> foo2e <==
0000000001 f2col1line1 f2col2line1 f2col3line1
0000000002 f2col2line2 f2col2line2 f2col3line2
0000000003 f2col2line3 f2col2line3 f2col3line3
```
Join *matching* lines (by first field, default).  **Must be sorted first!**
```bash
gmaciolek@testsvr:~$ join foo1e foo2e  
0000000001 f1col1line1 f1col2line1 f1col3line1 f2col1line1 f2col2line1 f2col3line1
0000000002 f1col2line2 f1col2line2 f1col3line2 f2col2line2 f2col2line2 f2col3line2
0000000003 f1col2line3 f1col2line3 f1col3line3 f2col2line3 f2col2line3 f2col3line3
```
