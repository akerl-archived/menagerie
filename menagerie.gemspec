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

  s.files       = `git ls-files lib/`.split
  s.executables = ['menagerie']

  s.add_dependency 'cymbal', '~> 1.0.0'

  s.add_development_dependency 'rubocop', '~> 0.37.0'
  s.add_development_dependency 'rake', '~> 11.0.0'
  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'rspec', '~> 3.4.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
end
