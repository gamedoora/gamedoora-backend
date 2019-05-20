Gamedoora API Service
=====================

All of the backend services/Apis at one place

### Modules To Be Developed
* User Module (Signup, login, reset, profile page, change password)
* Social Sign in
* Studio (Creation, updation, stream, request to join, members, accept/reject)
* Project Management (tasks) 
* Asset Management
* Script Editor
* Studio Analytics (dashboard)
* User personal space
* Notification Module
* Include Sidekiq for background jobs
* include redis
* Implement same way of asset upload

### Info
* Note that we're using the --api argument to tell Rails that we want an API application and -T to exclude Minitest the default testing framework. Don't freak out, we're going to write tests. We'll be using RSpec instead to test our API. I find RSpec to be more expressive and easier to start with as compared to Minitest.
* For documentation, using rspec_api_documentation library
* ruby version = 2.5.1
* db = mysql
* rails version = 5.2.2
* should create own master.key file ```EDITOR=vi bin/rails credentials:edit```
* to run server - ```rails s```
* to run test scripts - ```bundle exec rspec```
* to generate docs -  ```bundle exec rake docs:generate```
* to run sidekiq(provide environment name like development)  - ```bundle exec sidekiq --environment development -C config/sidekiq.yml```
* using mail_opener for opening mail in development mode
* using mail_safe to prevent delivery of mail while in testing

### When deploying to production:
* change master.key file and change credentials file using first delete existing file and rewriting it using ```EDITOR=vi bin/rails credentials:edit``` 
* change user token expiration time in lib/json_web_token.rb file. Default set to ```exp = 1.year.from_now```
* to run sidekiq(provide environment name like production)  - ```bundle exec sidekiq -d --environment production -C config/sidekiq.yml ```
* Check if required environment check for mail safe


## NOTES
* while adding new gem, mention exact version of that time you have added in gemfile only


# How to deploy sidekiq on production
* sidekiq --help 
* use -d option as daemon
* example: ```bundle exec sidekiq -d -L sidekiq.log -C config/sidekiq.yml -e production```
* https://redpanthers.co/deploying-sidekiq-ubuntu-16-04/
* Few things are configurable like whether it is required to verify user or not