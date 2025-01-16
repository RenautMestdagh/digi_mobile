import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String? _selectedVerificationMethod;
  bool _isLoading = false;
  bool _isPasswordVisible = false; // To toggle password visibility

  String? _emailErrorText;
  String? _passwordErrorText;
  bool _verificationError = false;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _performLogin() async {

    // Check if fields are empty and set error text
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailErrorText = 'Please enter your email.';
      });
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordErrorText = 'Please enter your password.';
      });
    }

    if (_selectedVerificationMethod == null) {
      setState(() {
        _verificationError = true;
      });
    }

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _selectedVerificationMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all fields.'),
          duration: Duration(milliseconds: 2500),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate login process
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // TODO: Add actual login logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login successful!')),
    );
  }

  void _selectVerificationMethod() {
    setState(() {
      _verificationError = false;
    });

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Verification Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.code, color: Color(0xFF007aff)),
                title: Text('Enter Code Manually'),
                subtitle: Text('Input the verification code sent to your email.'),
                trailing: GestureDetector(
                  onTap: () {
                    // Show the modal with additional information when the info icon is tapped
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Information'),
                          content: Text('Enter the confirmation code you\'ll receive in your inbox manually.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(padding: EdgeInsets.all(5), child: Icon(Icons.info_outline, color: Colors.grey)),
                ),
                onTap: () {
                  setState(() {
                    _selectedVerificationMethod = 'Manual Code Entry';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.forward_to_inbox, color: Color(0xFF007aff)),
                title: Text('Forward Email to App'),
                subtitle: Text('Forward the email to a mailbox the app can access.'),
                trailing: GestureDetector(
                  onTap: () {
                    // Show the modal with additional information when the info icon is tapped
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Information'),
                          content: Text('Enter the confirmation code you\'ll receive in your inbox manually.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(padding: EdgeInsets.all(5), child: Icon(Icons.info_outline, color: Colors.grey)),
                ),
                onTap: () {
                  setState(() {
                    _selectedVerificationMethod = 'Email Forwarding';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside the input fields
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _isPasswordVisible = false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 32),

                // Email Input
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  // Attach focus node
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: 'Email',
                    errorText: _emailErrorText,
                    // Dynamically set errorText
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red)),
                    // error color
                    prefixIcon: Icon(
                      Icons.email,
                      color: _emailErrorText != null ? Colors.red : Color(0xFF007aff), // Icon color follows the error state
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _emailErrorText = null; // Reset error when tapping
                    });
                  },
                ),

                SizedBox(height: 16),

                // Password Input
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  // Attach focus node
                  obscureText: !_isPasswordVisible,
                  // Toggle visibility based on _isPasswordVisible
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: 'Password',
                    errorText: _passwordErrorText,
                    // Dynamically set errorText
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // error color
                    prefixIcon: Icon(
                      Icons.lock,
                      color: _passwordErrorText != null ? Colors.red : Color(0xFF007aff), // Icon color follows the error state
                    ),
                    suffixIcon: _passwordFocusNode.hasFocus // Show eye icon only when field is focused
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                              });
                            },
                            child: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility, // Toggle eye icon
                              color: _passwordErrorText != null ? Colors.red : Color(0xff7a7a7a),
                            ),
                          )
                        : null, // No suffix icon if the TextField is not focused
                  ),
                  onTap: () {
                    setState(() {
                      _passwordErrorText = null; // Reset error when tapping
                    });
                  },
                ),

                SizedBox(height: 24),

                // Verification Selector
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _selectVerificationMethod,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _verificationError ? Colors.red : Colors.grey[300]!,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      _selectedVerificationMethod == null
                                          ? Icons.mail_lock
                                          : _selectedVerificationMethod == 'Manual Code Entry'
                                              ? Icons.code
                                              : Icons.forward_to_inbox,
                                      color: _verificationError ? Colors.red : Color(0xFF007aff),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _selectedVerificationMethod == null ? 'Verification method' : '$_selectedVerificationMethod',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: _verificationError
                                              ? Colors.red
                                              : _selectedVerificationMethod == null
                                                  ? Color.fromRGBO(107, 117, 117, 1.0)
                                                  : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Color(0xFF007aff), size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      _selectedVerificationMethod == null ? 'Select' : 'Change',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF007aff),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading ? Colors.grey : Color(0xFF007aff),
                      // Button color
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 16),

                // Forgot Password
                GestureDetector(
                  onTap: () {
                    // TODO:
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF007aff),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
