textTrim(value) {
  value.text = value.text.trim();
  while (value.text.contains("  ")) {
    value.text = value.text.replaceAll("  ", " ");
  }
}