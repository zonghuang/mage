String formatTime(int time) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

  // Format DateTime to a string with the local date and time
  String formattedDateTime =
      "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
      "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";

  return formattedDateTime;
}

String _twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  } else {
    return "0$n";
  }
}
