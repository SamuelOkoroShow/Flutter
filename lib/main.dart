import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/card_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

Color forgra = const Color(0xFF0D1B2A);
Color bdazzled = const Color(0xFF2e5894);
Color oxford = const Color(0xFF1B263B);
Color shadowBlue = const Color(0xFF778DA9);
Color platinum = const Color(0xFFE0E1DD);
Color tomato = const Color(0xFFFF6347);
List<CardData> bookmarks = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(scaffoldBackgroundColor: oxford),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color c = const Color(0xFF42A5F5);
  // Random colors picked up from the web

  List<CardData> _repos = [];
  Future<List<CardData>> _getRepos() async {
    log('Async');
    List<CardData> cardRepos = [];
    try {
      final url =
          'https://api.github.com/search/repositories?q={q}&sort=stars&order=desc&per_page=10';

      var response = await http.get(url);

      var jsonRepos = jsonDecode(response.body)["items"];
      //log(jsonRepos.toString());
      for (var jsonRepo in jsonRepos) {
        cardRepos.add(CardData.fromJson(jsonRepo));
      }
    } catch (e) {
      log(e.toString());
    }
    log(cardRepos.length.toString());
    return cardRepos;
  }

  @override
  void initState() {
    _getRepos().then((value) {
      setState(() {
        _repos.addAll(value);
      });
    });
    super.initState();
  }

  void _openURL(url) async {
    try {
      if (await canLaunch(url))
        await launch(url);
      else
        // can't launch url, there is some error
        throw "Could not launch $url";
    } catch (e) {
      log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(children: [
          TextField(
            decoration: InputDecoration(
                fillColor: platinum,
                border: OutlineInputBorder(),
                hintText: 'Enter a search term'),
          ),
          Expanded(
              child: SizedBox(
                  height: 200.0,
                  child: new ListView.builder(
                    itemBuilder: (context, index) {
                      final item = _repos[index];
                      String snack = "";
                      return Dismissible(
                          key: Key(item.id.toString()),
                          onDismissed: (direction) {
                            log(direction.toString());
                            if (direction == DismissDirection.startToEnd) {
                              bookmarks.add(_repos[index]);
                              snack = "Added ${item.name} to Bookmarks";
                            }
                            if (direction == DismissDirection.endToStart) {
                              snack = "${item.name} dismissed";
                            }
                            setState(() {
                              _repos.removeAt(index);
                            });

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(snack)));
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(color: Colors.red),
                          child: Card(
                              child: InkWell(
                            onTap: () => _openURL(_repos[index].html_url),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: oxford,
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: forgra),
                                ),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_repos[index].name,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: platinum,
                                            fontWeight: FontWeight.w100)),
                                    Text(
                                        'Repo Stars: ' +
                                            _repos[index].stargazers.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: platinum,
                                            fontWeight: FontWeight.w300))
                                  ]),
                            ),
                          )));
                    },
                    itemCount: _repos.length,
                  )))
        ])));
  }
}
