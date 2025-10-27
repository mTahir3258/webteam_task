import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getNotes() {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {'id': doc.id, ...doc.data()};
            }).toList());
  }

  Future<void> addNote(String title, String content) async {
    await _firestore.collection('notes').add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': _userId,
    });
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _firestore.collection('notes').doc(id).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
