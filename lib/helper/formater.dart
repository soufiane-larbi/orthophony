String parseDate({day, month, year}) {
  if (day == '' || year == '' || month == '') return 'Error';
  return "${int.parse(day) < 10 ? '0' + day : day}/${int.parse(month) < 10 ? '0' + month : month}/$year";
}
