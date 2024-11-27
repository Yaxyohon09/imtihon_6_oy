import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(
      home: imtihon_6_oy(),
    ),
  );
}

class imtihon_6_oy extends StatefulWidget {
  const imtihon_6_oy({super.key});

  @override
  State<imtihon_6_oy> createState() => _imtihon_6_oyState();
}

class _imtihon_6_oyState extends State<imtihon_6_oy> {
  @override
  void initState() {
    super.initState();
    _checkSavedData();
  }

  Future<void> _checkSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLogin = prefs.getString('login');
    String? savedPassword = prefs.getString('password');

    Future.delayed(
      Duration(seconds: 5),
      () {
        if (savedLogin != null && savedPassword != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Sahifa1()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => sahifa()),
          );
        }
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //       Duration(
  //         seconds: 5,
  //       ), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => sahifa(),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
          ),
        ),
        child: Center(
          child: Lottie.network(
            'https://assets9.lottiefiles.com/packages/lf20_5ngs2ksb.json', // Dollar coins animation
            width: 400,
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class sahifa extends StatefulWidget {
  @override
  _sahifaState createState() => _sahifaState();
}

class _sahifaState extends State<sahifa> {
  final _formKey = GlobalKey<FormState>();
  String? _surname, _name, _login, _password;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Ro'yxatdan o'tish",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Lottie animation
            Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_5ngs2ksb.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      _buildTextField(
                        "Familiya",
                        (value) => _surname = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(
                        "Ism",
                        (value) => _name = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(
                        "Login",
                        (value) => _login = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildPasswordField(),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _saveAndNavigate,
                        child: Text(
                          "Saqlash",
                        ),
                        // style: ElevatedButton.styleFrom(primary: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? '$label kiritilishi shart' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Parol",
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Text(
            _isPasswordVisible ? "🙈" : "🐵",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Parol kiritilishi shart' : null,
      onSaved: (value) => _password = value,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _saveAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('surname', _surname!);
      prefs.setString('name', _name!);
      prefs.setString('login', _login!);
      prefs.setString('password', _password!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            savedLogin: _login!,
            savedPassword: _password!,
          ),
        ),
      );
    }
  }
}

class LoginScreen extends StatefulWidget {
  final String savedLogin;
  final String savedPassword;

  const LoginScreen({
    required this.savedLogin,
    required this.savedPassword,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredLogin, _enteredPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Kiriting",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildTextField("Login", (value) => _enteredLogin = value),
                  SizedBox(height: 10),
                  _buildTextField("Parol", (value) => _enteredPassword = value,
                      isPassword: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _validateLogin,
                    child: Text("Tasdiqlash"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? '$label kiritilishi shart' : null,
      onSaved: onSaved,
    );
  }

  void _validateLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_enteredLogin == widget.savedLogin &&
          _enteredPassword == widget.savedPassword) {
        print("Kirish muvaffaqiyatli!");
        // Proceed to the currency screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Sahifa1()), // Navigate to Currency Screen
        );
      } else {
        Navigator.pop(context); // Go back to the first screen
        print("Login yoki parol noto'g'ri!");
      }
    }
  }
}

class Sahifa1 extends StatefulWidget {
  @override
  _Sahifa1State createState() => _Sahifa1State();
}

class _Sahifa1State extends State<Sahifa1> {
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears saved login data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => imtihon_6_oy()),
    );
  }

  List<Map<String, dynamic>> data = [];

  late String _currentTime;
  Future<void> usa() async {
    final response = await http.get(
      Uri.parse(
        "https://cbu.uz/uz/arkhiv-kursov-valyut/json/",
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsondata = jsonDecode(
        response.body,
      );
      for (var item in jsondata) {
        data.add(
          Map<String, dynamic>.from(
            item,
          ),
        );
      }
      setState(() {});
    } else {
      throw Exception(
        "not file",
      );
    }
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });

    // Ensure it updates again every second.
    Future.delayed(
      Duration(seconds: 1),
      _updateTime,
    );
  }

  @override
  void initState() {
    super.initState();
    _currentTime = DateFormat('HH:mm:ss')
        .format(DateTime.now()); // Initialize current time
    _updateTime();
    usa(); // Start the time updating loop
  }

  double _convertedResult = 0.0;
  String _exchangeRate =
      "1.0"; // Example rate, this should be dynamic from the API

  // Function to calculate the conversion
  void _calculateConversion() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount > 0) {
      setState(() {
        // Example calculation, here you'd use the real exchange rate for conversions
        _convertedResult = amount / double.parse(_exchangeRate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "${_currentTime}",
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(
              15,
            ),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Container(
                      height: 400,
                      width: 400,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "${data[index]['CcyNm_UZ']} malumotlari",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Text(
                            "Qiymati: ${data[index]['Rate']}",
                          ),
                          Text(
                            "Valyuta: ${data[index]['Ccy']}",
                          ),
                          Text(
                            "Nomi: ${data[index]['CcyNm_EN']}",
                          ),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Summa (UZS)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'qiymati: ${_currencyController.text.isNotEmpty ? (double.tryParse(
                                    _currencyController.text,
                                  ) ?? 0.0) * double.parse(_exchangeRate) : 0.0} ${data[index]['Ccy']}',
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: _calculateConversion,
                              child: Text('Hisoblash'),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'So\'mga o\'tkazish tanlandi.')),
                                  );
                                },
                                child: Text('So\'mga o\'tkazish'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Yopish'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                height: 180,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${data[index]['Date']}",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${data[index]['Nominal']}",
                            ),
                            Text(
                              "${data[index]['Ccy']}",
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${data[index]['CcyNm_UZ']}(${data[index]['Code']})",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "${data[index]['Rate']}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${data[index]['Diff'] ?? '0'}", // Default to '0' if null
                          style: TextStyle(
                            color: (data[index]['Diff'] != null &&
                                    double.tryParse(data[index]['Diff']) !=
                                        null &&
                                    double.parse(data[index]['Diff']) < 0)
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 15,
                        bottom: 15,
                      ),
                      child: Container(
                        height: 3,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
