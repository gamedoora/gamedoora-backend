# Gamedoora API Service

All of the backend services/Apis at one place

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Info
Note that we're using the --api argument to tell Rails that we want an API application and -T to exclude Minitest the default testing framework. Don't freak out, we're going to write tests. We'll be using RSpec instead to test our API. I find RSpec to be more expressive and easier to start with as compared to Minitest.
* ruby version = 2.5.1
* db = mysql
* rails version = 5.2.2
* should create own master.key file ```EDITOR=vi bin/rails credentials:edit```
* to run server - ```rails s```
* to run test scripts - ```bundle exec rspec```  
