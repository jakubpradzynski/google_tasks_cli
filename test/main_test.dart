import 'package:test/test.dart';
import 'package:google_tasks_cli/google_tasks_cli.dart';

void main() {
  test('should run app', () {
    GoogleTasksCLI().run();
  });
}