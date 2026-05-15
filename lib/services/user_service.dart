import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/app_config.dart' as url;
import '../models/response_data_map.dart';
import '../models/user_login.dart';

class UserService {
  // ─── Register User ────────────────────────────────────────────────────────

  Future<ResponseDataMap> registerUser(Map<String, String> data) async {
    try {
      final uri = Uri.parse('${url.BaseUrl}/Register%20User');
      final response = await http.post(uri, body: data);

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decoded['status'] == true) {
          return ResponseDataMap(
            status: true,
            message: 'Registrasi berhasil! Silakan login.',
            data: decoded,
          );
        } else {
          // Validasi error dari backend (field errors)
          String message = '';
          if (decoded['message'] is Map) {
            for (String key in decoded['message'].keys) {
              final val = decoded['message'][key];
              if (val is List) {
                message += '${val[0]}\n';
              } else {
                message += '$val\n';
              }
            }
          } else {
            message = decoded['message']?.toString() ?? 'Registrasi gagal';
          }
          return ResponseDataMap(status: false, message: message.trim());
        }
      } else if (response.statusCode == 422) {
        // Unprocessable entity — validasi error
        String message = '';
        if (decoded['errors'] != null && decoded['errors'] is Map) {
          for (String key in decoded['errors'].keys) {
            final val = decoded['errors'][key];
            if (val is List) message += '${val[0]}\n';
          }
        } else {
          message = decoded['message'] ?? 'Data tidak valid';
        }
        return ResponseDataMap(status: false, message: message.trim());
      } else {
        return ResponseDataMap(
          status: false,
          message: 'Registrasi gagal (error ${response.statusCode})',
        );
      }
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: 'Tidak dapat terhubung ke server. Periksa koneksi kamu.',
      );
    }
  }

  // ─── Login User ───────────────────────────────────────────────────────────

  Future<ResponseDataMap> loginUser(Map<String, String> data) async {
    try {
      final uri = Uri.parse('${url.BaseUrl}/login');
      final response = await http.post(uri, body: data);

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        if (decoded['status'] == true) {
          final user = decoded['user'];
          final userLogin = UserLogin(
            status: decoded['status'],
            token: decoded['token'] ?? '',
            message: decoded['message'] ?? '',
            id: user['id'],
            namaUser: user['nama_user'] ?? user['name'] ?? '',
            email: user['email'] ?? '',
            role: user['role'] ?? 'user',
          );
          await userLogin.prefs();

          return ResponseDataMap(
            status: true,
            message: 'Login berhasil!',
            data: decoded,
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: decoded['message'] ?? 'Email atau password salah',
          );
        }
      } else if (response.statusCode == 401) {
        return ResponseDataMap(
          status: false,
          message: 'Email atau password salah',
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: 'Login gagal (error ${response.statusCode})',
        );
      }
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: 'Tidak dapat terhubung ke server. Periksa koneksi kamu.',
      );
    }
  }
}
