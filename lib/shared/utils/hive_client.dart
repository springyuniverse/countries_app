import 'package:hive/hive.dart';


class HiveClient<T>{

  Box favBox =  Hive.box('userFavourite');
  Box visitedBox =  Hive.box('userVisited');

  void addToFavBox(dynamic key, dynamic value){
    favBox.put(key,value);
  }

  void addToVisitedBox(dynamic key, dynamic value){
    visitedBox.put(key,value);
  }
  List<T> getFavData() => favBox.values.toList().cast<T>();
  List<T> getVisitedData() => visitedBox.values.toList().cast<T>();

}