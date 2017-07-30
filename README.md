Heroku buildpack: Buildout
==========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for Python apps, powered by [Buildout](http://www.buildout.org/en/latest/).

[![Build Status](https://travis-ci.org/niteoweb/heroku-buildpack-buildout.svg?branch=master)](https://travis-ci.org/niteoweb/heroku-buildpack-buildout)


Usage
-----

Example usage, first create a Heroku app:

    $ heroku create

This buildpack depends on the [official Heroku Python buildpack](https://github.com/heroku/heroku-buildpack-python), so you need to configure your app with support for multiple buildpacks.

    $ heroku buildpacks:add heroku/python
    $ heroku buildpacks:add https://github.com/niteoweb/heroku-buildpack-buildout.git

Use the `requirements.txt` file to install the wanted version of `pip`, `setuptools` and `zc.buildout`. The Heroku Python buildpack know how to use pip to install libraries listed in `requirements.txt` so you just need to add the file.

The buildpack will detect your app as a Buildout-powered-Python app if the repo has the `buildout.cfg` file in root. The buildpack will use Python compiled by heroku-buildpack-python to run Buildout to build your environment.

    $ cat buildout.cfg
    [buildout]
    relative-paths = true
    ...

Note that you have to set ``relative-paths = true`` in your ``buildout.cfg`` file.

Next, you need to tell Heroku how to run your app once Buildout builds it:

    $ cat Procfile
    bin/<your app start command>


Lastly, push your changes to Heroku to build your app:

    $ git push heroku master
    ...
    -----> Fetching custom git buildpack... done
    -----> Buildout app detected
    -----> Use build cache
    -----> Read BUILDOUT_CFG from env vars, or use default
    -----> Read BUILDOUT_VERBOSITY from env vars, or use default
    -----> Init buildout
    ...
    -----> Run bin/buildout -c buildout.cfg
    ...
    -----> Copy results to cache
    -----> Copy results to slug
           Done
    -----> Discovering process types
           Procfile declares types -> web


Options
=======

Set Python version
------------------

You can set an arbitrary Python version with a `runtime.txt` file.

    $ cat runtime.txt
    python-3.5.0

Other [runtimes](https://github.com/heroku/heroku-buildpack-python/tree/master/builds/runtimes) are available as well.


Set Buildout verbosity
----------------------

To increase the Buildout's verbosity, set the following environment variable:

    $ heroku config:add BUILDOUT_VERBOSITY=-v

You can increase verbosity up to ``-vvvv``.


Use arbitrary ``*.cfg`` file
----------------------------

To run an arbitrary *.cfg file such as ``heroku.cfg``, set the following environment variable:

    $ heroku config:add BUILDOUT_CFG=heroku.cfg

Remember that you have to set ``relative-paths = true`` in your arbitrary *.cfg file.
