class users_model {
  late String f_name;
  late String s_name;
  late String address;
  late String phone_no;
  late String email;
  late String pass;
  String? imageURL;

  users_model(this.f_name,
      this.s_name,
      this.address,
      this.phone_no,
      this.email,
      this.pass,
      this.imageURL,
      );

  users_model.fromMap(Map<String, dynamic> data) {
    f_name = data["f_name"];
    s_name = data["s_name"];
    address = data["address"];
    email = data["email"];
    phone_no = data["phone_no"];
    pass = data["password"];
    imageURL = data["imageURL"];
  }

  Map<String, dynamic> toJson() {
    return {
      "f_name": f_name,
      "s_name": s_name,
      "address": address,
      "phone_no": phone_no,
      "email": email,
      "password": pass,
      "imageURL": imageURL,
    };
  }
}