// GANTI IP dengan IP laptop lo di jaringan yang sama
// Cek dengan: ipconfig (Windows) atau ifconfig (Mac/Linux)

class ApiConstants {
  // Jika pakai emulator Android → 10.0.2.2
  // Jika pakai device fisik   → IP WiFi laptop, contoh: 192.168.1.5
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Auth endpoints (sesuai backend Golang lo)
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';
  static const String search = '/search';
  static const String featured = '/products/featured';
  static const String flashSale = '/products/flash-sale';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
