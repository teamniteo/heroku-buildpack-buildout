#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/buildout.cfg
  touch ${BUILD_DIR}/bootstrap.sh
  
  detect
  assertCapturedSuccess
  assertCaptured "Buildout"
}

testDetectFail()
{
  detect
  assertEquals 1 ${rtrn}
}
