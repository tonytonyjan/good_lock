Dependency
==========

* Un*x
* Ruby
* Git

How to Build
============

Install Git
-----------

### Debian

```
$ sudo apt-get install git
```

Install Ruby
------------

We suggest you use [RVM](https://rvm.io/)

```
$ \curl -L https://get.rvm.io | bash -s stable
$ rvm install 2.0.0
$ rvm use 2.0.0 --default
```

Install Required Gems
---------------------

```
$ gem install rake bundler rails -N
```

Clone and Build the Project
---------------------------

```
$ git clone git@github.com:tonytonyjan/good_lock.git
$ cd good_lock
$ bundle install
$ rake db:setup
$ rails server
```

Go to [http://localhost:3000](http://localhost:3000)

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
