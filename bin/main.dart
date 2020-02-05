import 'dart:io';

import 'package:google_tasks_cli/google_tasks_cli.dart';

Future<void> main(List<String> arguments) async {
  await GoogleTasksCLI().run();
  exit(0);
}
