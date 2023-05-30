/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class DecodeAutocomplete {
  String? locale;
  List<String?>? results;

  DecodeAutocomplete({this.locale, this.results});

  DecodeAutocomplete.fromJson(Map<String, dynamic> json) {
    locale = json['locale'];
    if (json['results'] != null) {
      List<String>? results;
      json['results'].forEach((v) {
        results!.add(json['results'].fromJson(v));
      });
    }
  }

}

