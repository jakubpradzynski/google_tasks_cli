# Google Tasks CLI

&nbsp;
![Travis (.com)](https://img.shields.io/travis/com/jakubpradzynski/google_tasks_cli?label=Google%20Tasks%20CLI)

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

### Installation scripts
If you don't need to configure app setup you can use install scripts.
There are 2 scripts available for bash and fish shell.
Both require to pass *clientId* and *clientSecret* from [Google Console](https://console.developers.google.com/).

Bash:

```./install.sh clientId clientSecret```

Fish:

```./install.fish clientId clientSecret```


Then you can just run the app by command `google_tasks_cli`.

&nbsp;

## First run
When you run the app for the first time, you have to add allow app operate on your tasks data in Google account.
That's why you will be ask for enter to the given link and give appropriate permissions.
App will save received credentials to file set in environment variable **GoogleApiCredentialsFilePath**
and refresh token when it's necessary.

![Authorization Link View](screenshots/AuthorizationLinkView.png)

&nbsp;

## Notifications
On **MacOS** when you start app, you will receive notifications about tasks to do with due date set on today.
If you wan't to change alert style you have to go to `System Preferences` > `Notifications` > `Script Editor`
and change the `alert style` to `Alerts`:

![Settings](https://i.stack.imgur.com/uDGa1.png)

&nbsp;

## Usage

### Lists view
<p align="center">
    <img src="screenshots/ExampleListsView.png">
</p>

### Task list view
<p align="center">
    <img src="screenshots/ExampleListView.png">
</p>

### Task view
<p align="center">
    <img src="screenshots/ExampleTaskView.png">
</p>

### Clearing task notes and due date
When you edit task you can write `null` in notes and due date to clear them.

### Multiline task notes
You can write task notes in multiline by ending line with ` \ `.
