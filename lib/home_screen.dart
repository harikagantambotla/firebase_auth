import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'user_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _response = '';
  String _activity = '';

  Future<void> _sendMessage() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;


    try {
      final response = await http.post(
        Uri.parse('https://santosh-ai-path-api.onrender.com/path-recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      );

      setState(() {
        _response = 'Response: ${response.body}';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> _loadUserActivity() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = await _firestore.collection('user_activity').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _activity = 'Logins: ${data['loginCount']}, Logouts: ${data['logoutCount']}';
      });
    }
  }

  Future<void> _logout() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final docRef = _firestore.collection('user_activity').doc(uid);
      await _firestore.runTransaction((txn) async {
        final doc = await txn.get(docRef);
        if (doc.exists) {
          final current = doc['logoutCount'] ?? 0;
          txn.update(docRef, {'logoutCount': current + 1});
        }
      });
    }
    await _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (user != null) Text('Logged in as: ${user.email}'),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Ask something...'),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),
            const SizedBox(height: 10),
            Text(_response),
            const Divider(),
            ElevatedButton(
              onPressed: _loadUserActivity,
              child: const Text('View My Login/Logout Count'),
            ),
            if (_activity.isNotEmpty) Text(_activity),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (_) => SearchUserScreen()),
                );
              },
              child: const Text("Search Users"),
            ),
          ],
        ),
      ),
    );
  }
}
