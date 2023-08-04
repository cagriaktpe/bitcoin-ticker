import 'dart:convert';
import 'dart:io';

class Networking {

  Future<Map<String, dynamic>> makeGETRequest(String url, String apiKey) async {
    HttpClient httpClient = new HttpClient();
    Uri uri = Uri.parse(url);
    HttpClientRequest request = await httpClient.getUrl(uri);
    request.headers.set('x-ba-key', apiKey);

    print(uri);

    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    httpClient.close();

    if(response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to load data');
    }
  }

}