# General-Sysadmin-Scripts

These are some scripts I use in my regular day-to-day operations as a sysadmin, or ones that run as cron jobs.  Some of these would be be simpler and more elegant if they were implemented as actual programs (using support libraries, actual logging features, etc).

But they work!

### smctl.sh

`smctl.sh` - A wrapper script to allow for multi-device / globbing support with smartctl.

**Usage:** as with smartctl, but you may specify multiple devices, eg
<pre>
Examples:
   ./smctl.sh -x /dev/sda /dev/sdb
    Print all SMART and ATA info for /dev/sda and /dev/sdb

   ./smctl.sh -a /dev/sd[a-g]| grep -E "##|CRC"
         Use shell globbing to get SMART info from all *existing* devices /dev/sda - /dev/sdg (if supported by your shell)
         and pipe through grep to find any CRC errors.  (## is included to show you which device is which)

   ./smctl.sh -h,-H,--help
         This help screen.

   ./smctl.sh -V,--version
         Version info.
</pre>

### reekinpar.sh

`reekinpar.sh` - A tool to parse "include" directives.  Configured out of the box to handle Bacula config files.  Many of us love to break down config files into small bites, but when something goes wrong, it's nice to be able to reassemble them and see the config how your software sees it!
<pre>
Recursive Inclusion Parser (reekinpar) usage
reekinpar.sh [-h/--help] [-v/--verbose] [-V/--version] [-i includetext/--include=includetext] filename

Examples:
    reekinpar.sh bacula-dir.conf
        Recursively stitch your 'bacula-dir.conf' file and its @/included/sub.configs together into one stream.

    reekinpar.sh -v -iINCLUDE= something.ini
        Recursively stitch your something.ini file, parsing lines beginning with INCLUDE= as filenames to include,
        and display verbosely, with filenames and line numbers, as seen below</pre>

#### something.ini 

<pre>[Config Section 1]
Some Parameter=45

INCLUDE=otherconfig.ini

[End Config]</pre>

#### otherconfig.ini

<pre>[Included Subconfig data]

I=am hard to deal with
Having=all in one file sometimes!</pre>

#### Output

<pre>  Input Filename      Line#   Output line
----------------------------------------------------------
somefile.ini          [001] [Config Section 1]
somefile.ini          [002] Some Parameter=45
somefile.ini          [003] 
otherconfig.ini       [001] [Included Subconfig data]
otherconfig.ini       [002] 
otherconfig.ini       [003] I=am hard to deal with
otherconfig.ini       [004] Having=all in one file sometimes!
somefile.ini          [005] 
somefile.ini          [006] [End Config]</pre>

### mysqlback.sh

`mysqlback.sh` Yet another MySQL backup script!

This is a very straightforward, not very intelligent, but very easy to understand MySQL backup utility.

To install (with more permissions than it needs!):

```bash
curl -o /usr/local/bin/mysqlbackup https://raw.githubusercontent.com/GeoffMaciolek/General-Sysadmin-Scripts/master/mysqlbackup.sh
chmod +x /usr/local/bin/mysqlbackup
ln -s /etc/cron.daily/mysqlbackup /usr/local/bin/mysqlbackup
mysql -u root -p <<< 'GRANT SELECT, LOCK TABLES, SHOW VIEW ON *.* TO "dumper"@"localhost" IDENTIFIED BY "SetYourPass";"'
# use your favorite editor, set the SetYourPass variable as desired
vim /usr/local/bin/mysqlbackup
```

### misc_fun_commandlets.md

[misc_fun_commandlets.md](https://github.com/GeoffMaciolek/General-Sysadmin-Scripts/blob/master/misc_fun_commandlets.md) is a collection of little bash scripts & one-liners that might help with random tasks.
