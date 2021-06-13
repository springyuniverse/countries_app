import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/helpers/text_styles.dart';
import '../helpers/list_type.dart';

class CountryCard extends StatelessWidget {
  final _country;
  final _homeViewModel;
  final CountriesListType _type;
  final dateFormat = DateFormat('d-MM-yyyy');

  // ignore: public_member_api_docs
  CountryCard(this._country, this._homeViewModel, this._type);

  @override
  Widget build(BuildContext context) => Container(
        height: 150,
        child: Card(
          color: Colors.grey[100],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: ListTile(
            title: Row(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 20, color: Colors.grey, spreadRadius: 5)
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'icons/flags/png/${_country.code.toLowerCase()}.png',
                          package: 'country_icons'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        width: 230,
                        child: Text(
                          _country.code,
                          style: TextStyles.cardHeader,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Container(
                        width: 230,
                        child: Text(
                          _type == CountriesListType.Visited
                              ? _country.visitedTime != null
                                  ? "Currency: ${_country.currency}"
                                      "\nVisited on: ${dateFormat.format(_country.visitedTime)}"
                                  : ""
                              : "Currency: ${_country.currency} \n"
                                  "Number of states:"
                                  " ${_country.states.length}",
                          style: TextStyles.cardContent,
                        )),
                  ],
                ),
                Align(
                  child: GestureDetector(
                    onTap: _type == CountriesListType.All
                        ? () {
                            _homeViewModel.handleFav(_country.code, _country);
                          }
                        : null,
                    child: Icon(
                      _homeViewModel.checkIfFav(_country)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.red,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                )
              ],
            ),
          ),
        ),
      );
}
