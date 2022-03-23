set -u

# inspired by https://igor.moomers.org/aws-mfa-cli-direnv

if [[ ! -f ${BODAM_AWS_SESSION_FILE} ]]; then
  echo "No session found; did you run 'aws_get_session.sh <mfa token>' ?"
  exit 1
fi

export AWS_ACCESS_KEY_ID=`cat ${BODAM_AWS_SESSION_FILE} | jq --raw-output .Credentials.AccessKeyId`
export AWS_SECRET_ACCESS_KEY=`cat ${BODAM_AWS_SESSION_FILE} | jq --raw-output .Credentials.SecretAccessKey`
export AWS_SESSION_TOKEN=`cat ${BODAM_AWS_SESSION_FILE} | jq --raw-output .Credentials.SessionToken`

direnv dump