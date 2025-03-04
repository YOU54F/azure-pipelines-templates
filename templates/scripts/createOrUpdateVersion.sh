#!/usr/bin/env bash

MISSING=()
[ ! "$PACT_BROKER_BASE_URL" ] && MISSING+=("PACT_BROKER_BASE_URL")
[ ! "$APPLICATION_NAME" ] && MISSING+=("APPLICATION_NAME")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "ERROR: The following environment variables are not set:"
  printf '\t%s\n' "${MISSING[@]}"
  exit 1
fi

if [ "$COMMIT" == "" ]; then
  COMMIT=$(git rev-parse HEAD)
fi

if [ "$BRANCH" = "" ]; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
fi

TAG_COMMAND=
if [ "$tag" ]; then
  echo "You set tag"
  TAG_COMMAND="--tag $tag"
fi


if [ "$PACT_BROKER_TOKEN" ]; then
  echo "You set token"
  PACT_BROKER_TOKEN_ENV_VAR_CMD="-e PACT_BROKER_TOKEN=$PACT_BROKER_TOKEN"
fi

if [ "$PACT_BROKER_USERNAME" ]; then
  echo "You set username"
  PACT_BROKER_USERNAME_ENV_VAR_CMD="-e PACT_BROKER_USERNAME=$PACT_BROKER_USERNAME"
fi

if [ "$PACT_BROKER_PASSWORD" ]; then
  echo "You set password"
  PACT_BROKER_PASSWORD_ENV_VAR_CMD="-e PACT_BROKER_PASSWORD=$PACT_BROKER_PASSWORD"
fi


echo "
PACT_BROKER_BASE_URL: '$PACT_BROKER_BASE_URL'
version: '$COMMIT'
application_name: '$APPLICATION_NAME'
branch: '$BRANCH'
"

docker run --rm \
    -e PACT_BROKER_BASE_URL=$PACT_BROKER_BASE_URL \
    $PACT_BROKER_TOKEN_ENV_VAR_CMD \
    $PACT_BROKER_USERNAME_ENV_VAR_CMD \
    $PACT_BROKER_PASSWORD_ENV_VAR_CMD \
    pactfoundation/pact-cli:latest \
    broker create-or-update-version \
    --pacticipant "$APPLICATION_NAME" \
    --version $COMMIT \
    --branch $BRANCH \
    $TAG_COMMAND
