import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'selfie_app.dart';
import 'objects/selfie.dart';

List<Selfie> pics = [
  new Selfie(owner: "Rando", timestamp: new DateTime.now(), path: "images/lake.0.jpg"),
];

class _GridTitleText extends StatelessWidget {
  final String text;

  const _GridTitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

List<GridTile> _buildSelfieGridTileList(BuildContext context) {
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

Widget buildSelfieGrid(BuildContext context) {
  final Orientation orientation = MediaQuery.of(context).orientation;
  return GridView.count(
    shrinkWrap: true,
    physics: const ScrollPhysics(),
    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
    padding: const EdgeInsets.all(4.0),
    childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
    children: _buildSelfieGridTileList(context));
}

class WeekTile extends StatelessWidget {
  final String title;
  final int week;
  final String description;

  WeekTile({
    this.title,
    this.week,
    this.description
  }) : super(key: ObjectKey(title));

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
      title: Text("Week $week - $title"),
      children: <Widget>[
        Container(
          child: Text(description)
        ),
        buildSelfieGrid(context)
        ],
      onExpansionChanged: (bool opened) {
        showSelfies(opened, week);
      },
    );
  }
}