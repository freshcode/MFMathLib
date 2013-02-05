MFMathLib
=========

8-bit to 1024-bit (easily extendable) mathematic library with overflow/underflow detection

by Freshcode, Cutting edge Mac, iPhone & iPad software development.
http://madefresh.ca/


Licensing
=========
Public Domain
Originally created by Dave Poirier on 2013-02-01.

Compatibility
=============
C compiler with support for 32-bit unsigned integers

Performance
===========
This library has _NOT_ yet been optimized for performance.  While its development is in its
early stage priority has been put into ensuring mathematical accuracy rather than execution speed.
All performance improvement contributions are welcome.

Dependencies
============
For the library files mfmathlib.c/.h:
-  none

For the test framework:
-  standard OSX environment
-  Accelerate framework
-  'bc' command line tool.

Limitations
===========
The library currently only support unsigned integer operations
