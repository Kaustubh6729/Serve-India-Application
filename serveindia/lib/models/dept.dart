class Dept {
  String email;
  String password;
  String role;
  Dept.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    password = data['password'];
    role = data['role'];
  }
}
