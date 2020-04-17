import 'dart:convert';
import 'dart:io';
import 'package:Epicture/Home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Global.dart' as global;
import './Home.dart';

class CameraPage extends StatefulWidget {
  @override
  CameraPageState createState() => CameraPageState();
}

class _UploadData {
  String title = 'Title';
  String description = 'Description';
}


class CameraPageState extends State<CameraPage> {
  File imageFile;
  var _data = new _UploadData();

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openGallery(BuildContext context) async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = gallery;
    });
    Navigator.of(context).pop();
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Take a picture'),
                    onTap: (){_openCamera(context);},
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('Select from gallery'),
                    onTap: (){_openGallery(context);},
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<void> _addImage(BuildContext context) {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new Container(
                child: new ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Add a title'
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please add a title';
                            },
                            onSaved: (String value) {
                              this._data.title = value;
                            },
                          )
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Add a description'
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please add a description';
                              },
                              onSaved: (String value) {
                                this._data.description = value;
                              },
                            )
                        )
                      ],
                    ),
                    Container(
                      child: RaisedButton(
                        color: Colors.yellow[800],
                        onPressed: () {
                          uploadImage(_data.title, _data.description, imageFile);
                          CameraPage();
                        },
                        child: Text('Submit'),
                        ),
                    )
                ]
              )
            )
          )
        );
      }
    );
  }

  Widget _imageView() {
    if (imageFile == null)
      return Text("No image selected", style: global.bigFont ? Theme.of(context).textTheme.display4 : Theme.of(context).textTheme.display3);
    else
      return (Image.file(imageFile, width:400, height: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _imageView(),
            RaisedButton(
              color: Colors.yellow[800],
                onPressed: () {
              imageFile == null ? _optionsDialogBox(context) : uploadImage(_data.title, _data.description, imageFile); //_addImage(context);
            },
              child: imageFile == null ? Text("Select image", style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2) : Text("Upload image", style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2))
            ]
          )
        )
      )
    );
  }

  static uploadImage(title, description, File image) async {

  List<int> imageBytes = image.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  var url = "https://api.imgur.com/3/upload";

  var response = await http.post(url,
      headers: getHeaders(),
      body: {
        "title": title,
        "description": description,
        "image": base64Image,
      });
  return await json.decode(response.body);
  }
}
