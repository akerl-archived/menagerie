Gem::Specification.new do |s|
  s.name        = 'menagerie'
  s.version     = '1.1.1'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = ''
  s.description = ''
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/menagerie'
  s.license     = 'MIT'

  s.files       = `git ls-files lib/`.split
  s.executables = ['menagerie']

  s.add_dependency 'cymbal', '~> 2.0.0'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.5.0'
  s.add_development_dependency 'goodcop', '~> 0.8.0'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop', '~> 0.76.0'
end
