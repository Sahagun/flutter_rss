import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global.dart';
import 'newpaper.dart';

class RssListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print("RssListView Build");

    return FutureBuilder<List<String>>(
      future: Global().fbLoadRSS(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("RssListView hasdata");
          List<String> data = snapshot.data;
          print("RssListView $data");
          return _rssListView(data);
        } else if (snapshot.hasError) {
          print("RssListView haserror");
          return Text("${snapshot.error}");
        }
        print("Loading");
        return CircularProgressIndicator();
      },
    );
  }

  ListView _rssListView(data) {
    print("RssListView _rssListView data");
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          print(data[index]);
          return
            FlatButton(
              child: Text(data[index]),
              onPressed: () {
                Navigator.push (
                  context,
                  MaterialPageRoute(builder: (context) => NewPaper(url: data[index])),
                );
              },
            );
        });
  }

}