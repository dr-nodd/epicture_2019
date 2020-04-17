import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import './Global.dart' as global;
import './Home.dart' as home;

class Tag {
  final String tag;
  final String display_tag;
  final String picture;

  Tag(this.tag, this.display_tag, this.picture);
}

Future <List<Tag>> getTags () async {
  var data = await http.get(Uri.encodeFull(home.globalEndpoint + "tags"), headers: home.getHeaders());
  var jsonData = json.decode(data.body)["data"];
  List<Tag> feed = [];

  for (var i in jsonData["tags"]) {
    Tag tag = Tag(i["name"], i["display_name"], i["background_hash"]);
    feed.add(tag);
  }

  return feed;
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search', style: global.bigFont ? TextStyle(fontSize: 25, fontFamily: 'Roboto') : TextStyle(fontSize: 20, fontFamily: 'Roboto'));

  _createSearch() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
        filteredNames = null;
      });
    } else {
      setState(() {
        _searchText = _filter.text;
      });
    }
  }

  @override
  void initState() {
//    this._getSearch();
    super.initState();
    _filter.addListener(_createSearch);
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => _buildList()
            )
          );
        },
        child: Icon(Icons.search),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: FutureBuilder(
          future: getTags(),
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
                    return GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context, new MaterialPageRoute(
                              builder: (context) => home.myListView(
                                  context, type: snapshot.data[index].tag
                              )
                          )
                          );
                        },
                        child: new Card(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                snapshot.data[index].display_tag,
                                style: TextStyle(fontFamily: 'Roboto'),
                              )
                          ),
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

  Widget _buildBar(BuildContext context) {
    TextField(
      controller: _filter,
    );
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    return new Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _getSearch(),
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
                                        Text(snapshot.data[index].title,
                                          style: global.bigFont ? TextStyle(
                                              fontSize: 25) : TextStyle(
                                              fontSize: 20),
                                          textAlign: TextAlign.left,),
                                        Text("Posted by : " +
                                            snapshot.data[index].username,
                                          style: global.bigFont ? TextStyle(
                                              fontSize: 15) : TextStyle(
                                              fontSize: 10),
                                          textAlign: TextAlign.left,),
                                      ],
                                    ),
                                  ),
//                        Text(snapshot.data[index].picture, style: TextStyle(fontFamily: 'Roboto'),),
                                  CachedNetworkImage(
                                    imageUrl: snapshot.data[index].picture,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  BottomNavigationBar(
                                      type: BottomNavigationBarType.fixed,
                                      items: [
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.arrow_upward,
                                            color: Colors.grey,),
                                          title: Text(snapshot.data[index].ups
                                              .toString(),
                                              style: global.bigFont
                                                  ? TextStyle(fontSize: 20,
                                                  color: Colors.grey)
                                                  : TextStyle(fontSize: 15,
                                                  color: Colors.grey)),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.arrow_downward,
                                              color: Colors.grey),
                                          title: Text(snapshot.data[index].downs
                                              .toString(),
                                              style: global.bigFont
                                                  ? TextStyle(fontSize: 20,
                                                  color: Colors.grey)
                                                  : TextStyle(fontSize: 15,
                                                  color: Colors.grey)),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.textsms,
                                              color: Colors.grey),
                                          title: Text(
                                              snapshot.data[index].comment
                                                  .toString(),
                                              style: global.bigFont
                                                  ? TextStyle(fontSize: 20,
                                                  color: Colors.grey)
                                                  : TextStyle(fontSize: 15,
                                                  color: Colors.grey)),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(Icons.favorite_border,
                                              color: Colors.grey),
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

  Future <List<home.Post>> _getSearch() async {
    List<home.Post> tempList = [];
    if (_searchText != "") {
      String query = "https://api.imgur.com/3/gallery/search?q=" +
          _searchText;
      final response = await http.get(query);
      final jsonResponse = json.decode(response.body)["data"];
      for (var i in jsonResponse) {
        home.Post post = home.Post(i["title"], i["account_url"], i["images"][0]["link"], i["downs"], i["ups"], i["views"], i["comment_count"]);
        tempList.add(post);
      }
    }
    return tempList;
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller : _filter,
          decoration: new InputDecoration(
            hintText: 'Your search here...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search', style: global.bigFont ? TextStyle(fontSize: 25, fontFamily: 'Roboto') : TextStyle(fontSize: 20, fontFamily: 'Roboto'));
        filteredNames = null;
        _filter.clear();
      }
    });
  }
}