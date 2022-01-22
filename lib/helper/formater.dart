String parseDate({day, month, year}) {
  if (day == '' || year == '' || month == '') return 'Error';
  return "${int.parse(day) < 10 ? '0' + day : day}/${int.parse(month) < 10 ? '0' + month : month}/$year";
}

Map<String, String> getDateYMD({required String date}) {
  List<String> d = date.split('/');
  return {
    'day' : d[0],
    'month': d[1],
    'year' : d[2],
  };
}
