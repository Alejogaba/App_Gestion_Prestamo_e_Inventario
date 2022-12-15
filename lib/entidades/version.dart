class Version {
  String version;
  String? urlAndroid;
  bool esUltimaVersion;

  Version(
    this.version,
    this.urlAndroid,
    this.esUltimaVersion
  );

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      map['version'] ?? '',
      map['url_android'] ?? '',
      map['es_ultima_version'] ?? false,
    );
  }
}
