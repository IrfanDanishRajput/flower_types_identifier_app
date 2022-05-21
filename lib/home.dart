import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    final output = await Tflite.runModelOnImage(
        path: _image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/flowers_type_identifier_model.tflite",
        labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                const Text(
                  'Flowers  Recognizer  App',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      fontFamily: "Signatra"),
                ),
                const SizedBox(height: 50),
                Center(
                  child: _loading
                      ? SizedBox(
                          width: 350,
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/flowers.png'),
                              const SizedBox(height: 50),
                            ],
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 250,
                              child: Image.file(_image),
                            ),
                            const SizedBox(height: 20),
                            if (_output != null)
                              Text(
                                '${_output![0]['label']}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            const SizedBox(height: 10),
                          ],
                        ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox.fromSize(
                        size: const Size(100, 100), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.tealAccent, // button color
                            child: InkWell(
                              splashColor: Colors.green, // splash color
                              onTap: () {
                                pickImage();
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ), // icon
                                  Text("Camera"), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      SizedBox.fromSize(
                        size: const Size(100, 100), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.tealAccent, // button color
                            child: InkWell(
                              splashColor: Colors.green, // splash color
                              onTap: () {
                                pickGalleryImage();
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.photo,
                                    size: 40,
                                  ), // icon
                                  Text("Gallery"), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
