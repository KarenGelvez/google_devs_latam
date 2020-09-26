import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details.dart';

class City {
  final String name;
  final String image;
  final String location;
  final String description;

  City({this.name, this.image, this.location, this.description});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<City> cities = [];

  bool listMode = true;

  void onRefresh() async {
    final res = await http
        .get('http://www.json-generator.com/api/json/get/cfMiozZbQO?indent=2');

    final list = jsonDecode(res.body);
    cities.clear();
    for (int i = 0; i < list.length; i++) {
      final map = list[i];
      cities.add(City(
        name: map['name'],
        image: map['image'],
        location: map['city'] + ', ' + map['country'],
        description: map['description'],
      ));
    }

    setState(() {});
  }

  void onChange() {
    setState(() {
      listMode = !listMode;
    });
  }

  void goDetails(City city) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Details(city: city)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('7 Wonders'),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: onRefresh),
            IconButton(icon: Icon(Icons.queue_play_next), onPressed: onChange),
          ],
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 700),
          child: listMode
              ? ListView.builder(
                  itemCount: cities.length,
                  itemExtent: 200,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return GestureDetector(
                        onTap: () => goDetails(city),
                        child: CityItem(city: city));
                  })
              : GridView.builder(
                  itemCount: cities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return GestureDetector(
                        onTap: () => goDetails(city),
                        child: CityItem(city: city));
                  }),
        ));
  }
}

class CityItem extends StatelessWidget {
  final City city;
  const CityItem({this.city, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Hero(
          tag: city.name,
          child: Image.network(
            city.image,
            fit: BoxFit.cover,
          ),
        )),
        Center(child: Text(city.name)),
      ],
    );
  }
}
