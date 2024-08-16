import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiValidator {
  static const String defaultEnv = 'development';
  static const String httpsPrefix = 'https://';
  static const String httpPrefix = 'http://';

  static final String _env = dotenv.env['ENV'] ?? defaultEnv;
  static final String _apiBaseUrl = dotenv.env['API_BASE_URL'] ??
      (throw Exception(
          'API_BASE_URL is not defined in the environment variables.'));

  static final RegExp httpPattern = RegExp(r'^http://');
  static final RegExp httpsPattern = RegExp(r'^https://');

  static bool hasHttpScheme(String url) {
    return httpPattern.hasMatch(url);
  }

  static bool hasHttpsScheme(String url) {
    return httpsPattern.hasMatch(url);
  }

  static String convertToHttpsUrl(String url) {
    if (hasHttpsScheme(url)) {
      return url;
    } else if (hasHttpScheme(url)) {
      return url.replaceFirst(httpPattern, httpsPrefix);
    } else {
      return '$httpsPrefix$url';
    }
  }

  static String getApiBaseUrl() {
    return convertToHttpsUrl(_apiBaseUrl);
  }

  static bool isProduction() {
    return _env == 'production';
  }
}
