import 'package:intl/intl.dart';

String formatRupiah(double value) {
  return NumberFormat.currency(locale: 'ID', symbol: 'IDR ', decimalDigits: 0)
      .format(value);
}

String convertDateFormat(String date) {
  var parse = DateTime.parse(date);
  String day = parse.day < 10 ? '0${parse.day}' : parse.day.toString();
  String hour = parse.hour < 10 ? '0${parse.hour}' : parse.hour.toString();
  String minute =
      parse.minute < 10 ? '0${parse.minute}' : parse.minute.toString();

  return '$day ${getMonthShortless(parse.month)} ${parse.year}, $hour:$minute';
}

String getMonthShortless(int month) {
  if (month == 1) {
    return "Jan";
  } else if (month == 2) {
    return "Feb";
  } else if (month == 3) {
    return "Mar";
  } else if (month == 4) {
    return "Apr";
  } else if (month == 5) {
    return "May";
  } else if (month == 6) {
    return "Jun";
  } else if (month == 7) {
    return "Jul";
  } else if (month == 8) {
    return "Aug";
  } else if (month == 9) {
    return "Sep";
  } else if (month == 10) {
    return "Oct";
  } else if (month == 11) {
    return "Nov";
  } else {
    return "Dec";
  }
}
