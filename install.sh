#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage: ./install.sh (GoogleApiClientId) (GoogleApiClientSecret)"
  exit 1
fi

GoogleApiClientId=$1
GoogleApiClientSecret=$2
AppDir="$HOME/google_tasks_cli"
CredentialsFile="credentials.json"
EnvironmentVariablesFile="$HOME/.bashrc"

{
  sed -i.bak '/GoogleApiClientId/d' "$EnvironmentVariablesFile"
  sed -i '' '/GoogleApiClientSecret/d' "$EnvironmentVariablesFile"
  sed -i '' '/GoogleApiCredentialsFilePath/d' "$EnvironmentVariablesFile"
  sed -i '' '/google_tasks_cli/d' "$EnvironmentVariablesFile"
  sed -i '' '/^$/d' "$EnvironmentVariablesFile"
}

{
  printf "\n"
  echo "export GoogleApiClientId=${GoogleApiClientId}"
  echo "export GoogleApiClientSecret=${GoogleApiClientSecret}"
  echo "export GoogleApiCredentialsFilePath=${AppDir}/${CredentialsFile}"
  echo "export PATH=$PATH:${AppDir}/bin"
} >> "$EnvironmentVariablesFile"

mkdir -p "${AppDir}/bin"

{
  brew tap dart-lang/dart
  brew install dart
} || {
  apt-get update
  apt-get install -y dart
}

pub get
dart2native "bin/main.dart" -o "${AppDir}/bin/google_tasks_cli"

source "${EnvironmentVariablesFile}"
