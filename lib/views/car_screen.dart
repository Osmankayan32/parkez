import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarScreen extends StatefulWidget {
  const CarScreen({Key? key}) : super(key: key);

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  final _textController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<String> cars = [];

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  void _fetchCars() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docRef =      _firestore.collection('users').doc(user.uid);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        cars = (data['cars'] as List<dynamic>).cast<String>();
        setState(() {});
      }
    }
  }

  void _addCar() async {
    final user = _auth.currentUser;
    if (user != null) {
      final carName = _textController.text.trim();
      if (carName.isNotEmpty) {
        cars.add(carName);
        _textController.clear();
        await _firestore.collection('users').doc(user.uid).update({
          'cars': cars,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araçlar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cars[index]),
                );
              },
            ),
          ),
          TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Araç ekle',
            ),
          ),
          ElevatedButton(
            onPressed: _addCar,
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
