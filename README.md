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
.rh is the standard extension for Rash, a command line scripting language built 
on top of Ruby. The source can be found [here](https://github.com/KellenWatt/rash), 
along with the wiki describing how to use it.

Basically, it's Ruby, and it has all of the power that provides, but you can 
use it as a convenient interactive command shell and call executables like 
methods. There are also human-friendly forms of standard shell functionality, 
like I/O redirection and pipelining.

### Usage
Genius looks for text files in the `~/.genius` directory. These files should 
contain one or more build specifications, which have the capabilities specified 
below. Note that all files are expected to be Rash-compliant scripts.

You can specify "build groups" that contain certain file extensions. When you run 
Genius, it counts all of the files at or below the current directory, then 
determines which build group has the most files associated with it. The group 
with the most files then runs its associated build commands, using the associated 
files, if necessary.

Additionally, you can specify "build tool" patterns which are for things like 
`make`. These patterns look for specific files. If one of those files exists, 
then that specific tool's associated commands are used instead of counting files.

TODO: Write actual usage documentation, beyond skeleton basics

### Examples
Note that each of these are implied to be in separate files, but that isn't 
strictly necessary.

Genius specification for Go, assuming all appropriate commands are installed:
```ruby
Genius.register_group("Go", "go") do |files|
  go :build  # files not necessary here, since Go handles this automatically.
end
``` 

Genius specification for C++, using g++:
```ruby
Genius.register_group("C++", "cpp", "hpp", "h") do |files|
  # For standard a.out
  cmd("g++", files.values_at("cpp", "hpp"))

  # For naming executable after current dir
  # You can use both of these, but you will end up with two executables
  # cmd("g++", files.values_at("cpp", "hpp"), "-o", Dir.pwd)
end
``` 

Genius specification for `make`. This looks for one of "makefile" and "Makefile" 
in the current directory:
```ruby
Genius.register_build_tool("make", "makefile", "Makefile") do |files|
  make  # It's that simple
end
```

Genius specification for building and installing rubygems projects without bundler:
```ruby
# Note the globbing operator used for a filename
Genius.register_build_tool("gem", "*.gemspec") do |files|
  # You need to call system directly because `gem` is a pseudo-builtin, 
  # which messes with Rash.
  if system("gem", "build", files["gemspec"].first)
    system("gem", "install", Dir["*.gem"].sort.last) # sort to ensure most recent last, if multiple.
  end
end
```

