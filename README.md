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


### mysqlback.sh

`mysqlback.sh` Yet another MySQL backup script!

### misc_fun_commandlets.md

[misc_fun_commandlets.md](https://github.com/GeoffMaciolek/General-Sysadmin-Scripts/blob/master/misc_fun_commandlets.md) is a collection of little bash scripts & one-liners that might help with random tasks.
