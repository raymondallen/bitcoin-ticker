import 'package:http/http.dart' as http;

class Networking {
  Future<http.Response> get(String url) async {
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      throw (e);
    }
  }
}
