require File.expand_path('./lib/xferase/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'xferase'
  s.version = Xferase::VERSION
  s.licenses = ['MIT']
  s.required_ruby_version = '>= 2.6.0'
  s.authors = ['Ryan Lue']
  s.email = 'hello@ryanlue.com'
  s.summary = 'Import/rename photos & videos from one directory to another.'
  s.description = <<~DESC.chomp
  DESC
  s.files = `git ls-files bin lib README.md`.split
  s.executables += ['xferase']
  s.homepage = 'https://github.com/rlue/xferase'

  s.add_dependency 'debouncer', '~> 0.2'
  s.add_dependency 'photein', '~> 0.1', '>= 0.1.4'
  s.add_dependency 'rb-inotify', '~> 0.10'
  s.add_development_dependency 'pry', '~> 0.14'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.metadata = { 'source_code_uri' => 'https://github.com/rlue/xferase' }
end
