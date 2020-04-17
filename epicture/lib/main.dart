import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import './Camera.dart';
import './Global.dart' as global;
import './Home.dart';
import './Login.dart';
import './Notifications.dart';
import './Profile.dart';
import './Search.dart';
import './Settings.dart';
import './Theme.dart' as theme;

Future<void> main() async {
  runApp(MyApp());
}

checkInternetConnectivity() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none)
    global.hasInternet = false;
  else if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)
    global.hasInternet = true;
}

navigateHome(BuildContext context) async {
  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()),);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();
    if (global.hasInternet == false)
      return RaisedButton(
        color: Colors.yellow[800],
        onPressed: (){navigateHome(context);},
        child: Text('Oops, seems like internet went on holiday! Please check that you are connected and try again.', style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2, textAlign: TextAlign.center)
      );
    return MaterialApp(
      title: 'EPICTURE',
      debugShowCheckedModeBanner: false,
      theme: global.lightTheme ? theme.LightThemeData : theme.DarkThemeData,
      home: MyHome(),
    );
  }
}

class MyProfile extends StatefulWidget {
  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();
    if (global.hasInternet == false)
      return RaisedButton(
          color: Colors.yellow[800],
          onPressed: (){navigateHome(context);},
          child: Text('Oops, seems like internet went on holiday! Please check that you are connected and try again', style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2, textAlign: TextAlign.center),
      );
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
              Tab(icon: Icon(Icons.notification_important)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfilePage(),
            NotificationsPage(),
            SettingsPage(),
          ],
        ),
      ),
      //  body: ListView(children: divided),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  int _selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    CameraPage(),
    SearchPage(),
  ];
  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();
    if (global.hasInternet == false)
      return RaisedButton(
        color: Colors.yellow[800],
        onPressed: (){navigateHome(context);},
        child: Text('Oops, seems like internet went on holiday! Please check that you are connected and try again', style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2, textAlign: TextAlign.center)
      );
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.centerRight,
            child: Text('Epicture', style: Theme.of(context).textTheme.title, textAlign: TextAlign.right,)),
        leading: new Container(
            child: IconButton(icon: Icon(Icons.person),
                onPressed: global.isLoggedin ? () {
                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => MyProfile()
                      )
                  );
                } : () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()
                      )
                  );
            }
          )
        ),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Camera', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
          ),
        ],
      ),
    );
  }
}
