# -*- encoding: utf-8 -*-
# stub: flatui-rails 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "flatui-rails"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Piotrek"]
  s.date = "2013-03-25"
  s.description = "flat-ui for rails"
  s.email = ["pkurek90@gmail.com"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "flat-ui for rails using sass"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sass-rails>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
      s.add_runtime_dependency(%q<bootstrap-sass>, ["= 2.2.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<sass-rails>, [">= 3.2.0"])
      s.add_dependency(%q<railties>, [">= 3.1"])
      s.add_dependency(%q<bootstrap-sass>, ["= 2.2.2"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<sass-rails>, [">= 3.2.0"])
    s.add_dependency(%q<railties>, [">= 3.1"])
    s.add_dependency(%q<bootstrap-sass>, ["= 2.2.2"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
