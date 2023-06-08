class DecodeAutocomplete {
  String? locale;
  List<String>? results;

  DecodeAutocomplete({this.locale, this.results});

  DecodeAutocomplete.fromJson(Map<String, dynamic> json) {
    locale = json['locale'];
    if (json['results'] != null) {
      results = <String>[];
      json['results'].forEach(
        (v) {
          results?.add(v);
        },
      );
    }
  }

}
