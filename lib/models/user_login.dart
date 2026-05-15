import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool status;
  String token;
  String message;
  dynamic id;
  String namaUser;
  String email;
  String role;

  UserLogin({
    required this.status,
    required this.token,
    required this.message,
    required this.id,
    required this.namaUser,
    required this.email,
    required this.role,
  });

  /// Simpan data login ke SharedPreferences
  Future<void> prefs() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('isLoggedIn', true);
    await sp.setString('token', token);
    await sp.setString('email', email);
    await sp.setString('nama_user', namaUser);
    await sp.setString('role', role);
    await sp.setString('id', id.toString());
  }

  /// Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('token');
  }

  /// Ambil nama user dari SharedPreferences
  static Future<String?> getNamaUser() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('nama_user');
  }

  /// Cek apakah sudah login
  static Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool('isLoggedIn') ?? false;
  }

  /// Logout — hapus semua data
  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}