class Request {
  String uid;
  String name;
  String phone;
  String email;
  String longitude;
  String latitude;
  String address;
  String status;
  String imageName;
  String img;

  Request.fromMap(Map<String, dynamic> data) {
    uid = data['user_uid'];
    name = data['user_name'];
    phone = data['user_phone'];
    email = data['user_email'];
    longitude = data['longitude'].toString();
    latitude = data['latitude'].toString();
    address = data['address'];
    status = data['status'];
    imageName = data['image_name'];
    img = data['image'];
  }
}
