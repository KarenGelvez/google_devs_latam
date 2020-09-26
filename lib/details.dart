import 'package:flutter/material.dart';

import 'home.dart';

class Details extends StatelessWidget {
  final City city;
  const Details({this.city, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(city.name),
        ),
        body: Column(
          children: [
            Expanded(
              child: Hero(
                  tag: city.name,
                  child: Image.network(city.image, fit: BoxFit.cover)),
            ),
            Center(
              child: Text(
                city.location,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontStyle: FontStyle.italic, color: Colors.black),
              ),
            ),
            Text(city.description),
          ],
        ));
  }
}
