# XYZ rails

## NOTES

- Was tested on ruby 2.1.0-p0, with postgres 9.3.3

For the sake of simplicity:
  - No pagination of events
  - No real API error management
  - No redis caching
  - No staging or production git branches
  - Radius of 20km for similar events is hardcoded

## INSTALL
  
    $ bundle
    $ cp config/database.yml{.example,} && vim config/database.yml
    $ bundle exec rake db:setup
    $ bundle exec rake spec

    $ bundle exec passenger start