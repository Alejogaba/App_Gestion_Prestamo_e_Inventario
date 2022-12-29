class Version {
  String version;
  String? urlAndroid;
  String? urlWindows;
  bool esUltimaVersion;

  Version({this.version='0.0', this.urlAndroid, this.urlWindows,this.esUltimaVersion=false});

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      version: map['version'] ?? '',
      urlAndroid: map['url_android'] ?? '',
      urlWindows: map['url_windows'] ?? '',
      esUltimaVersion: map['es_ultima_version'] ?? false,
    );
  }
}
