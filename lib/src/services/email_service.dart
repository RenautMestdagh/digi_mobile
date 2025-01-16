import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String apiEndpoint = "https://your-api-url.com/fetch-email-code";

  // Function to fetch the verification code from the email
  Future<String?> fetchVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['verificationCode']; // Assuming API returns the code in this key
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
