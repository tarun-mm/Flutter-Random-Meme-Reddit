import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meme_app/services/meme_api.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void firstMeme() async {
    MemeAPI instance = MemeAPI();
    await instance.getMeme();

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'url': instance.url,
      'title': instance.title,
      'author': instance.author,
      'ups': instance.ups,
    });
  }

  @override
  void initState() {
    super.initState();
    firstMeme();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff121212),
      body: SpinKitFoldingCube(
        color: Color(0xffc38fff),
        size: 48,
      ),
    );
  }
}
