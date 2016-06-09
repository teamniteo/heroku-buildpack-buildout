#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testRelease()
{
  release
  assertCapturedSuccess
  assertCapturedEquals "---"
}
