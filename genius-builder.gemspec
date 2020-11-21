Gem::Specification.new do |s|
  s.name = "genius-builder"
  s.version = "0.3.1"
  s.date = "2020-11-19"
  s.summary = "An intelligent compiler selection tool"
  s.description = "An everyday build tool that does the heavy lifting for you."
  s.homepage = "https://github.com/KellenWatt/genius"
  s.authors = ["Kellen Watt"]

  s.files = [
    "lib/genius.rh"
  ]

  s.add_runtime_dependency "rash-command-shell", ">= 0.4.0"

  s.bindir = "bin"
  s.executables = "genius"

  s.license = "MIT"

  s.required_ruby_version = Gem::Requirement.new(">= 2.5")
end
