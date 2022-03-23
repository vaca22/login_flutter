class User {
  final String id;
  final String toid;
  final String params;

  User(this.id, this.toid,this.params);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
       toid = json['toid'],
        params=json['params'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'toid': toid,
    'params':params,
  };
}