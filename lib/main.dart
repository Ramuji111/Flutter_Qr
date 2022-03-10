import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  String? imageUrl;
  String? word;
  bool color = false;
  Color pickerColor = new Color(0xff443a49);
  AnimationController? _animationController;

  createQrCode(text, color) async{


    String uri = ('http://api.qrserver.com/v1/create-qr-code/?data=$word!&size=100x100');

    var response= await http.get(Uri.parse(uri));
    print("response " + response.body);
    setState(() {
      imageUrl = response.body;
    });

  }

  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  void _handleOnPressed(){
    setState(() {
      color = !color;
      color ? _animationController?.forward() :
          _animationController?.reverse();
    });
  }

  void changeColor(Color color){
    setState(() {
      pickerColor = color;
    });  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
        leading: Icon(Icons.android, color: Colors.greenAccent,),
        backgroundColor: Color.fromRGBO(0, 36, 124, 1),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.image, color: Colors.white,),
              onPressed: (){

              },
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(0, 36, 124, 1),
      body: ListView(
        children: [
          Center(
            child:Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/frame.png'),

                      ),
                    ),

                    imageUrl != null ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 190,
                        width: 190,
                        child: FadeInImage.assetNetwork(placeholder: "assets/loading.gif", image: imageUrl!),
                      ),
                    ): Container()


                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white70
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onChanged: (value){
                            setState(() {
                              word = value;
                            });
                          },
                          decoration: new InputDecoration(
                            icon: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.vpn_key, color: Colors.black87,),
                            ),
                            hintText: "Enter something",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(
                  height: 15,
                ),

                AnimatedContainer(
                  padding: EdgeInsets.all(10),
                  duration: Duration(milliseconds: 300),
                  width: 300,
                  height: color == false ? 70 : 280,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 51, 145, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 100),
                              child: Row(
                                children: [
                                  Text("COLOR", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                  ),),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: pickerColor,
                                      )
                                    ,)
                                ],
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.menu_arrow,

                                color: Colors.white,
                                progress: _animationController!,
                              ),
                              onPressed: () {
                                _handleOnPressed();
                              },
                            )
                          ],
                        ),
                        color == true ? Container(
                          height: 200,
                          child: MaterialPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                            enableLabel: true,
                          ),
                        ) : Container()
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color.fromRGBO(255, 144, 39, 1)
                      ),
                      child: FlatButton(
                        child: Text("Create QR", style: TextStyle(
                          color: Colors.white
                        ),),
                        onPressed: () async{
                          if (word != null) {
                            await createQrCode(word, "${pickerColor.red.toRadixString(16)}${pickerColor.green.toRadixString(16)}${pickerColor.blue.toRadixString(16)}");

                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color.fromRGBO(0, 180, 245, 1)
                      ),
                      child: FlatButton(
                         child: Text("Read QR", style: TextStyle(
                             color: Colors.white
                         ),),
                          onPressed: () {

                         }
                         ),
                    ),
                  ],
                )
               ],
            ),
          ),

        ],
      ),

    );

  }
}
