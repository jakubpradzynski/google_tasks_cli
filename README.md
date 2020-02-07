# Google Tasks CLI

&nbsp;
[![buddy pipeline](https://app.buddy.works/jakubpradzynski/google-tasks-cli/pipelines/pipeline/237996/badge.svg?token=670afdbf3831caebf79f9f63149102ae4b3128655a842aab8ed7e721b99ec31c "buddy pipeline")](https://app.buddy.works/jakubpradzynski/google-tasks-cli/pipelines/pipeline/237996)

## Description
This app is a Command Line Interface for Google Tasks.

&nbsp;

## Installation

#### Requirements
- Dart - [Installation guide](https://dart.dev/get-dart)
- Project on [Google Console](https://console.developers.google.com/) with connected Tasks API
and created OAuth 2.0 Client Id - [Installation guide](https://developers.google.com/tasks/firstapp#register-your-project)

#### Environment variables
You have to set environment variables before you start using the app.

- GoogleApiClientId - it's **client id** key available in project
on [Google Console](https://console.developers.google.com/)
in created OAuth 2.0
- GoogleApiClientSecret - it's **client secret** key available in project
on [Google Console](https://console.developers.google.com/)
in created OAuth 2.0
- GoogleApiCredentialsFilePath - it's path to file where app store Google Api credentials,
for example: `~/google_tasks_cli/credentials.json`

#### Create executable file
Using `dart2native` create executable file in the place you want:
```
dart2native bin/main.dart -o ~/google_tasks_cli/bin/google_tasks_cli  
```

#### Add executable to PATH
In Fish Shell:
```
set -gx PATH $PATH ~/google_tasks_cli/bin
```

In Bash:
```
export PATH=$PATH:~/google_tasks_cli/bin
```

&nbsp;

## First run
When you run the app for the first time, you have to add allow app operate on your tasks data in Google account.
That's why you will be ask for enter to the given link and give appropriate permissions.
App will save received credentials to file set in environment variable **GoogleApiCredentialsFilePath**
and refresh token when it's necessary.