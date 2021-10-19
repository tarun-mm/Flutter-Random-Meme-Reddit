import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/services/meme_api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map? url;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    url = ModalRoute.of(context)!.settings.arguments as Map?;

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Random Meme',
          style: TextStyle(
            color: Color(0xffc38fff),
          ),
        ),
        backgroundColor: const Color(0xff1f1f1f),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff1c1c1c),
            ),
            color: const Color(0xff1c1c1c),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                fit: BoxFit.fitHeight,
                imageUrl: url!['url'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final directory = await getApplicationDocumentsDirectory();
                      final file = File('${directory.path}/subreddits.json');

                      await file.create();

                      if(await file.readAsString() == ""){
                        file.writeAsString('{"Memes": true}');
                      }
                      Map data = jsonDecode(await file.readAsString());

                      Navigator.pushNamed(context, '/select', arguments: {
                        'data': data,
                      });
                    },
                    child: const Card(
                      color: Color(0xffc38fff),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          ' r/ ',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(
                          'Loading Meme',
                          style: TextStyle(
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(bottom: screenHeight*.83),
                      ));

                      MemeAPI instance = MemeAPI();
                      await instance.getMeme();
                      setState(() {
                        url!['url'] = instance.url;
                        url!['title'] = instance.title;
                        url!['author'] = instance.author;
                        url!['ups'] = instance.ups;
                      });
                    },
                    child: const Card(
                      color: Color(0xffc38fff),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Share.share(
                        'Checkout this Great Meme that i found ${url!['url']}',
                      );
                    },
                    child: const Card(
                      color: Color(0xffc38fff),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'Share',
                          style: TextStyle(
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                color: const Color(0xffc38fff),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Title:     ',
                            style: TextStyle(
                              fontFamily: "SourceSansPro",
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: Text(
                              url!['title'],
                              style: const TextStyle(
                                fontFamily: "SourceSansPro",
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Author:',
                            style: TextStyle(
                              fontFamily: "SourceSansPro",
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: Text(
                              url!['author'],
                              style: const TextStyle(
                                fontFamily: "SourceSansPro",
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.thumb_up_rounded,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          Flexible(
                            child: Text(
                              url!['ups'].toString(),
                              style: const TextStyle(
                                fontFamily: "SourceSansPro",
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
