import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool status;
  String? namaUser;
  String? message;
  int? id;
  String? email;
  String? role;

  UserLogin({
    this.status = false,
    this.namaUser,
    this.message,
    this.id,
    this.email,
    this.role,
  });

  // Simpan data login ke SharedPreferences
  Future<void> prefs() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('is_login', status);
    await pref.setString('nama_user', namaUser ?? '');
    await pref.setString('message', message ?? '');
    await pref.setInt('user_id', id ?? 0);
    await pref.setString('email', email ?? '');
    await pref.setString('role', role ?? '');
  }

  // Ambil data login dari SharedPreferences
  Future<UserLogin> getUserLogin() async {
    final pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool('is_login') ?? false;

    if (isLogin) {
      return UserLogin(
        status: true,
        namaUser: pref.getString('nama_user'),
        id: pref.getInt('user_id'),
        email: pref.getString('email'),
        role: pref.getString('role'),
      );
    } else {
      return UserLogin(status: false);
    }
  }

  // Hapus data login (logout)
  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('is_login');
    await pref.remove('nama_user');
    await pref.remove('message');
    await pref.remove('user_id');
    await pref.remove('email');
    await pref.remove('role');
  }
}