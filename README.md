# Graphics in x86 assembly
16-bit x86 assembly program that plots geometric primitives on screen in video mode 13h.

The project was a part of Systems Programming module.

## Features
Each stage was built on top of the previous one. Therefore, a gradual improvement can be seen.

##### Stage 1
1. Bresenham's line drawing algorithm
* Plotting pixels with int 10h,
* coordinates passed using labels and registers.

##### Stage 2
1. Bresenham's line drawing algorithm
* Coordinates passed using stack frame,
* preserving registers' values.

##### Stage 3
1. Bresenham's circle drawing algorithm,
1. rectangle drawing algorithm,
* Variables stored using stack frame.

##### Stage 4
1. Bresenham's circle drawing algorithm,
1. rectangle drawing algorithm,
1. [Vitruvian Man](#vitruvian-man),
1. ellipse drawing algorithm,
* Plotting pixels by storing bytes directly in VRAM (stosb).

##### Stage 4++
1. Circle animation.
1. Isosceles triangle.
1. Obtuse triangle.
* Using int 15h for delay to achieve animation.

Stage 4++ contains additional features that could not fit in Stage 4 due to the 3.5KB binary size limitation.

### Feature ideas
- [x] Vitruvian Man,
- [ ] load and display a bitmap,
- [x] ellipse,
- [x] animation,
- [x] triangle,
- [x] text in graphics mode,
- [ ] mouse interaction,
- [ ] custom colour palette.

## Setup

#### Windows
1. Install [Cygwin](https://cygwin.com/install.html "https://cygwin.com/install.html").

   When you get to the 'Select Packages' screen, click on the small icon to the right of 'Devel'. The 'txst' to the right of it should change to 'Install' instead of 'Default'. You can now continue with the rest of the installation process, accepting the rest of the defaults.

   Note that Cygwin will take a long time to install, possibly well over an hour, since it pulls all of the tools down over the Internet.

2. Install [ImDisk](http://www.ltr-data.se/opencode.html/#ImDisk "http://www.ltr-data.se/opencode.html/#ImDisk").
3. Install [Bochs 2.6.9](https://sourceforge.net/projects/bochs/files/bochs/2.6.9 "https://sourceforge.net/projects/bochs/files/bochs/2.6.9").
4. In Cygwin, navigate to the project directory and compile with `make`.

   To access a drive with its letter, use `cd /cygdrive/[drive-letter]`.

5. In Bochs, load the `bochsrc.bxrc` file and start the virtual machine.

   `bochsrc.bxrc` is essentially a configuration for the virtual machine, which also points to the correct disk image.

## Build
If you intend to use `make run`, you need to set the right path in the `makefile`.

## Vitruvian Man
When you fail to load a bitmap and decide to create your own picture:

![Vitruvian Man screenshot](https://github.com/amrwc/8086-Graphics/raw/master/assets/Vitruvian-Man.bmp)

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
