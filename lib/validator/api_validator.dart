// httpsでの通信を強制する

class ApiValidator {
  static const String _httpPattern = r'^http://';
  static const String _httpsPattern = r'^https://';

  // URLがhttpで始まっているかどうかを判定する
  static bool isHttpUrl({required String url}) {
    return RegExp(_httpPattern).hasMatch(url);
  }

  // URLがhttpsで始まっているかどうかを判定する
  static bool isHttpsUrl({required String url}) {
    return RegExp(_httpsPattern).hasMatch(url);
  }

  // URLがhttpsで始まっているかどうかを判定し、そうでない場合はhttpsで始まるURLに変換する
  static String convertToHttpsUrl({required String url}) {
    if (isHttpsUrl(url: url)) {
      return url;
    } else if (isHttpUrl(url: url)) {
      return url.replaceFirst(RegExp(_httpPattern), 'https://');
    } else {
      return 'https://$url';
    }
  }
}
