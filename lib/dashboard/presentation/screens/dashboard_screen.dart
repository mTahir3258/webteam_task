import 'package:coding_test/task/presentation/task_tab.dart';
import 'package:coding_test/login/presentation/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../notes/presentation/notes_tab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${user?.email ?? 'User'} 👋'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.note_alt), text: 'Notes'),
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Tasks'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            NotesTab(),
            TasksTab(),
          ],
        ),
      ),
    );
  }
}
