extension StringExtensions on String {
  String removeDiacritics() {
    const withDiacritics = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutDiacritics = 'aeiouunAEIOUUN';

    return split('').map((char) {
      final index = withDiacritics.indexOf(char);
      return index != -1 ? withoutDiacritics[index] : char;
    }).join();
  }
}
