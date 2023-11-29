// convert dateTime object to a String yyyy mm dd
String dateTimeToString(DateTime dateTime) {
  // yyyy for year format
  String year = dateTime.year.toString();

  // mm for the month format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // dd for day format
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
