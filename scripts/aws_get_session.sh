#!/bin/bash

# inspired by https://igor.moomers.org/aws-mfa-cli-direnv

TOKEN=$1
shift

if [[ -z $TOKEN ]]; then
    echo "Usage: aws_get_session <mfa token value>"
    exit 1
fi

set -u

mkdir -p `dirname ${BODAM_AWS_SESSION_FILE}`
unset AWS_SESSION_TOKEN

aws --profile "${BODAM_PROJECT}-main_admin" sts get-session-token --serial-number $BODAM_AWS_MFA_ARN --token-code ${TOKEN} > ${BODAM_AWS_SESSION_FILE}\
&& echo "saved session info to ${BODAM_AWS_SESSION_FILE}"