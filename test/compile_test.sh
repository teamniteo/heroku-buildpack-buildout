#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  if [ ! -d $BUILD_DIR/.heroku ]; then
      # this test is not running on heroku
      # use virtualenv to create python inside BUILD_DIR/.heroku
      mkdir -p ${BUILD_DIR}/.heroku/python
      virtualenv ${BUILD_DIR}/.heroku/python
  fi

  # copy default bootstrap.py & buildout.cfg to BUILD_DIR
  cp ${BUILDPACK_HOME}/bootstrap.py ${BUILD_DIR}/bootstrap.py
  cp ${BUILDPACK_HOME}/buildout.cfg ${BUILD_DIR}/buildout.cfg

  # XXX: copy cached eggs
  cp -r ${BUILDPACK_HOME}/cache/eggs ${BUILD_DIR}/

  # remove python symlink in /app/.heroku/ if existed before compiling
  if [ -L "/app/.heroku/python" ]; then
      rm -f /app/.heroku/python
  fi

  compile
  assertEquals 0 ${rtrn}
  assertCaptured "Done"
}
