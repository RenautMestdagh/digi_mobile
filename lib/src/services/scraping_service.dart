import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import '../utils/cookie_utils.dart';

class ScrapingService {
  // This method scrapes the given URL and extracts and converts mobile usage data to KB
  static Future<Map<String, int>?> scrapeMobileUsageInKB(String url) async {
    try {
      // Get the session token from the cookies
      final sessionToken = getCookie('__Secure-authjs.session-token');

      // Send HTTP request with the session token in the cookie header
      final response = await http.get(
        Uri.parse(url),
        headers: {'Cookie': '__Secure-authjs.session-token=$sessionToken'},
      );

      if (response.statusCode == 200) {
        // Parse the HTML response
        var document = parse(response.body);

        // Look for the specific HTML structure containing the mobile data
        final mobileUsageElement = document.querySelector('.card-progress-title span');

        if (mobileUsageElement != null) {
          // Extract the text, which is in the format "873.00 MB / 15.00 GB"
          String usageText = mobileUsageElement.text.trim();

          // Split the text into the two parts
          List<String> parts = usageText.split(' / ');

          // Extract the current usage (in MB) and the limit (in GB)
          String currentUsageStr = parts.isNotEmpty ? parts[0].trim() : '0 MB'; // Default to '0 MB' if missing
          String dataLimitStr = parts.length > 1 ? parts[1].trim() : '15 GB'; // Default to '15 GB' if missing

          // Extract the numeric values and convert to KB
          int currentUsageKB = _convertToKB(currentUsageStr);
          int dataLimitKB = _convertToKB(dataLimitStr);

          // Return the values as a map
          return {
            'currentUsageKB': currentUsageKB,
            'dataLimitKB': dataLimitKB,
          };
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      // Handle errors, e.g., network issues
      print("Error during scraping: $e");
      return null;
    }
  }

  // Helper method to convert MB/GB to KB
  static int _convertToKB(String value) {
    double numericValue = double.parse(value.split(' ')[0]);
    if (value.contains('MB')) {
      return (numericValue * 1000).toInt(); // Convert MB to KB
    } else if (value.contains('GB')) {
      return (numericValue * 1000000).toInt(); // Convert GB to KB
    } else {
      throw FormatException("Unsupported unit in $value");
    }
  }

}
