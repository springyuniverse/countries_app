import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../shared/utils/extensions.dart';
import '../models/country.dart';
import '../repository/local/local_source.dart';
import '../repository/remote/country_repo.dart';

/// provider with all home data
final homeProvider =
    ChangeNotifierProvider.autoDispose<HomeViewModel>((ref) => HomeViewModel());

/// future provider for countries
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final homeClient = ref.read(homeProvider);
  return  await homeClient.countries;
});



/// Responsible to store the state of the UI
class HomeViewModel extends ChangeNotifier {
  final CountryRemoteRepo _remoteRepo = CountryRemoteRepo();
  final CountryLocalRepo _localRepo = CountryLocalRepo();
  TextEditingController searchController = TextEditingController();

  List<Country> countriesList;
  List<Country> filtered;
  Box get favBox => _localRepo.favBox;
  Box get visitedBox => _localRepo.visitedBox;

  Future<List<Country>> get countries async =>
      filtered = countriesList = await _remoteRepo.getCountries();

  Future<List<Country>> filteredCountries(String query) async {
    if (query.isNotEmpty) {
      countriesList = filtered
          .where((element) => element.name.contains(query.capitalize()))
          .toList();
      notifyListeners();
      return countriesList;
    }
    notifyListeners();
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
