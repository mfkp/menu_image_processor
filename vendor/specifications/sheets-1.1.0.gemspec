# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sheets"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bradley J. Spaulding"]
  s.date = "2011-11-28"
  s.description = "Work with spreadsheets easily in a native ruby format."
  s.email = ["brad.spaulding@gmail.com"]
  s.homepage = "https://github.com/bspaulding/Sheets"
  s.require_paths = ["lib"]
  s.rubyforge_project = "sheets"
  s.rubygems_version = "1.8.23"
  s.summary = "Sheets provides a Facade for importing spreadsheets that gives the application control. Any Spreadsheet can be represented as either (1) a two dimensional array, or (2) an array of hashes. Sheets' goal is to convert any spreadsheet format to one of these native Ruby data structures."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spreadsheet>, [">= 0.6.5.2"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.3.1"])
      s.add_development_dependency(%q<rake>, ["= 0.9.2"])
    else
      s.add_dependency(%q<spreadsheet>, [">= 0.6.5.2"])
      s.add_dependency(%q<rubyzip>, [">= 0.9.4"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
      s.add_dependency(%q<rake>, ["= 0.9.2"])
    end
  else
    s.add_dependency(%q<spreadsheet>, [">= 0.6.5.2"])
    s.add_dependency(%q<rubyzip>, [">= 0.9.4"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
    s.add_dependency(%q<rake>, ["= 0.9.2"])
  end
end
