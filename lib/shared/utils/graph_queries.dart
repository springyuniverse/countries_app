///Graph QL queries written here
mixin GqlQuery {
/// A query to get all countries
  static String countryQuery = '''
  query{
  countries{
    name
    states{
      name
    }
    code
    native
    currency
    phone
    
  }
  }
  ''';

}