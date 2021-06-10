import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

import 'config/routes.dart';
import 'home/models/country.dart';

void main() async {
  await initHiveForFlutter();
  Hive.registerAdapter(CountryAdapter());
  await Hive.openBox('userFavourite');
  await Hive.openBox('userVisited');


  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'My Countries',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
    initialRoute: Routes.splash,
    routes: appRoutes,
    );
}

