import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/country.dart';
import '../repository/local/local_source.dart';
import '../repository/remote/country_repo.dart';

/// provider with all home data
final homeProvider =
    ChangeNotifierProvider.autoDispose<HomeViewModel>((ref) => HomeViewModel());

/// future provider for countries
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final homeClient = ref.read(homeProvider);
  return await homeClient.countries;
});

final showFilteredList = Provider.family<List<Country>, String>((ref, id) {
  final homeView = ref.read(homeProvider);

  return homeView?.countriesList
      ?.where(
          (element) => element.name.toLowerCase().contains(id.toLowerCase()))
      ?.toList();
});

/// Responsible to store the state of the UI
class HomeViewModel extends ChangeNotifier {
  final CountryRemoteRepo _remoteRepo = CountryRemoteRepo();
  final CountryLocalRepo _localRepo = CountryLocalRepo();
  int _currentTabIndex = 0;
  set currentTabIndex(int index) {
    _currentTabIndex = index;
    refreshList(index);
    notifyListeners();
  }

  int get currentTabIndex => _currentTabIndex;

  List<Country> countriesList;

  List<Country> filtered = [];
  Box get favBox => _localRepo.favBox;
  Box get visitedBox => _localRepo.visitedBox;

  void refreshList(int index) {
    switch (index) {
      case 0:
        countriesList = filtered;
        notifyListeners();
        break;
      case 1:
        countriesList = favCountries;
        notifyListeners();
        break;
      case 2:
        countriesList = visitedCountries;
        notifyListeners();
        break;
    }
  }

  Future<List<Country>> get countries async =>
      countriesList = filtered = await _remoteRepo.getCountries();

  List<Country> filteredCountries(String query) {
    if (query.isNotEmpty) {
      countriesList = filtered
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
      return countriesList;
    }
    return countriesList = filtered;
  }

  List<Country> get favCountries => _localRepo.getFavData();

  List<Country> get visitedCountries {
    var visited = _localRepo.getVisitedData();
    visited..sort((a, b) => b.visitedTime.compareTo(a.visitedTime));
    return visited;
  }

  bool checkIfVisited(Country country) {
    if (visitedBox.isNotEmpty) {
      if (visitedBox.get(country.code) != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool checkIfFav(Country country) {
    if (favBox.isNotEmpty) {
      if (favBox.get(country.code) != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void handleVisited(dynamic key, dynamic value) {
    if (visitedBox.get(key) == null) {
      _localRepo.addToVisitedBox(key, value);
    } else {
      Country deselectedBox = visitedBox.get(key);
      deselectedBox.delete();
    }
    notifyListeners();
  }

  void handleFav(dynamic key, dynamic value) {
    if (favBox.get(key) == null) {
      _localRepo.addToFavBox(key, value);
    } else {
      Country deselectedBox = favBox.get(key);
      deselectedBox.delete();
    }
    notifyListeners();
  }
}
