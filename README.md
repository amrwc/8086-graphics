## Setup

#### Windows
1. Install [Cygwin](https://cygwin.com/install.html "https://cygwin.com/install.html").
2. Install [ImDisk](http://www.ltr-data.se/opencode.html/#ImDisk "http://www.ltr-data.se/opencode.html/#ImDisk").
3. Install [Bochs 2.6.9](https://sourceforge.net/projects/bochs/files/bochs/2.6.9 "https://sourceforge.net/projects/bochs/files/bochs/2.6.9").
4. In Cygwin, navigate to the project directory and compile with 'make'.

   To access a drive with its letter, use 'cd /cygdrive/[drive-letter]'.

5. In Bochs, load the 'bochsrc.bxrc' file and start the virtual machine.

   'bochsrc.bxrc' is essentially a configuration for the virtual machine, which also points to the correct disk image.
