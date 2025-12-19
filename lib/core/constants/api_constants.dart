class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';
  static const String productByIdEndpoint = '/products';
  
  static String getProductById(int id) => '$productsEndpoint/$id';
}


