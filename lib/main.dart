import 'package:flutter/material.dart';
import 'camera.dart';
import 'selfie.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweaty Selfies',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Sweaty Selfies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Week {
  const Week({this.title, this.description, this.num, this.selfies});
  final String title;
  final String description;
  final int num;
  final List<Image> selfies;
}

List<String> pics = [
    "images/lake.0.jpg",
  ];

List<Container> _buildGridTileList(BuildContext context) {

  return List<Container>.generate(
      pics.length,
      (int index) =>
            Container (
              child: GestureDetector (
                onDoubleTap: () {
                  print("Tapped!!!!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelfieApp(pics[index])),
                  );
                },
                child: Container(
                  child: Image.asset(pics[index]),
                ),
              )
            )
  );
}

Widget buildGrid(BuildContext context) {
  return GridView.extent(
      shrinkWrap: true,
      maxCrossAxisExtent: 150.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _buildGridTileList(context));
}

class _MyTile extends StatelessWidget {
  _MyTile({this.title, this.week, this.description}) : super(key: ObjectKey(title));
  final String title;
  final int week;
  final String description;

  showSelfies(bool opened) {
    if (opened) {
      print('Week$week Open');
    } else {
      print('Week $week Closed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text('$title',
    //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    //   subtitle: Text('Week $week'),
    //   leading: Icon(
    //     Icons.cake,
    //     color: Colors.red[500],
    //   ),
    //   onTap: showSelfies()
    // );
    return ExpansionTile(
      leading: Icon(
        Icons.cake,
        color: Colors.red[500],
      ), 
      title: Text("Week $week - $title\n$description"),
      children: <Widget>[buildGrid(context)],
      onExpansionChanged: (bool opened) {
        showSelfies(opened);
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Week> weeks = <Week>[
    new Week(title: "Running Short", description: "Day 1) 3 Miles\nDay 2) 2 Miles", num: 1),
    new Week(title: "Running Long", description: "Day 1) 7 Miles\nDay 2) 15 Miles", num: 2),

  ];
  int _counter = 2;

  ListView lv = ListView(children:  <Widget>[],);

  @override
  void initState() {
    super.initState();
    lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
        return _MyTile(
          title: weeks[weeks.length-index-1].title,
          week : weeks[weeks.length-index-1].num,
          description : weeks[weeks.length-index-1].description,
          );
    });
  }

  void addPicture(String picPath) {
    setState(() {
      pics.add(picPath);
      lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
        return _MyTile(
          title: weeks[weeks.length-index-1].title,
          week : weeks[weeks.length-index-1].num,
          description : weeks[weeks.length-index-1].description,
          );
      });
    });
  }

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //     weeks.add(new Week(title: "Running Medium", description: "Day 1) 3 Miles - Day 2) 2 Miles", num: _counter));
  //     lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
  //       return _MyTile(title: weeks[weeks.length-index-1].title, week : weeks[weeks.length-index-1].num);
  //     });
  //     print("Count: " + weeks.length.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: lv,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String picPath = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraApp(cameras)),
          );
          if (picPath != null && picPath.isNotEmpty) {
           addPicture(picPath);
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
