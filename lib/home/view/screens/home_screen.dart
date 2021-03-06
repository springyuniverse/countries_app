import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../shared/ui/helpers/text_styles.dart';
import '../../view_model/home.dart';
import '../components/country_card.dart';
import '../helpers/list_type.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  TabController tabController;
  TextEditingController searchController;
  var _homeViewModel;
  @override
  void initState() {
    super.initState();
    initControllers();
    _homeViewModel = context.read(homeProvider);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    searchController.dispose();
  }

  void initControllers() {
    tabController = TabController(length: 3, vsync: this);
    searchController = TextEditingController();
    addListener();
  }

  void addListener() {
    searchController.addListener(() {
      _homeViewModel.filteredCountries(searchController.text);
    });
    tabController.addListener(() {
      _homeViewModel.refreshList(tabController.index);
      if (tabController.index == 0) {
        //reset search textField
        searchController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "World Countries",
              style: TextStyles.baseText.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.bookmark)),
                Tab(icon: Icon(Icons.flight)),
              ],
            ),
          ),
          body: Consumer(
            builder: (context, watch, child) {
              final responseValue = watch(countriesProvider);
              final homeViewModel = watch(homeProvider);


              return responseValue.map(
                data: (snap) => _tabBarView(
                    homeViewModel.countriesList, homeViewModel, context),
                loading: (_) =>
                    LoadingOverlay(isLoading: true, child: Container()),
                error: (message) => Text(message.error),
              );
            },
          ),
        ),
      );

  Widget _tabBarView(List snap, homeViewModel, BuildContext context) =>
      TabBarView(
        controller: tabController,
        children: [
          _countriesList(snap, context, CountriesListType.All),
          _countriesList(snap, context, CountriesListType.Favourite),
          _countriesList(snap, context, CountriesListType.Visited),
        ],
      );

  Widget _countriesList(
          List snap, BuildContext context, CountriesListType type) =>
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          type == CountriesListType.All
              ? Container(
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.red,
                      ),
                      hintText: "Search",
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    controller: searchController,
                    onChanged: (t) {},
                  ),
                )
              : Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      type == CountriesListType.Favourite
                          ? "Favourite Countries"
                          : "${snap.length} Visited Countries ",
                      style: TextStyles.title,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  var country = snap[index];
                  return GestureDetector(
                      onLongPress: type == CountriesListType.All
                          ? () {
                              showAlertDialog(context, country, _homeViewModel);
                            }
                          : null,
                      child: CountryCard(country, _homeViewModel, type));
                }),
          ),
        ],
      ));

//Methods
  showAlertDialog(BuildContext context, country, homeViewModel) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        _selectDate(context, country, homeViewModel);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    var alert = AlertDialog(
      title: Text("Add new visited country"),
      content: Text("Horay! Let's add ${country.name}"
          " to your visited countries"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  _selectDate(BuildContext context, country, homeViewModel) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    bool isVisited = homeViewModel.checkIfVisited(country);
    if (picked != null && picked != selectedDate && !isVisited) {
      setState(() {
        var newCountry = country.copyWith();
        newCountry.visitedTime = picked;

        selectedDate = null;
        homeViewModel.handleVisited(country.code, newCountry);
        selectedDate = picked;

        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Good job, you have added ${country.name} to"
                " your visited countries",
          ),
        );
      });
    } else if (isVisited) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Hmmm, it seems you already have  ${country.name} in"
              " your visited countries",
        ),
      );
    }
  }
}
