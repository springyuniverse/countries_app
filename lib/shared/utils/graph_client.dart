import 'package:graphql_flutter/graphql_flutter.dart';
import 'global.dart';

class GraphClient<T>{

  final GraphQLClient _client = GraphQLClient(link: HttpLink(
    'https://countries.trevorblades.com/',
  ), cache: GraphQLCache(store: HiveStore()));
  /// connect with graphQL and get the data
  Future<List<T>> getData(String query,String key) async {

    var result = await _client.query(QueryOptions(
        document: gql(query),
        fetchPolicy:  FetchPolicy.cacheAndNetwork
    ));


    return  result.data[key].map<T>((e) => models[T](e) as T).toList();
  }

}