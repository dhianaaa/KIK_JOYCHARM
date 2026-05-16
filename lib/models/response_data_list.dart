class ResponseDataList {
  bool status;
  String message;
  List<dynamic> data;

  ResponseDataList({
    required this.status,
    required this.message,
    this.data = const [],
  });
}