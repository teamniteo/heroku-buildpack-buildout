Heroku buildpack: Buildout
==========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for Python apps, powered by [Buildout](http://www.buildout.org/en/latest/).


Usage
-----

Example usage, first create a Heroku app:

    $ heroku create --buildpack https://github.com/ddollar/heroku-buildpack-multi


This buildpack depends on the [official Heroku Python buildpack](https://github.com/heroku/heroku-buildpack-python), so you need to configure your app with support for multi-buildpacks, by setting the following environment variable:

    $ heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

Then specify the list of buildpacks your app should use in the `.buildpacks` file:

    $ cat .buildpacks
    https://github.com/heroku/heroku-buildpack-python.git
    https://github.com/niteoweb/heroku-buildpack-buildout.git


The buildpack will detect your app as a Buildout-powered-Python app if the repo has `requirements.txt` and `buildout.cfg` files in the root. The buildpack will use Pip to install Buildout, then use Buildout to build your environment.

    $ cat requirements.txt
    zc.buildout==2.2.1

    $ cat buildout.cfg
    [buildout]
    ...


Next, you need to tell Heroku how to run your app once Buildout builds it:

    $ cat Procfile
    bin/<your app start command>


Lastly, push your changes to Heroku to build your app:

    $ git push heroku master
    ...
    -----> Buildout app detected
    -----> Installing runtime (python-2.7.8)
    -----> Installing dependencies using pip
           Downloading/unpacking zc.buildout (from -r requirements.txt (line 1))
           Installing collected packages: zc.buildout
           Successfully installed zc.buildout
           Cleaning up...
    -----> Discovering process types
           Procfile declares types -> (none)


Options
=======

Set Buildout version
--------------------

Since Pip looks into the `requirements.txt` file to see which Buildout version to install, you can  specify an arbitrary Buildout version in this file.

    $ cat requirements.txt
    zc.buildout==2.2.1


Set Python version
------------------

You can set an arbitrary Python version with a `runtime.txt` file.

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


Use arbitrary ``bootstrap.py`` file
-----------------------------------

By default, this buildpack uses the following `bootstrap.py` file to bootstrap the Buildout 2.x environment on Heroku: http://downloads.buildout.org/2/bootstrap.py

If you want to use some other bootstrap.py, for example to enable support for
Buildout version 1.x, set the ``BOOTSTRAP_PY_URL`` environment variable.

    $ heroku config:add BOOTSTRAP_PY_URL=http://downloads.buildout.org/2/bootstrap.py
