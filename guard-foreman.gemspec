# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "guard-foreman"
  s.version     = "0.0.1"
  s.authors     = ["Andrei Maxim", "Jonathan Arnett"]
  s.licenses    = ['MIT']
  s.email       = ["jonarnett90@gmail.com"]
  s.homepage    = "https://github.com/J3RN/guard-foreman"
  s.summary     = "Guard for Foreman"
  s.description = "Guard plug-in that allows you to restart Foreman"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '~> 2.6'
end
