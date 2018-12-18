import 'package:flutter/material.dart';
import 'camera.dart';
import 'selfie_app.dart';
import 'objects/selfie.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';

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

List<Selfie> pics = [
  new Selfie(owner: "Rando", timestamp: new DateTime.now(), path: "images/lake.0.jpg"),
];

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

List<GridTile> _buildGridTileList(BuildContext context) {

  return List<GridTile>.generate(
      pics.length,
      (int index) =>
            GridTile (
              footer: GridTileBar(
                backgroundColor: Colors.black45,
                title: _GridTitleText(pics[index].owner),
                subtitle: _GridTitleText(new DateFormat.yMd().add_jm().format(pics[index].timestamp)),
              ),
              child: GestureDetector (
                onDoubleTap: () {
                  print("Tapped!!!!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelfieApp(pics[index].path)),
                  );
                },
                child: Image.asset(pics[index].path)
              )
            )
  );
}

Widget buildGrid(BuildContext context) {
  final Orientation orientation = MediaQuery.of(context).orientation;
  return GridView.count(
    shrinkWrap: true,
    physics: const ScrollPhysics(),
    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
    padding: const EdgeInsets.all(4.0),
    childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
    children: _buildGridTileList(context));
}

class _MyTile extends StatelessWidget {
  _MyTile({this.title, this.week, this.description}) : super(key: ObjectKey(title));
  final String title;
  final int week;
  final String description;

  showSelfies(bool opened, int week) {
    if (opened) {
      print('Grabing selfies from week $week...');
    } else {
      print('Week $week Closed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        Icons.cake,
        color: Colors.red[500],
      ), 
      title: Text("Week $week - $title\n$description"),
      children: <Widget>[buildGrid(context)],
      onExpansionChanged: (bool opened) {
        showSelfies(opened, week);
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Week> weeks = <Week>[
    new Week(title: "Running Short", description: "Day 1) 3 Miles\nDay 2) 2 Miles", num: 1),
    new Week(title: "Running Long", description: "Day 1) 7 Miles\nDay 2) 15 Miles", num: 2),

  ];

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
      pics.add(new Selfie(owner: "Falcore", timestamp: new DateTime.now(), path: picPath));
      lv = new ListView.builder(itemCount: weeks.length, itemBuilder:(BuildContext ctxt, int index) {
        return _MyTile(
          title: weeks[weeks.length-index-1].title,
          week : weeks[weeks.length-index-1].num,
          description : weeks[weeks.length-index-1].description,
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
