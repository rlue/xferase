project := "xferase"
version := `ruby -r ./lib/xferase/version.rb -e 'puts Xferase::VERSION'`
next_version := shell("printf '%s\n' " + quote(version) + " | awk -F. '{ $3++; print $1\".\"$2\".\"$3 }'")

photein_ver := `grep photein xferase.gemspec | tr -Cd [0-9].=\n | cut -d= -f2`
photein_next_ver := shell("printf '%s\n' " + quote(photein_ver) + " | awk -F. '{ $3++; print $1\".\"$2\".\"$3 }'")

# Increment the patch version number and push
bump:
  perl -pi -e 's/\Q{{version}}\E/{{next_version}}/' lib/{{project}}/version.rb
  perl -pi -e 's/\Q{{project}} ({{version}})\E/{{project}} ({{next_version}})/' Gemfile.lock
  git add lib/{{project}}/version.rb Gemfile.lock
  git commit -m "rel: Bump to v{{next_version}}"

# Increment the patch version number (along with photein) and push
bump-together: _bump-photein-dependency bump

_bump-photein-dependency:
  perl -pi -e "s/photein.*\\K\\Q{{photein_ver}}\\E/{{photein_next_ver}}/" xferase.gemspec
  perl -pi -e "s/photein.*\\K\\Q{{photein_ver}}\\E/{{photein_next_ver}}/" Gemfile.lock
  git add xferase.gemspec

# Build and publish to RubyGems and Docker Hub
publish:
  gem build {{project}}.gemspec
  gem push {{project}}-{{version}}.gem
  docker buildx build --build-arg VERSION="{{version}}" --platform linux/amd64,linux/arm64 -t rlue/{{project}}:latest -t rlue/{{project}}:{{version}} --builder container --push .
