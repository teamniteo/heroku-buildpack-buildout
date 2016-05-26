#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

setupPythonEnv()
{
  if [ ! -d $BUILD_DIR/.heroku ]; then
    # this test is not running on heroku
    # use system virtualenv to create python inside BUILD_DIR/.heroku
    mkdir -p ${BUILD_DIR}/.heroku/python
    virtualenv ${BUILD_DIR}/.heroku/python
  fi
}

cleanUp()
{
  # remove python symlink in /app/.heroku/ if existed
  if [ -L "/app/.heroku/python" ]; then
      rm -f /app/.heroku/python
  fi
}

prepareBuildout()
{
  # copy default bootstrap.py & buildout.cfg to BUILD_DIR
  cp ${BUILDPACK_HOME}/bootstrap.py ${BUILD_DIR}/bootstrap.py
  cp ${BUILDPACK_HOME}/buildout.cfg ${BUILD_DIR}/buildout.cfg
}

testPythonBuildpackFail()
{
  # make sure the test failed if python not found in $BUILD_DIR/.heroku/
  compile
  assertEquals 1 ${rtrn}
  assertCaptured "-----> This buildpack depends on heroku-buildpack-python."
}

testCompile()
{
  # install python virtualenv if test not running on heroku
  setupPythonEnv
  # prepare test buildout
  prepareBuildout
  # clean up before compiling
  cleanUp

  compile
  assertEquals 0 ${rtrn}
  assertNotCaptured "-----> Use PYPICloud"
  assertCaptured "Cache empty, start from scratch"
  assertCaptured "Using default: buildout.cfg"
  assertCaptured "Use default buildout verbosity"
  assertCaptured "Use default bootstrap verbosity"
  assertCaptured "Use default pip version: ${VERSION_PIP}"
  assertCaptured "Use default setuptools version: 20.4"

  assertTrue "/app/.heroku/ should be present in runtime." "[ -d /app/.heroku ]"
  assertTrue "python symlink should be present." "[ -L /app/.heroku/python ]"
  assertTrue "eggs should be present in build dir." "[ -d $BUILD_DIR/eggs ]"
  assertTrue "eggs should be present in cache dir." "[ -d $CACHE_DIR/eggs ]"
  assertTrue "Sphinx should be present in bin." "[ -f $BUILD_DIR/bin/sphinx-build ]"

  assertCaptured "Done"

  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture
  compileWithEnvVars
}

compileWithEnvVars()
{
  #-* test compile with env vars set *-#
  # set credentials for third party PyPI installations
  echo "foo" > $ENV_DIR/PYPICLOUD_USERNAME
  echo "bar" > $ENV_DIR/PYPICLOUD_PASSWORD
  # set BUILDOUT_CFG file
  echo "buildout.cfg" > $ENV_DIR/BUILDOUT_CFG
  # set Buildout verbosity
  echo "-v" > $ENV_DIR/BUILDOUT_VERBOSITY
  # set pip version
  echo "8.1.1" > $ENV_DIR/VERSION_PIP
  # set setuptools version
  echo "20.4" > $ENV_DIR/VERSION_SETUPTOOLS

  # prepare test buildout
  prepareBuildout
  # clean up before compiling
  cleanUp

  compile
  assertEquals 0 ${rtrn}
  assertCaptured "Get buildout results from the previous build" # cache worked
  assertCaptured "-----> Use PYPICloud"
  assertCaptured "Found ${BUILDOUT_CFG}"
  assertCaptured "Use buildout verbosity: ${BUILDOUT_VERBOSITY}"
  assertCaptured "Use pip version: ${VERSION_PIP}"
  assertCaptured "Use setuptools version: ${VERSION_SETUPTOOLS}"
  assertCaptured "Done"
}
