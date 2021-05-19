import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'newproduct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MainScreen(title: 'My Shop'),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _productList;
  String titleCenter = "Loading...";
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: Center(
        child: Column(
          children: [
            _productList == null 
            ? Flexible(
                child: Center(
                  child: Text("No data")),
            )
            : Flexible(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: GridView.builder(
                      itemCount: _productList.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: (screenWidth / screenHeight) /1.2),
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            child: InkWell(
                              onTap: (){
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey[600],
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:BorderRadius.only(
                                      topLeft:Radius.circular(10),
                                      topRight:Radius.circular(10),),
                                      child: CachedNetworkImage(
                                        imageUrl: "https://lowtancqx.com/s270964/myshop/images/${_productList[index]['prid']}.png",
                                        height: 160,
                                        width: 185,)
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                        child: Text(_productList[index]['prname'],
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,)),
                                        ),
                                      ] 
                                    ), 
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Text(_productList[index]['prtype'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize:12,),),
                                        ),
                                        
                                      ],),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Text("Quantity: "+_productList[index]['prqty'],
                                          style: TextStyle(fontSize:13),),
                                        ),
                                      ],
                                    ),
                                     Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Text("RM: "+_productList[index]['prprice'],
                                          style: TextStyle(fontSize:18,fontWeight:FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(67, 5, 5, 0),
                                          child: Text(""+_productList[index]['datecreated'],
                                          style: TextStyle(fontSize:12),),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                    ),
                  ),
              )
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=>NewProduct())
          );
        },
        child: Icon(Icons.add),),
    );
  }
    void _loadProducts() {

    http.post(
      Uri.parse("https://lowtancqx.com/s270964/myshop/php/loadproducts.php"),
      body: {
      }).then(
        (response){
          if(response.body == "nodata"){
            titleCenter = "No data";
            return;
          }else{
            var jsondata = json.decode(response.body);
            _productList = jsondata["products"];
            titleCenter = "Contain Data";
            setState(() {});
            print(_productList);
          }
      }
    );
  }
}