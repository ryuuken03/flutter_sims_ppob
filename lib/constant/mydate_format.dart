import 'package:intl/intl.dart';

class MyDateFormat{
  static String chanegFormat(
      String input, String inFormat, String outFormat) {
    var inputFormat = DateFormat(inFormat);
    var inputDate =
        inputFormat.parse(input);

    var outputFormat = DateFormat(outFormat,"id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}