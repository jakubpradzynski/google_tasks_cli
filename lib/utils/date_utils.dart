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
