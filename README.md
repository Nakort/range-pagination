# README

First thing we need ruby 2.3.0, I prefer to use rvm your mileage may vary.

  ```
  rvm install 2.3.0
  ```
Now let's cd in to our project folder, and in case bundler is not installed:
  ```
  gem install bundler
  ```
Once bundler is installed, it's time to install our dependencies:
  ```
  bundle install
  ```
Let's setup the development and test db (it's using sqlite):
  ```
  bundle exec rake db:setup
  ```
If we want to run our specs we can just:
  ```
  bundle exec rspec
  ```
There is also a script to generate 300 apps in case you want to populate your development database:
  ```
  bundle exec rake db:seed
  ```
Now to run the app:
  ```
  bundle exec rails s
  ```
The app should be accessible through http://localhost:3000/apps
