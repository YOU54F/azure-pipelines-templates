#!/usr/bin/env bash

MISSING=()
[ ! "$PACT_BROKER_BASE_URL" ] && MISSING+=("PACT_BROKER_BASE_URL")
[ ! "$APPLICATION_NAME" ] && MISSING+=("APPLICATION_NAME")
[ ! "$CONTRACT" ] && MISSING+=("contract")
[ ! "$VERIFICATION_RESULTS" ] && MISSING+=("verification_results")

if [ "$COMMIT" == "" ]; then
  COMMIT=$(git rev-parse HEAD)
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "ERROR: The following environment variables are not set:"
  printf '\t%s\n' "${MISSING[@]}"
  exit 1
fi

CONTRACT_FILE_CONTENT_TYPE=${CONTRACT_CONTENT_TYPE:-"application/yml"}
VERIFICATION_RESULTS_CONTENT_TYPE=${VERIFICATION_RESULTS_CONTENT_TYPE:-"text/plain"}
SPECIFICATION=${specification:-"oas"}
VERIFICATION_EXIT_CODE=${VERIFICATION_EXIT_CODE:-0}

VERIFIER_TOOL=${VERIFIER_TOOL:-'azure-pipeline'}
VERIFICATION_RESULTS_FORMAT=${verification_results_format:-'text'}

if [ "$BRANCH" = "" ]; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
fi

TAG_COMMAND=
if [ "$tag" ]; then
  echo "You set tag"
  TAG_COMMAND="--tag $tag"
fi

if [ -z "$BUILD_URI" ]; then
# todo update to read these env vars
  build_url="$(System.CollectionUri)$(System.TeamProject)/_build/results?buildId=$(Build.BuildId)"
else
  build_url="$BUILD_URI"
fi

BUILD_URL_COMMAND=
if [ "$build_url" ]; then
  echo "You set build_url"
  BUILD_URL_COMMAND="--build-url $build_url"
fi

VERIFIER_VERSION_COMMAND=
if [ "$verifier_version" ]; then
  echo "You set verifier_version"
  VERIFIER_VERSION_COMMAND="--verifier-version $verifier_version"
fi


echo """
PACT_BROKER_BASE_URL: $PACT_BROKER_BASE_URL
APPLICATION_NAME: $APPLICATION_NAME
contract: $CONTRACT
verification_results: $VERIFICATION_RESULTS
verification_exit_code: $VERIFICATION_EXIT_CODE
branch: $BRANCH
build_url: $build_url
"""

docker run --rm \
  -w ${PWD} \
  -v ${PWD}:${PWD} \
  -e PACT_BROKER_BASE_URL=$PACT_BROKER_BASE_URL \
  -e PACT_BROKER_TOKEN=$PACT_BROKER_TOKEN \
  pactfoundation/pact-cli:latest \
  pactflow publish-provider-contract \
  $CONTRACT \
  --provider $APPLICATION_NAME \
  --provider-app-version $COMMIT \
  --branch $BRANCH \
  --specification $SPECIFICATION \
  --content-type $CONTRACT_FILE_CONTENT_TYPE \
  --verification-exit-code=$VERIFICATION_EXIT_CODE \
  --verification-results $VERIFICATION_RESULTS \
  --verification-results-content-type $VERIFICATION_RESULTS_CONTENT_TYPE \
  --verification-results-format $VERIFICATION_RESULTS_FORMAT \
  --verifier $VERIFIER_TOOL \
  $TAG_COMMAND \
  $BUILD_URL_COMMAND \
  $VERIFIER_VERSION_COMMAND
