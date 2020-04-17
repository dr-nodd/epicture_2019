import 'package:flutter/material.dart';
import './Global.dart' as global;
import './main.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> settings = [];
    settings.add(new SwitchListTile(
      title: Text('Automatically start video', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
      value: global.autoVideos,
      onChanged: (bool value) {
        setState(() {
          global.autoVideos = value;
        });
      },
      secondary: const Icon(Icons.video_library),
    ));
    settings.add(new SwitchListTile(
      title: Text('Light theme', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
      value: global.lightTheme,
      onChanged: (bool value) {
        setState(() {
          global.lightTheme = value;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => MyApp()));
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    ));
    settings.add(new SwitchListTile(
      title: Text('Bigger font', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
      value: global.bigFont,
      onChanged: (bool value) {
        setState(() {
          global.bigFont = value;
        });
      },
      secondary: const Icon(Icons.format_size),
    ));
    settings.add(new FlatButton.icon(
        onPressed: () {
          global.isLoggedin = false;
          global.accessToken = null;
          Navigator.pushReplacement(context,
              MaterialPageRoute(
              builder: (context) => MyApp()
            ));
          },
        icon: Icon(Icons.close),
        label: Text('Log out', style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3),
    ));
    return new ListView(
      padding: const EdgeInsets.all(8.0),
      children: settings,
    );
  }
}
