Gem::Specification.new do |s|
  s.name        = 'menagerie'
  s.version     = '1.0.0'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = ''
  s.description = ""
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/menagerie'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['menagerie']

  s.add_dependency 'cymbal', '~> 1.0.0'

  s.add_development_dependency 'rubocop', '~> 0.32.0'
  s.add_development_dependency 'rake', '~> 10.4.0'
  s.add_development_dependency 'coveralls', '~> 0.8.0'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
end
