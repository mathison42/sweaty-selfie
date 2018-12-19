import 'package:camera/camera.dart' show CameraDescription, availableCameras;
import 'package:flutter/material.dart';
import 'camera.dart' show CameraApp;
import 'grid.dart';
import 'objects/selfie.dart';
import 'objects/week.dart';

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
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Week> weeks = <Week>[
    new Week(
      title: "Running Short",
      description: [
        '''1) Square Agility: 2 reps right, 2 reps left; 1 min rests
2) Square Diagonal: 3 reps right, 3 reps left 30sec - 30 sec rests
3) Sprints @ 80%:
  2x300m   4 min rests
  2x200m   2 min rests
  2x100m   1 min rests''',
      "3 miles",
      '''Square Agility: 2 reps right, 2 reps left; 1 min rests
Square Diagonal  3 reps right, 3 reps left 30 sec rests
Shuttles: sprint 15 yds down and back, sprint 20 yds down and back, rest. Thats 1 rep. Complete 5 reps with 1.5 min rest'''
      ],
      num: 1),
    new Week(
      title: "Running Long",
      description: [
        "Day 1) 7 Miles\nDay 2) 15 Miles"
        ],
      num: 2
    ),

  ];

  ListView lv = ListView(children:  <Widget>[],);

  @override
  void initState() {
    super.initState();
    lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
        return WeekTile(
          title: weeks[weeks.length-index-1].title,
          week : weeks[weeks.length-index-1].num,
          description : weeks[weeks.length-index-1].description[0],
          );
    });
  }

  void addPicture(String picPath) {
    setState(() {
      pics.add(new Selfie(owner: "Falcore", timestamp: new DateTime.now(), path: picPath));
      lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
        return WeekTile(
          title: weeks[weeks.length-index-1].title,
          week : weeks[weeks.length-index-1].num,
          description : weeks[weeks.length-index-1].description[0],
          );
      });
    });
  }

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
