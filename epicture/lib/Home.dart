import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Global.dart' as globals;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return myListView(context);
  }
}

class Post {
  final String title;
  final String username;
  final String picture;
  final int ups;
  final int downs;
  final int view;
  final int comment;

  Post(this.title, this.username, this.picture, this.downs, this.ups, this.view, this.comment);
}

const globalEndpoint = "https://api.imgur.com/3/";

Map<String, String> getHeaders() {
  Map<String, String> header = {};
  if (globals.accessToken != null) {
    header["Authorization"] = "Bearer " + globals.accessToken;
  } else {
    header["Authorization"] = "Client-ID " + globals.clientId;
  }
  return header;
}

Future <List<Post>> getImages ({int page = 0, String type = "trending"}) async {
  var data = await http.get(Uri.encodeFull(globalEndpoint + "gallery/t/" + type), headers: getHeaders());
  var jsonData = json.decode(data.body)["data"];
  List<Post> feed = [];

  for (var i in jsonData["items"]) {
    Post post = Post(i["title"], i["account_url"], i["images"][0]["link"], i["downs"], i["ups"], i["views"], i["comment_count"]);
    feed.add(post);
  }

  return feed;
}

@override Widget myListView(BuildContext context, {String type = "trending"}) {
  return new Scaffold(
    body: Container(
      child: FutureBuilder(
        future: getImages(page: 0, type: type),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Column(
                      children: <Widget>[
                        AppBar(
                          title: Column(
                            children: [
                              Text(snapshot.data[index].title, style: globals.bigFont ? TextStyle(fontSize: 25) : TextStyle(fontSize: 20), textAlign: TextAlign.left,),
                              Text("Posted by : " + snapshot.data[index].username, style: globals.bigFont ? TextStyle(fontSize: 15) : TextStyle(fontSize: 10), textAlign: TextAlign.left,),
                            ],
                          ),
                        ),
//                        Text(snapshot.data[index].picture, style: TextStyle(fontFamily: 'Roboto'),),
                        CachedNetworkImage(
                          imageUrl: snapshot.data[index].picture,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.arrow_upward, color: Colors.grey,),
                              title: Text(snapshot.data[index].ups.toString(), style: globals.bigFont ? TextStyle(fontSize: 20, color: Colors.grey) : TextStyle(fontSize: 15, color: Colors.grey)),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.arrow_downward, color: Colors.grey),
                              title: Text(snapshot.data[index].downs.toString(), style: globals.bigFont ? TextStyle(fontSize: 20, color: Colors.grey) : TextStyle(fontSize: 15, color: Colors.grey)),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.textsms, color: Colors.grey),
                              title: Text(snapshot.data[index].comment.toString(), style: globals.bigFont ? TextStyle(fontSize: 20, color: Colors.grey) : TextStyle(fontSize: 15, color: Colors.grey)),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.favorite_border, color: Colors.grey),
                              title: Text(""),
                            ),
                          ]
                        ),
                      ]
                    )
                  )
                );
              }
            );
          }
        },
      ),
    ),
  );
}