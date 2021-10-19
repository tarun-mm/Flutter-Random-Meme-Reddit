import 'dart:math';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MemeAPI {
  String? url;
  String? title;
  String? author;
  int? ups;

  Future<void> getMeme() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/subreddits.json');
    await file.create();
    if(await file.readAsString() == '') file.writeAsString('{"Memes": true}');

    String resp = await file.readAsString();
    Map subs = await jsonDecode(resp);

    List subreddits = [];
    subs.forEach((key, value) {
      if(value == true) subreddits.add(key);
    });

    String sub = '';
    if(subreddits.isNotEmpty) sub = subreddits[Random().nextInt(subreddits.length)];

    Response response = await get(Uri.parse('https://meme-api.herokuapp.com/gimme/$sub'));
    Map data = await jsonDecode(response.body);

    url = data['url'];
    title = data['title'];
    author = data['author'];
    ups = data['ups'];
  }
}