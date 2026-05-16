import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/history_transaksi.dart';
import '../models/response_data_list.dart';
import '../models/response_data_map.dart';
import 'url.dart' as url;

class Pesan {

  /// ================= SIMPAN TRANSAKSI =================
  // dataRequest contoh:
  // {"pesan": [{"barang_id": 155, "qty": 2}, {"barang_id": 156, "qty": 1}]}
  Future<ResponseDataMap> saveToDB(dynamic dataRequest) async {
    var uri = Uri.parse("${url.baseUrl}/transaksi");

    try {
      var simpanPesan = await http.post(
        uri,
        body: json.encode(dataRequest),
        headers: {'Content-Type': 'application/json'},
      );

      print("TRANSAKSI RESPONSE: ${simpanPesan.body}");

      var data = json.decode(simpanPesan.body);

      if (simpanPesan.statusCode == 200) {
        if (data["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Transaksi berhasil",
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: data["message"] ?? "Transaksi gagal",
          );
        }
      } else {
        print("ERROR CODE: ${simpanPesan.statusCode}");
        return ResponseDataMap(
          status: false,
          message: "Gagal transaksi dengan code error ${simpanPesan.statusCode}",
        );
      }
    } catch (e) {
      print("TRANSAKSI ERROR: $e");
      return ResponseDataMap(
        status: false,
        message: "Fatal error: $e",
      );
    }
  }

  /// ================= GET HISTORY TRANSAKSI =================
  Future<ResponseDataList> getHistory() async {
    var uri = Uri.parse("${url.baseUrl}/history transaksi");

    try {
      var response = await http.get(uri);

      print("HISTORY RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;

        List<HistoryTransaksi> listHistory =
            data.map((e) => HistoryTransaksi.fromJson(e)).toList();

        return ResponseDataList(
          status: true,
          message: "Sukses mengambil history transaksi",
          data: listHistory,
        );
      }
    } catch (e) {
      print("HISTORY ERROR: $e");
    }

    return ResponseDataList(
      status: false,
      message: "Gagal mengambil history transaksi",
      data: [],
    );
  }
}