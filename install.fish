#!/usr/local/bin/fish

if test (count $argv) != 2
  echo "Usage: ./install.fish (GoogleApiClientId) (GoogleApiClientSecret)"
  exit 1
end

set GoogleApiClientId $argv[1]
set GoogleApiClientSecret $argv[2]
set AppDir $HOME/google_tasks_cli
set CredentialsFile credentials.json
set EnvironmentVariablesFile $HOME/.config/fish/config.fish

sed -i.bak '/GoogleApiClientId/d' $EnvironmentVariablesFile
sed -i '' '/GoogleApiClientSecret/d' $EnvironmentVariablesFile
sed -i '' '/GoogleApiCredentialsFilePath/d' $EnvironmentVariablesFile
sed -i '' '/google_tasks_cli/d' $EnvironmentVariablesFile
sed -i '' '/^$/d' $EnvironmentVariablesFile

printf "\n" >> $EnvironmentVariablesFile
echo "set -gx GoogleApiClientId $GoogleApiClientId" >> $EnvironmentVariablesFile
echo "set -gx GoogleApiClientSecret $GoogleApiClientSecret" >> $EnvironmentVariablesFile
echo "set -gx GoogleApiCredentialsFilePath $AppDir/$CredentialsFile"  >> $EnvironmentVariablesFile
echo "set -gx PATH \$PATH $AppDir/bin" >> $EnvironmentVariablesFile

mkdir -p "$AppDir/bin"

if test (uname) = "Darwin"
    brew tap dart-lang/dart && brew install dart
else
    apt-get update && apt-get install -y dart
end

pub get
dart2native "bin/main.dart" -o "$AppDir/bin/google_tasks_cli"

. $EnvironmentVariablesFile
