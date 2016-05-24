#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/buildout.cfg
  touch ${BUILD_DIR}/bootstrap.sh
  
  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
  
  assertEquals 0 ${rtrn}
  assertEquals "Buildout" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
}

