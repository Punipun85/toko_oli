String formatRupiah(num value) {
  final digits = value.round().toString();
  final parts = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.insert(0, digits.substring(start, end));
  }
  return 'Rp ${parts.join('.')}';
}

String formatShortDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String titleCaseStatus(String value) {
  final words = value
      .replaceAll('_', ' ')
      .split(' ')
      .where((word) => word.isNotEmpty);
  return words
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
