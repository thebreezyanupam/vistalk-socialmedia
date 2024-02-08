import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts =
  FirebaseFirestore.instance.collection('Posts');

  // fetch user details
  Future<Map<String, dynamic>?> getUserDetails() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection("Users").doc(user!.email).get();
    return snapshot.data();
  }

  // post a message
  Future<void> addPost(String message) async {
    Map<String, dynamic>? userData = await getUserDetails();

    if (userData != null) {
      String username = userData['username'] ?? 'DefaultUsername';

      await posts.add({
        'UserEmail': user!.email,
        'UserName': username,
        'PostMessage': message,
        'TimeStamp': Timestamp.now(),
        'Likes':[],
      });
    }
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
