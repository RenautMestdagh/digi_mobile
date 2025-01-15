import 'package:intl/intl.dart';

final Map<String, dynamic> cookieStore = {};

void handleCookies(Map<String, List<String>> headers) {
  final setCookieHeaders = headers['set-cookie'];

  if (setCookieHeaders == null) return;

  for (var cookie in setCookieHeaders) {
    final cookieParts = RegExp(r'([^=\s]+)=([^;]*)').firstMatch(cookie);
    if (cookieParts == null) continue;

    final name = cookieParts.group(1);
    final value = cookieParts.group(2) ?? '';

    final expiresMatch = RegExp(r'Expires=([a-zA-Z,0-9:\s\-]+);').firstMatch(cookie);
    final maxAgeMatch = RegExp(r'\s*Max-Age\s*=\s*(\d+)').firstMatch(cookie);

    DateTime? expiration;

    if (maxAgeMatch != null) {
      // Convert Max-Age from seconds to a DateTime object
      expiration = DateTime.now().add(Duration(seconds: int.tryParse(maxAgeMatch.group(1)!)!));
    } else if (expiresMatch != null) {
      // Parse the Expires value into a DateTime object
      expiration = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US").parseUtc(expiresMatch.group(1)!);
    }


    if (expiration == null || expiration.isAfter(DateTime.now())) {
      cookieStore[name!] = {
        'value': Uri.decodeComponent(value),
        'expiration': expiration?.toIso8601String(),
      };
    } else {
      cookieStore.remove(name);
    }
  }
}

String? getCookie(String cookieName) {
  final cookie = cookieStore[cookieName];
  if (cookie == null) return null;

  final expiration = DateTime.tryParse(cookie['expiration'] ?? '');
  if (expiration != null && expiration.isBefore(DateTime.now())) {
    cookieStore.remove(cookieName);
    return null;
  }

  return cookie['value'];
}

String getAllCookies() {
  final now = DateTime.now();
  final validCookies = cookieStore.entries
      .where((entry) {
    final expiration = DateTime.tryParse(entry.value['expiration'] ?? '');
    return expiration == null || expiration.isAfter(now);
  })
      .map((entry) => '${entry.key}=${entry.value['value']}')
      .toList();

  return validCookies.join('; ');
}
