class MyUser{
  static const String collectionName = 'users';
  String? id;
  String? name;
  String? email;

  MyUser({required this.name, required this.email, required this.id});

  MyUser.fromFireStore (Map<String,dynamic>?data):this(
    name : data?['name'],
    email: data?['email'],
    id: data?['id']


  );
  Map <String, dynamic> toFireStore(){
    return {
      'id' :id,
      'name' : name,
      'email' : email
    };
  }
}


