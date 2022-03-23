#!/bin/bash

export AWS_CONFIG_FILE="$(realpath ../aws_config_${BODAM_PROJECT})"
export AWS_PROFILE="${BODAM_PROJECT}-${BODAM_ENV}_admin-role"
# credential store for AWS MFA support with aws_[get,load]_session.sh
export BODAM_AWS_SESSION_FILE="${HOME}/.config/aws/session-${AWS_PROFILE}"
# enable correct use of shared ~/.aws with AWS SDK
export AWS_SDK_LOAD_CONFIG=1

dotenv ../.env
PATH_add ../../common/bodam/scripts/

if [[ "$BODAM_AUTH_MFA_ENABLED" = true ]]; then
  watch_file $BODAM_AWS_SESSION_FILE
  direnv_load aws_load_session.sh
fi
