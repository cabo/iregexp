Gem::Specification.new do |s|
  s.name = "iregexp"
  s.version = "0.0.2"
  s.summary = "I-Regexp Tools"
  s.description = %q{iregexp implements converters and miscellaneous tools for I-Regexp}
  s.author = "Carsten Bormann"
  s.email = "cabo@tzi.org"
  s.license = "MIT"
  s.homepage = "http://github.com/cabo/iregexp"
  s.files = Dir['lib/**/*.rb'] + %w(iregexp.gemspec) + Dir['data/*'] + Dir['test-data/*'] + Dir['bin/**/*.rb']
  s.executables = Dir['bin/*'].map {|x| File.basename(x)}
  s.required_ruby_version = '>= 3.0'

  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~>1'
  s.add_dependency 'treetop', '~>1'
#  s.add_dependency 'json'
  s.add_dependency 'neatjson', '~>0.10'
  s.add_dependency 'regexp-examples', '~>1.5.1'
end
