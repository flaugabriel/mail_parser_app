#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid

RAILS_ENV=production bundle exec rake assets:clobber
RAILS_ENV=production bundle exec rake cache:clear
RAILS_ENV=production bundle exec rake tmp:clear
RAILS_ENV=production bundle exec rake assets:precompile
bundle exec rails s -p 3000 -b 0.0.0.0 -e production