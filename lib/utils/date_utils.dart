String dateFromDateTime(DateTime dateTime) {
  if (dateTime != null) return '${dateTime.year}-${_withLeadingZero(dateTime.month)}-${_withLeadingZero(dateTime.day)}';
  return null;
}

String _withLeadingZero(int number) {
  if (number < 10 && number >= 0) {
    return '0${number}';
  }
  return number.toString();
}

bool isSameDay(DateTime dt1, DateTime dt2) {
  if (dt1 == null || dt2 == null) return false;
  if (dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day) return true;
  return false;
}