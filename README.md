# Genius: the intelligent build tool

Genius is used to compile arbitrary code using a standardized command structure.

## Why?
I could come up with a lot of contrived reasons for this, but mostly, I use the 
same build commands a lot, and I don't want to type those more than necessary. 
I could use a standardized makefile or something of the sort, but that's more 
work than just typing a single command.

Genius can also be built on top of other build tools, similar to `make`, so 
it has all the power, without most of the hassle.

## Wait, what is this .rh file?
.rh is the standard extension for Rash, a command line scripting language built 
on top of Ruby. The source can be found [here](https://github.com/KellenWatt/rash), 
along with the wiki describing how to use it.

Basically, it's Ruby, and it has all of the power that provides, but you can 
use it as a convenient interactive command shell and call executables like 
methods. There are also human-friendly forms of standard shell functionality, 
like I/O redirection and pipelining.

## Usage
Genius looks for text files in the `~/.genius` directory. These files can 
contain two different kinds of build specifications: groups and tools. Both
kinds of build specs are Rash scripts using the Genius DSL.

Each build spec has a block of commands that provides a hash containing 
relevant files. Build groups give all relevant files, specified by the 
provided extensions, and build tools give all files with extensions.

### Build Groups
Build groups generally execute the most basic kinds of compilation, where it 
only depends on file contents, and not strictly the filenames themselves, like 
C/C++ or Java compilation.

You can register a build group with Genius by calling `Genius.register_group`, 
and providing a name for the group, the extensions it should consider, and 
a block specifying the commands to run if that group is selected.

A build group is selected when it contains more files with its extensions than 
any other build group, and no build tool applies to the current directory. For 
example, take a project tree that contains C++ and markdown files, with build 
groups registered for both. Genius will count the number of files relevant to 
both, then choose the one that has a higher count, probably C++.

### Build Tools
Build tools are generally useful for when there is a specific tool that is better 
at compiling the current project than a general build group can accomplish. The 
trivial example is `make`, but it can also be used for something like rubygems 
projects.

You can register a build group with Genius by calling `Genius.register_build_tool`,
and providing a name for the group, the file patterns it should look for, and 
a block specifying the commands to run if that group is selected. 

File patterns used in build tools use bash-like globbing. If any files in the 
current directory match any of the patterns of a build tool, that tool is 
selected, and no more are considered. If there is overlap between build tools, 
the first registered is used. This is probably resolved alphabetically by source 
file name, though that isn't guaranteed.

## Examples
Note that each of these are implied to be in separate files, but that isn't 
strictly necessary.

### Go
```ruby
Genius.register_group("Go", "go") do |files|
  go :build  # files not necessary here, since Go handles this automatically.
end
``` 
### C++
```ruby
Genius.register_group("C++", "cpp", "hpp", "h") do |files|
  # `cmd` is how Rash calls commands with Ruby-identifier incompatible characters
  cmd("g++", files.values_at("cpp", "hpp"))
end
``` 

### Make
Looks for "makefile" or "Makefile". Note that a regexp will not work.
```ruby
Genius.register_build_tool("make", "makefile", "Makefile") do |files|
  make  # It's that simple
end
```

### Rubygems
Looks for any file with the gempsec extension. Builds the project, then locally 
installs the generated gem file.
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

