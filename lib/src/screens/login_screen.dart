import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/progress_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    _performLogin();
  }

  void _performLogin() async {
    await AuthService.fetchCsrfToken();
    await AuthService.login(email, password);
    await AuthService.sendCode();
    code = (await _showCodeDialog())!;
    await AuthService.finalizeLogin(code);
    await AuthService.signout();
  }


  Future<String?> _showCodeDialog() async {
    TextEditingController controller = TextEditingController();
    String userCode = '';

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the code sent to your email:'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter code'),
            keyboardType: TextInputType.number,
            autofocus: true, // Focuses the input field immediately
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                userCode = controller.text.trim(); // Get the entered code
                Navigator.of(context).pop(userCode); // Close the dialog and return the code
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digi Login')),
      body: Center(
        child: ProgressIndicatorWidget(), // A custom widget for showing a progress indicator
      ),
    );
  }
}
