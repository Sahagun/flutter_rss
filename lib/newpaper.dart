import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

import 'global.dart';

int data = 3;

class NewPaper extends StatefulWidget {

  String url;
  NewPaper({Key key, @required this.url}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _NewPaperState(url);
}

class _NewPaperState extends State<NewPaper> {
  String url;

  _NewPaperState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newpaper"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            Column(
                children: <Widget>[
                  Expanded(
                    child:newsListView(url: url),
                  ),
                  ]
            )
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Global().loadXML(url);
      //   },
      //   child: Text("XML"),
      // ),

    );
  }
}

class newsListView extends StatelessWidget {
  String url;
  newsListView({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<XmlDocument>(
      future: Global().loadXML(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          XmlDocument data = snapshot.data;
          return _content(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }



  // <lastBuildDate>Sat, 30 Jan 2021 18:33:39 -0500</lastBuildDate>
  // <title>California</title>
  // <description>California news and features from the Los Angeles Times.</description>
  // <link>https://www.latimes.com</link>
  // <language>en-US</language>
  // <copyright>Los Angeles Times © 2020</copyright>

  // <item>
  // <title>Dodger Stadium&#x27;s COVID-19 vaccination site temporarily shut down after protesters gather at entrance</title>
  // <dc:creator>Marisa Gerber, Irfan Khan</dc:creator>
  // <pubDate>Sat, 30 Jan 2021 18:33:39 -0500</pubDate>
  // <link>https://www.latimes.com/california/story/2021-01-30/dodger-stadiums-covid-19-vaccination-site-shutdown-after-dozens-of-protesters-gather-at-entrance</link>
  // <guid>https://www.latimes.com/california/story/2021-01-30/dodger-stadiums-covid-19-vaccination-site-shutdown-after-dozens-of-protesters-gather-at-entrance</guid>
  //
  // <description><![CDATA[<p>The demonstrators included members of anti-vaccine and far-right groups.
  // </p>]]></description>
  // <content:encoded><![CDATA[<p>The demonstrators included members of anti-vaccine and far-right groups.
  // </p>]]></content:encoded>
  // <media:content url="https://ca-times.brightspotcdn.com/dims4/default/46e4a0d/2147483647/strip/true/crop/2400x1600+0+0/resize/1500x1000!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2Fc8%2F4d%2F849497d4415391cd4603d04f465c%2Fla-photos-1staff-705812-me-0130-vaccine-protest-009.IK.JPG" type="image/jpeg">
  // <media:description type="plain"><![CDATA[Los Angeles, CA - January 30: A protest organized by Shop Mask Free Los Angeles rally against COVID vaccine, masks and lockdowns at the vaccination site at Dodger Stadium on Saturday, Jan. 30, 2021 in Los Angeles, CA.(Irfan Khan / Los Angeles Times)]]></media:description>
  // <media:credit role="author" scheme="urn:ebu"><![CDATA[Irfan Khan/Los Angeles Times]]></media:credit>
  // </media:content>
  // </item>

  Text _text(XmlDocument document){
    // xml/rss
    final rss = document.firstElementChild;
    final channel = rss.firstElementChild;
    final title = channel.getElement("title").text;

    final articles = document.findAllElements('item');

    // final articlesTitle = articles.

    return Text(articles.length.toString());
    // return Text(articles.first.getElement("title").text.toString());
    // return Text(document.toString());
  }

  Center _content(XmlDocument document){
    final rss = document.firstElementChild;
    final channel = rss.firstElementChild;
    final title = channel.getElement("title").text;
    final articles = document.findAllElements('item');


    return Center(
      child: Column(
        children: <Widget>[
          Text(title,
              style: TextStyle(height: 1, fontSize: 32, fontWeight: FontWeight.bold),

    ),
          Expanded(
            child:_articles(articles),
          ),
        ],
      ),
    );

  }

  ListView _articles(Iterable<XmlElement> items){
    print(items.toString());
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return
            FlatButton(
              // child: Text(items[index].first.getElement("title").text.toString()),
              child: Text(items.elementAt(index).getElement("title").text),
              onPressed: () {
                _launchURL(items.elementAt(index).getElement("link").text);
              },
            );
        });
  }

  _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
}