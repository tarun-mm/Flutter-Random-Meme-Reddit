import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/services/meme_api.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map? url;

  @override
  Widget build(BuildContext context) {
    url = ModalRoute.of(context)!.settings.arguments as Map?;

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Random Meme',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
        backgroundColor: const Color(0xff1f1f1f),
      ),
      body: SingleChildScrollView(
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
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
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
                            color: Colors.black,
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w900,
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
                            color: Colors.black,
                            fontFamily: "SourceSansPro",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                color: const Color(0xffc38fff),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Title:     ',
                            style: TextStyle(
                              fontFamily: "SourceSansPro",
                              fontWeight: FontWeight.w900,
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
                                fontWeight: FontWeight.w200,
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
                                fontWeight: FontWeight.w200,
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
                            width: 38,
                          ),
                          Flexible(
                            child: Text(
                              url!['ups'].toString(),
                              style: const TextStyle(
                                fontFamily: "SourceSansPro",
                                fontWeight: FontWeight.w200,
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
