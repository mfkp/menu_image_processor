# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-ole"
  s.version = "1.2.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Charles Lowe"]
  s.date = "2012-02-24"
  s.description = "A library for easy read/write access to OLE compound documents for Ruby."
  s.email = "aquasync@gmail.com"
  s.executables = ["oletool"]
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["bin/oletool", "README", "ChangeLog"]
  s.homepage = "http://code.google.com/p/ruby-ole"
  s.rdoc_options = ["--main", "README", "--title", "ruby-ole documentation", "--tab-width", "2"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ruby-ole"
  s.rubygems_version = "1.8.23"
  s.summary = "Ruby OLE library."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
