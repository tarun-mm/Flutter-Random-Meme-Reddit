import 'package:http/http.dart';
import 'dart:convert';

class MemeAPI {
  String? url;
  String? title;
  String? author;
  int? ups;

  Future<void> getMeme() async {
    Response response = await get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
    Map data = jsonDecode(response.body);

    url = data['url'];
    title = data['title'];
    author = data['author'];
    ups = data['ups'];
  }
}