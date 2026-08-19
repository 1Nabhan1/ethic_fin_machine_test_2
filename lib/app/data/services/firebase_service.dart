import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionPath = 'tasks';

  Future<void> upsertTask(TaskModel task) async {
    // Convert to JSON and save to Firestore
    await _firestore.collection(collectionPath).doc(task.id).set(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Stream<List<TaskModel>> getTasksStream() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
    });
  }

  Future<List<TaskModel>> fetchAllTasks() async {
    final querySnapshot = await _firestore.collection(collectionPath).get();
    return querySnapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
  }
}
