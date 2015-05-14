# misc_fun_Commandlets
## Here are some fun commandlets / etc!

```bash
gmaciolek@testsvr:~$ cat foo1; echo; cat foo2  #Start with two files with some space-delimited data
f1col1line1 f1col2line1 f1col3line1
f1col2line2 f1col2line2 f1col3line2
f1col2line3 f1col2line3 f1col3line3

f2col1line1 f2col2line1 f2col3line1
f2col2line2 f2col2line2 f2col3line2
f2col2line3 f2col2line3 f2col3line3
```
```bash
gmaciolek@testsvr:~$ awk '{printf("%010d %s\n", NR, $0)}' # Prepend 10-digit formatted 
gmaciolek@testsvr:~$ awk '{printf("%010d %s\n", NR, $0)}' #   with incrementing numbers
gmaciolek@testsvr:~$ tail -n +1 foo1 foo1e foo2 foo2e # Display multiple files w/names
#                                                        "starting with line 1"
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
```bash
gmaciolek@testsvr:~$ join foo1e foo2e  #join MATCHING lines (by first field, default)
0000000001 f1col1line1 f1col2line1 f1col3line1 f2col1line1 f2col2line1 f2col3line1
0000000002 f1col2line2 f1col2line2 f1col3line2 f2col2line2 f2col2line2 f2col3line2
0000000003 f1col2line3 f1col2line3 f1col3line3 f2col2line3 f2col2line3 f2col3line3
```
