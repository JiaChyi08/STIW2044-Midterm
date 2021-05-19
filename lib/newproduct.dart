import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:midtermstiw2044myshop/main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class NewProduct extends StatefulWidget {
 

  const NewProduct({Key key, }) : super(key: key);
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  ProgressDialog pr;
  double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.png';
  File _image;
  bool _visible = true;
  TextEditingController prnameController = new TextEditingController();
  TextEditingController prtypeController = new TextEditingController();
  TextEditingController prpriceController = new TextEditingController();
  TextEditingController prqtyController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("KB" + visible.toString());
        if (visible) {
          _visible = false;
        } else {
          _visible = true;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title:Text('New Product'),
      ),
      floatingActionButton: Visibility(
          visible: _visible,
          child: FloatingActionButton.extended(
            label: Text('Submit'),
            onPressed: () {
              _postuserGramDialog();
            },
            icon: Icon(Icons.add),
          )),
      body: Center(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {_onPictureSelectionDialog()},
                    child: Container(
                        height: screenHeight / 2.5,
                        width: screenWidth / 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image),
                            fit: BoxFit.scaleDown,
                          ),
                          // border: Border.all(
                          //   width: 3.0,
                          //   color: Colors.grey,
                          // ),
                          // borderRadius: BorderRadius.all(Radius.circular(
                          //         10.0) //         <--- border radius here
                          //     ),
                        )),
                  ),
                  Text("Click image to take your product picture",
                      style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  SizedBox(height: 10),
                   TextFormField(
                    controller: prnameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText:'Product Name:',
                      hintText: 'Please insert your Product Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                   TextFormField(
                    controller: prtypeController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText:'Type:',
                      hintText: 'Please insert your Product Type',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                   TextFormField(
                    controller: prpriceController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText:'Price (RM):',
                      hintText: 'Please insert your Product Price',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: prqtyController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText:'Quantity:',
                      hintText: 'Please insert your Product Quantity',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ))),
        ),
      ),
    );
  }

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  void _postuserGramDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Image is empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Upload your product???"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postuserGram();
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _postuserGram() async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Inserting new product...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String name = prnameController.text.toString();
    String type = prtypeController.text.toString();
    String price = prpriceController.text.toString();
    String qty = prqtyController.text.toString();
    print(name);
    http.post(
        Uri.parse("https://lowtancqx.com/s270964/myshop/php/newproduct.php"),
        body: {
          "name": name,
          "type": type,
          "price": price,
          "qty": qty,
          "encoded_string": base64Image
        }).then((response) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _image = null;
          prnameController.text = "";
          prtypeController.text = "";
          prpriceController.text = "";
          prqtyController.text = "";
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen())
                );
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}