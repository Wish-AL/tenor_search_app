/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class MediumItems {
  String? preview;
  List<int?>? dims;
  String? url;
  int? size;

  MediumItems({this.preview, this.dims, this.url, this.size});

  MediumItems.fromJson(Map<String, dynamic> json) {
    preview = json['preview'];
    if (json['dims'] != null) {
      List<String>? dims;
      json['dims'].forEach((v) {
        dims!.add(json['dims'].fromJson(v));
      });
    }
    url = json['url'];
    size = json['size'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['preview'] = preview;
  //   data['dims'] =dims != null ? dims!.map((v) => v?.toJson()).toList() : null;
  //   data['url'] = url;
  //   data['size'] = size;
  //   return data;
  // }
}

class Gif extends MediumItems {
  Gif({super.preview, super.dims, super.url, super.size});
  @override
  Gif.fromJson(super.json) : super.fromJson();
}

class Loopedmp4 extends MediumItems{
  Loopedmp4({super.preview, super.dims, super.url, super.size});
  @override
  Loopedmp4.fromJson(super.json) : super.fromJson();
}

class Mediumgif extends MediumItems {
  Mediumgif({super.preview, super.dims, super.url, super.size});
  @override
  Mediumgif.fromJson(super.json) : super.fromJson();
}

class Mp4 extends MediumItems {
  Mp4({super.preview, super.dims, super.url, super.size});
  @override
  Mp4.fromJson(super.json) : super.fromJson();
}

class Nanogif extends MediumItems {
  Nanogif({super.preview, super.dims, super.url, super.size});
  @override
  Nanogif.fromJson(super.json) : super.fromJson();
}

class Nanomp4 extends MediumItems {
  Nanomp4({super.preview, super.dims, super.url, super.size});
  @override
  Nanomp4.fromJson(super.json) : super.fromJson();
}

class Nanowebm extends MediumItems {
  Nanowebm({super.preview, super.dims, super.url, super.size});
  @override
  Nanowebm.fromJson(super.json) : super.fromJson();
}

class Tinygif extends MediumItems {
  Tinygif({super.preview, super.dims, super.url, super.size});
  @override
  Tinygif.fromJson(super.json) : super.fromJson();
}

class Tinymp4 extends MediumItems {
  double? duration;

  Tinymp4({this.duration, super.preview, super.dims, super.url, super.size});

  @override
  Tinymp4.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    url = json['url'];
    size = json['size'];
    preview = json['preview'];
    if (json['dims'] != null) {
      List<String>? dims;
      json['dims'].forEach((v) {
        dims!.add(json['dims'].fromJson(v));
      });
    }
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = Map<String, dynamic>();
//   data['duration'] = duration;
//   data['url'] = url;
//   data['size'] = size;
//   data['preview'] = preview;
//   data['dims'] =dims != null ? dims!.map((v) => v?.toJson()).toList() : null;
//   return data;
// }
}

class Tinywebm extends MediumItems {

  Tinywebm({super.preview, super.dims, super.url, super.size});
  @override
  Tinywebm.fromJson(super.json) : super.fromJson();
}

class Webm extends MediumItems {

  Webm({super.preview, super.dims, super.url, super.size});
  @override
  Webm.fromJson(super.json) : super.fromJson();
}
class Medium {
  Nanomp4? nanomp4;
  Tinywebm? tinywebm;
  Webm? webm;
  Gif? gif;
  Tinygif? tinygif;
  Nanogif? nanogif;
  Nanowebm? nanowebm;
  Mp4? mp4;
  Tinymp4? tinymp4;
  Loopedmp4? loopedmp4;
  Mediumgif? mediumgif;

  Medium({this.nanomp4, this.tinywebm, this.webm, this.gif, this.tinygif, this.nanogif, this.nanowebm, this.mp4, this.tinymp4, this.loopedmp4, this.mediumgif});

  Medium.fromJson(Map<String, dynamic> json) {
    nanomp4 = json['nanomp4'] != null ? Nanomp4?.fromJson(json['nanomp4']) : null;
    tinywebm = json['tinywebm'] != null ? Tinywebm?.fromJson(json['tinywebm']) : null;
    webm = json['webm'] != null ? Webm?.fromJson(json['webm']) : null;
    gif = json['gif'] != null ? Gif?.fromJson(json['gif']) : null;
    tinygif = json['tinygif'] != null ? Tinygif?.fromJson(json['tinygif']) : null;
    nanogif = json['nanogif'] != null ? Nanogif?.fromJson(json['nanogif']) : null;
    nanowebm = json['nanowebm'] != null ? Nanowebm?.fromJson(json['nanowebm']) : null;
    mp4 = json['mp4'] != null ? Mp4?.fromJson(json['mp4']) : null;
    tinymp4 = json['tinymp4'] != null ? Tinymp4?.fromJson(json['tinymp4']) : null;
    loopedmp4 = json['loopedmp4'] != null ? Loopedmp4?.fromJson(json['loopedmp4']) : null;
    mediumgif = json['mediumgif'] != null ? Mediumgif?.fromJson(json['mediumgif']) : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = Map<String, dynamic>();
//   data['nanomp4'] = nanomp4!.toJson();
//   data['tinywebm'] = tinywebm!.toJson();
//   data['webm'] = webm!.toJson();
//   data['gif'] = gif!.toJson();
//   data['tinygif'] = tinygif!.toJson();
//   data['nanogif'] = nanogif!.toJson();
//   data['nanowebm'] = nanowebm!.toJson();
//   data['mp4'] = mp4!.toJson();
//   data['tinymp4'] = tinymp4!.toJson();
//   data['loopedmp4'] = loopedmp4!.toJson();
//   data['mediumgif'] = mediumgif!.toJson();
//   return data;
// }
}
class Result {
  String? id;
  String? title;
  String? contentdescription;
  String? contentrating;
  String? h1title;
  List<Medium?>? media;
  double? created;
  String? itemurl;
  String? url;

  Result({this.id, this.title, this.contentdescription, this.contentrating, this.h1title, this.media, this.created, this.itemurl, this.url});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    contentdescription = json['content_description'];
    contentrating = json['content_rating'];
    h1title = json['h1_title'];
    if (json['media'] != null) {
      media = <Medium>[];
      json['media'].forEach((v) {
        media!.add(Medium.fromJson(v));
      });
    }
    created = json['created'];
    itemurl = json['itemurl'];
    url = json['url'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['id'] = id;
  //   data['title'] = title;
  //   data['content_description'] = contentdescription;
  //   data['content_rating'] = contentrating;
  //   data['h1_title'] = h1title;
  //   data['media'] =media != null ? media!.map((v) => v?.toJson()).toList() : null;
  //   data['created'] = created;
  //   data['itemurl'] = itemurl;
  //   data['url'] = url;
  //   return data;
  // }
}

class Root {
  List<Result?>? results;
  String? next;

  Root({this.results, this.next});

  Root.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Result>[];
      json['results'].forEach((v) {
        results!.add(Result.fromJson(v));
      });
    }
    next = json['next'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['results'] =results != null ? results!.map((v) => v?.toJson()).toList() : null;
  //   data['next'] = next;
  //   return data;
  // }
}


