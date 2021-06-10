import '../../../shared/utils/graph_client.dart';
import '../../../shared/utils/graph_queries.dart';
import '../../models/country.dart';

///home repo handles communication with Local as well as remote database
class CountryRemoteRepo extends GraphClient<Country> {

  /// function to perform the query against the remote database
  Future<List<Country>> getCountries() async {
    try {
      final result = await getData(GqlQuery.countryQuery, "countries");
      if (result == null) {
        return [];
      }
      return result;
    } on Exception catch (exception) {
      print(exception);
      throw null;
    }
  }

}