# Genius: the intelligent build tool

Genius is used to compile arbitrary code using a standardized command structure.

### Why?
I could come up with a lot of contrived reasons for this, but mostly, I use the 
same build commands a lot, and I don't want to type those more than necessary. 
I could use a standardized makefile or something of the sort, but that's more 
work than just typing a single command.

Genius can also be built on top of other build tools, similar to `make`, so 
it has all the power, without most of the hassle.

### Wait, what is this .rh file?
.rh is the standard extension for Rash, a command line language built 
on top of Ruby. The source can be found [here](https://github.com/KellenWatt/rash), 
along with the wiki describing how to use it.

Basically, it's Ruby, and it has all of the power that provides, but you can 
use it as a convenient interactive command shell and call executables like 
methods. There are also more-readable forms of standard shell functionality, 
like I/O redirection and pipelining.

