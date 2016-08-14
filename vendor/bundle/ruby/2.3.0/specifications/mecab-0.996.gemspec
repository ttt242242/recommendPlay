# -*- encoding: utf-8 -*-
# stub: mecab 0.996 ruby lib
# stub: ext/mecab/extconf.rb

Gem::Specification.new do |s|
  s.name = "mecab"
  s.version = "0.996"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Taku Kudo"]
  s.date = "2011-12-24"
  s.description = "Ruby bindings for MeCab, a morphological analyzer.\n"
  s.email = "taku@chasen.org"
  s.extensions = ["ext/mecab/extconf.rb"]
  s.files = ["ext/mecab/extconf.rb"]
  s.homepage = "http://mecab.sourceforge.net/"
  s.licenses = ["BSD", "GPL", "LGPL"]
  s.rubygems_version = "2.5.1"
  s.summary = "Ruby bindings for MeCab."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0"])
    else
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<rake-compiler>, ["~> 0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<rake-compiler>, ["~> 0"])
  end
end
