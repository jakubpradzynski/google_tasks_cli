import 'package:google_tasks_cli/utils/date_utils.dart';
import 'package:test/test.dart';

void main() {
  group('should return date from date time in proper format', () {
    var inputsToExpected = {
      DateTime(2020, 1, 1): '2020-01-01',
      DateTime(2019, 10, 5): '2019-10-05',
      DateTime(1997, 2, 12): '1997-02-12'
    };
    inputsToExpected.forEach((input, expected) {
      test('$input -> $expected', () {
        expect(dateFromDateTime(input), expected);
      });
    });
  });

  group('should check if is same day', () {
    var inputsToExpected = {
      [DateTime(2020, 1, 1), DateTime(2020, 1, 1)]: true,
      [DateTime(2020, 2, 2, 2, 2, 2), DateTime(2020, 2, 2, 3, 3, 3)]: true,
      [DateTime(2020, 1, 1), DateTime(2020, 2, 2)]: false,
      [null, null]: false,
    };
    inputsToExpected.forEach((input, expected) {
      test('$input -> $expected', () {
        expect(isSameDay(input[0], input[1]), expected);
      });
    });
  });

}