import 'package:intl/intl.dart';

Future<String> getDateText(posts, index) async {
  var date;
  date = await DateFormat('dd/MM/yyyy')
      .format(DateTime.parse('${posts[index].updatedAt.toDate()}'));
  print('Date: $date');

  return date;
}