Heroku buildpack: Buildout
==========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for Python apps, powered by [Buildout](http://www.buildout.org/en/latest/).

[![Build Status](https://travis-ci.org/niteoweb/heroku-buildpack-buildout.svg?branch=master)](https://travis-ci.org/niteoweb/heroku-buildpack-buildout)


Usage
-----

Example usage, first create a Heroku app:

    $ heroku create


This buildpack depends on the [official Heroku Python buildpack](https://github.com/heroku/heroku-buildpack-python), so you need to configure your app with support for multi-buildpacks, by setting the following environment variable:

    $ heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

Then specify the list of buildpacks your app should use in the `.buildpacks` file:

    $ cat .buildpacks
    https://github.com/heroku/heroku-buildpack-python.git
    https://github.com/niteoweb/heroku-buildpack-buildout.git


The buildpack will detect your app as a Buildout-powered-Python app if the repo has `buildout.cfg` file in the root.
The python buildpack will download the specific Python version and create a virtualenv. The buildout buildpack downloads bootstrap.py and then use Buildout to build your environment.

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
    -----> Read BOOTSTRAP_PY_URL from env vars, or use default
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
You need an empty `requirements.txt` file to trigger the python buildpack.
An empty `requirements.txt` and a `runtime.txt` is only needed if you want to use a specific Python version. If those files are missing, it will simply use the globally installed Python.

    $ cat runtime.txt
    python-2.7.8

Runtime options include:

- python-2.6.9
- python-3.4.1
- pypy-1.9 (experimental)

Other [unsupported runtimes](https://github.com/heroku/heroku-buildpack-python/tree/master/builds/runtimes) are available as well.


Set Buildout verbosity
----------------------

To increase the Buildout's verbosity, set the following environment variable:

    $ heroku config:add BUILDOUT_VERBOSITY=-v

You can increase verbosity up to ``-vvvv``.


Use arbitrary ``*.cfg`` file
----------------------------

To run an arbitrary *.cfg file such as ``heroku.cfg``, set the following environment variable:

    $ heroku config:add BUILDOUT_CFG=heroku.cfg

Note that you have to set ``relative-paths = true`` in your arbitrary *.cfg file.


Use arbitrary ``bootstrap.py`` file
-----------------------------------

By default, this buildpack uses the following `bootstrap.py` file to bootstrap the Buildout 2.x environment on Heroku: http://downloads.buildout.org/2/bootstrap.py

If you want to use some other bootstrap.py, for example to enable support for
Buildout version 1.x, set the ``BOOTSTRAP_PY_URL`` environment variable.

    $ heroku config:add BOOTSTRAP_PY_URL=http://downloads.buildout.org/2/bootstrap.py
