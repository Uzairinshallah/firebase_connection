class users_model{
  late String f_name;
  late String s_name;
  late String address;
  late String phone_no;
  late String email;
  late String pass;

  users_model(
      this.f_name,
      this.s_name,
      this.address,
      this.phone_no,
      this.email,
      this.pass,
      );
  users_model.fromMap(Map<String,dynamic> data){

    f_name= data["f_name"];
    s_name=data["s_name"];
    address=data["address"];
    email=data["email"];
    phone_no= data["phone_no"];

  }
}