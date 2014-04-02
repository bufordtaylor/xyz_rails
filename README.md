# XYZ rails

## NOTES

- Was tested on ruby 2.1.0-p0, with postgres 9.3.3
- No pagination of events, for the sake of simplicity
- No real API error management, for the sake of simplicity
- No redis caching as it's a serious subject, not for demo apps
- The app should not have a radius of 20km hardcoded, the iOS app should define how far we want to look for similar events


## INSTALL
  
    $ bundle
    $ cp config/database.yml{.example,} && vim config/database.yml
    $ bundle exec rake db:setup
    $ bundle exec rake spec

    $ passenger start