# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubyXL"
  s.version = "1.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vivek Bhagwat"]
  s.date = "2012-04-09"
  s.description = "rubyXL is a gem which allows the parsing, creation, and manipulation of Microsoft Excel (.xlsx/.xlsm) Documents"
  s.email = "bhagwat.vivek@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.files = ["LICENSE.txt", "README.rdoc"]
  s.homepage = "http://github.com/gilt/rubyXL"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "rubyXL is a gem which allows the parsing, creation, and manipulation of Microsoft Excel (.xlsx/.xlsm) Documents"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_development_dependency(%q<rubyzip>, [">= 0.9.4"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.4"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_dependency(%q<rubyzip>, [">= 0.9.4"])
      s.add_dependency(%q<rspec>, [">= 1.3.4"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
    s.add_dependency(%q<rubyzip>, [">= 0.9.4"])
    s.add_dependency(%q<rspec>, [">= 1.3.4"])
  end
end
