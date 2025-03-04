#!/usr/bin/env bash

MISSING=()
[ ! "$PACT_BROKER_BASE_URL" ] && MISSING+=("PACT_BROKER_BASE_URL")
[ ! "$APPLICATION_NAME" ] && MISSING+=("APPLICATION_NAME")
[ ! "$environment" ] && MISSING+=("environment")

if [ "$COMMIT" == "" ]; then
  COMMIT=$(git rev-parse HEAD)
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "ERROR: The following environment variables are not set:"
  printf '\t%s\n' "${MISSING[@]}"
  exit 1
fi

APPLICATION_INSTANCE_COMMAND=
if [ "$application_instance" ]; then
  echo "You set application_instance"
  APPLICATION_INSTANCE_COMMAND="--application-instance $application_instance"
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
  application_name: '$APPLICATION_NAME'
  version: '$COMMIT'
  environment: '$environment'"

docker run --rm \
  -e PACT_BROKER_BASE_URL=$PACT_BROKER_BASE_URL \
  $PACT_BROKER_TOKEN_ENV_VAR_CMD \
  $PACT_BROKER_USERNAME_ENV_VAR_CMD \
  $PACT_BROKER_PASSWORD_ENV_VAR_CMD \
  pactfoundation/pact-cli:latest \
  broker record-deployment \
  --pacticipant "$APPLICATION_NAME" \
  --version $COMMIT \
  --environment $environment \
  $APPLICATION_INSTANCE_COMMAND
