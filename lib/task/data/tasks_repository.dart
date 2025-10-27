import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TasksRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getTasks() {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {'id': doc.id, ...doc.data()};
            }).toList());
  }

  Future<void> addTask(String title) async {
    await _firestore.collection('tasks').add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': _userId,
    });
  }

  Future<void> toggleTask(String id, bool isCompleted) async {
    await _firestore.collection('tasks').doc(id).update({'isCompleted': isCompleted});
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }
}
