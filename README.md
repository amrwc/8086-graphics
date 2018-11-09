## Setup

#### Windows
1. Install [Cygwin](https://cygwin.com/install.html "https://cygwin.com/install.html").

   When you get to the Select Packages screen, click on the small icon to the right of Devel. The txst to the right of it should change to Install instead of Default. You can now continue with the rest of the install, accepting the rest of the defaults.

   Note that Cygwin will take a long time to install, possibly well over an hour, since it pulls all of the tools down over the Internet.

2. Install [ImDisk](http://www.ltr-data.se/opencode.html/#ImDisk "http://www.ltr-data.se/opencode.html/#ImDisk").
3. Install [Bochs 2.6.9](https://sourceforge.net/projects/bochs/files/bochs/2.6.9 "https://sourceforge.net/projects/bochs/files/bochs/2.6.9").
4. In Cygwin, navigate to the project directory and compile with 'make'.

   To access a drive with its letter, use 'cd /cygdrive/[drive-letter]'.

5. In Bochs, load the 'bochsrc.bxrc' file and start the virtual machine.

   'bochsrc.bxrc' is essentially a configuration for the virtual machine, which also points to the correct disk image.

## Build
If you intend to use 'make run' command, you need to set the right path in the makefile.

## Resources
* [Complete 8086 instruction set](http://www.gabrielececchetti.it/Teaching/CalcolatoriElettronici/Docs/i8086_instruction_set.pdf)
* [Interrupt Jump Table](http://www.ctyme.com/intr/int.htm)
* [Keyboard scan codes](http://www.ee.bgu.ac.il/~microlab/MicroLab/Labs/ScanCodes.htm)
* [The Beauty of Bresenham's Algorithm](http://members.chello.at/~easyfilter/bresenham.html)
* [VGA Basics](http://www.brackeen.com/vga/basics.html)
* [Graphics with Direct Memory Access](http://www.skynet.ie/~darkstar/assembler/tut7.html)
* [File I/O in Real-Address Mode](http://kipirvine.com/asm/articles/FileIO16.pdf)
* [Simplified Windows BMP Bitmap File Format Specification](http://www.dragonwins.com/domains/getteched/bmp/bmpfileformat.htm)
* [Michael Abrash’s Graphics Programming Black Book](http://www.jagregory.com/abrash-black-book/)