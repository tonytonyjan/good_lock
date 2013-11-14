Dependency
==========

* Un*x
* Ruby
* Git

Usage
=====

``` bash
$ gem install rake bundler rails -N
$ git clone git@github.com:tonytonyjan/good_lock.git
$ cd good_lock
$ bundle install
$ rake db:setup
$ rails server
```

Open your browser and go to http://localhost:3000

Rake Tasks
==========

Fetch News
----------

``` bash
$ rake news:fetch
```

Export News
-----------

``` bash
rake news:export
```

To see more rake tasks, type `rake -D news`
