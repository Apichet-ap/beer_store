import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
void main() => runApp(BeerStoreApp());

class BeerStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer Store Login',
      theme: ThemeData(
        textTheme: GoogleFonts.patrickHandTextTheme(),scaffoldBackgroundColor: Color(8)
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Logic for login can be implemented here
    print('Email: $email, Password: $password');

    // Navigate to the main beer list page after login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BeerListPage()), // Update this to your main page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Beer Store'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// Beer List Page (add this class in the same file or import from another file)


class BeerListPage extends StatefulWidget {
  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  List<Map<String, dynamic>> beers = [];

  @override
  void initState() {
    super.initState();
    loadBeerData();
  }

  Future<void> loadBeerData() async {
    final String response = await rootBundle.loadString('assets/beers.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      beers = data.map((beer) => beer as Map<String, dynamic>).toList();
    });
  }

  bool isNetworkImage(String imageUrl) {
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beer Store in Thailand'),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: beers.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: isNetworkImage(beers[index]['image'])
                  ? Image.network(beers[index]['image'], width: 50)
                  : Image.asset(beers[index]['image'], width: 50),
              title: Text(beers[index]['name']),
              subtitle: Text(beers[index]['price']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeerDetailPage(
                      name: beers[index]['name'],
                      description: beers[index]['description'],
                      price: beers[index]['price'],
                      image: beers[index]['image'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class BeerDetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String image;

  BeerDetailPage({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isNetworkImage(image)
                ? Image.network(image, width: 150)
                : Image.asset(image, width: 150),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Price: $price', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }

  bool isNetworkImage(String imageUrl) {
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }
}