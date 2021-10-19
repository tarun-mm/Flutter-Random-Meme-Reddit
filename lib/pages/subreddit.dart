import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  Map? data;

  void _addSub() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Sub Reddit'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter New Sub Reddit',
              ),
              onSubmitted: (text) async {

                Response response = await get(Uri.parse('https://meme-api.herokuapp.com/gimme/$text'));
                Map temp = await jsonDecode(response.body);

                setState(()  {
                  if(temp['code'] == null) {
                    data![text] = false;
                  } else{
                    final double screenHeight = MediaQuery.of(context).size.height;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        'Invalid Subreddit',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: screenHeight*.75),
                    ));
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Widget _getItems() {
    return ListView.builder(
        itemCount: data!.values.toList().length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Dismissible(
            child: Card(
              margin: const EdgeInsets.only(top: 12),
              color: const Color(0xffc38fff),
              child: ListTile(
                leading: Text(
                  data!.keys.toList()[index],
                  style: const TextStyle(
                    fontFamily: "SourceSansPro",
                    fontSize: 16,
                  ),
                ),
                trailing: Checkbox(
                  activeColor: Color(0xff1f1f1f),
                  value: data![data!.keys.toList()[index]],
                  onChanged: (bool? value) {
                    setState(() {
                      data![data!.keys.toList()[index]] = value;
                    });
                  },
                ),
              ),
            ),
            key: UniqueKey(),
            onDismissed: (direction) {
              data!.remove(data!.keys.toList()[index]);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map? dat = ModalRoute.of(context)!.settings.arguments as Map?;
    data = dat!['data'];

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Select Subreddits',
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
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 76),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: const EdgeInsets.all(0),
                color: const Color(0xffc38fff),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: const [
                      Text(
                        'Subreddits whose memes you wish you to see',
                        style: TextStyle(
                          fontFamily: "SourceSansPro",
                          fontWeight: FontWeight.w200,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Invalid subreddits will be removed',
                        style: TextStyle(
                          fontFamily: "SourceSansPro",
                          fontWeight: FontWeight.w200,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                child: const Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: 128,
                  ),
                  color: Color(0xffc38fff),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: "SourceSansPro",
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file = File('${directory.path}/subreddits.json');

                  file.writeAsString(jsonEncode(data));

                  final double screenHeight = MediaQuery.of(context).size.height;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Data Saved',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: screenHeight*.75),
                  ));
                },
              ),
              _getItems(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffc38fff),
        onPressed: () {
          _addSub();
        },
        child: const Icon(
          Icons.post_add_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
