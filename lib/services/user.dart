import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joycharm/models/response_data_map.dart';
import 'package:joycharm/models/user_login.dart';
import 'package:joycharm/services/url.dart' as url;

class UserService {

  Future registerUser(data) async {
    var uri = Uri.parse(url.baseUrl + "/Register User");
    var register = await http.post(uri, body: data);
    if (register.statusCode.toString().startsWith('2')) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: "Data berhasil ditambahkan",
          data: data,
        );
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: data["message"] ?? "Gagal register",
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "Gagal register dengan code error ${register.statusCode}",
      );
      return response;
    }
  }

  Future loginUser(data) async {
    var uri = Uri.parse(url.baseUrl + "/login");
    var register = await http.post(uri, body: data);
    if (register.statusCode.toString().startsWith('2')) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        UserLogin userLogin = UserLogin(
          status: data["status"],
          message: data["message"],
          id: data["user"]["id"],
          namaUser: data["user"]["nama_user"],
          email: data["user"]["email"],
          role: data["user"]["role"],
        );
        await userLogin.prefs();
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: "Sukses login user",
          data: data,
        );
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: 'Email dan password salah',
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "Gagal login dengan code error ${register.statusCode}",
      );
      return response;
    }
  }

  Future logoutUser() async {
    UserLogin userLogin = UserLogin();
    await userLogin.logout();
    ResponseDataMap response = ResponseDataMap(
      status: true,
      message: "Berhasil logout",
    );
    return response;
  }
}