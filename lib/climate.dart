import 'package:flutter/material.dart';
import './util/utils.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class climate extends StatefulWidget {
  @override
  _climateState createState() => _climateState();
}

class _climateState extends State<climate> {
  String _cityUpdate;
  Future goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new changeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      _cityUpdate = results['enter'];
    }
    print(_cityUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Climate Info"),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              color: Colors.white,
              onPressed: () => goToNextScreen(context))
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              width: double.infinity,
              height: 1500.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            child: new Text(
              "${_cityUpdate == null ? util.defaultCity : _cityUpdate}",
              style: cityText(),
            ),
            alignment: Alignment.topRight,
            margin: new EdgeInsets.fromLTRB(0.0, 10.0, 20.9, 0.0),
          ),
          new Container(
              alignment: Alignment.center,
              child: new Image.asset("images/light_rain.png")),
          new Container(
            margin: const EdgeInsets.fromLTRB(25.0, 400.0, 0.0, 0.0),
            alignment: Alignment.centerLeft,
            child: updateTemp(_cityUpdate),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    appId = util.appId;
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${appId}&units=metric";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Widget updateTemp(String city) {
    return new FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    content['main']['temp'].toString() + " °C",
                    style: tempText(),
                  ),
                ),
                new ListTile(
                  title: new Text(
                    content['main']['pressure'].toString() + " mm",
                    style: tempText(),
                  ),
                ),
                new ListTile(
                  title: new Text("Humidity "+
                    content['main']['humidity'].toString(),
                    style: tempText(),
                  ),
                ),
              ],
            ),
          );
        } else
          return new Container();
      },
    );
  }
}

TextStyle cityText() {
  return new TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);
}

TextStyle tempText() {
  return new TextStyle(
      color: Colors.white,
      fontSize: 60.0,
      //fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500);
}

class changeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigoAccent,
        title: new Text("Change City"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: double.infinity,
              height: 900.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Enter City",
                    ),
                    controller: _cityFieldController,
                    keyboardType: TextInputType.text),
              ),
              new ListTile(
                title: new FlatButton(
                  child: new Text(
                    "Get Weather",
                  ),
                  textColor: Colors.white,
                  color: Colors.indigoAccent,
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
