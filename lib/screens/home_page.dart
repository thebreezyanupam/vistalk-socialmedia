import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../components/my_drawer.dart';
import '../components/my_like_btn.dart';
import '../components/my_post_button.dart';
import '../components/my_textfield.dart';
import '../database/firestore.dart';
import '../themes/dark_mode.dart';
import '../themes/light_mode.dart';
import '../themes/theme_provider.dart';

class MyHomepage extends StatefulWidget {
  final String postId;
  final List<String> likes;

  const MyHomepage({Key? key, required this.postId, required this.likes});


  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
  }


  String _formatDate(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just Now';
    } else {
      return timeago.format(dateTime, locale: 'en');
    }
  }

  final FirestoreDatabase dataBase = FirestoreDatabase();
  final TextEditingController userPostController = TextEditingController();

  void postMessage() {
    if (userPostController.text.isNotEmpty) {
      String message = userPostController.text;
      dataBase.addPost(message);
    }
    userPostController.clear();
  }

  // void deletePost(String postId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Delete Post"),
  //       content: const Text("Are you sure you want to delete this post?"),
  //       actions: [
  //         // Cancel Button
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             // Delete the comments from Firebase first
  //             final commentDocs = await FirebaseFirestore.instance
  //                 .collection("User Posts")
  //                 .doc(postId)
  //                 .collection("Comments")
  //                 .get();
  //
  //             for (var doc in commentDocs.docs) {
  //               await FirebaseFirestore.instance
  //                   .collection("User Posts")
  //                   .doc(postId)
  //                   .collection("Comments")
  //                   .doc(doc.id)
  //                   .delete();
  //             }
  //
  //             // Then delete the post
  //             FirebaseFirestore.instance
  //                 .collection("User Posts")
  //                 .doc(postId)
  //                 .delete()
  //                 .then((value) => print("Post deleted"))
  //                 .catchError((error) => print("Failed to delete post: $error"));
  //
  //             // Dismiss the dialog box
  //             Navigator.pop(context);
  //           },
  //           child: const Text("Delete"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? currentUser = _auth.currentUser;

    final isLight = Provider.of<ThemeProvider>(context).themeData == lightMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VISTALK FEED',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  isLight ? Icons.dark_mode : Icons.light_mode,
                ),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            // Text field for the user to type
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: "What are you feeling?",
                    obscureText: false,
                    controller: userPostController,
                  ),
                ),
                CustomPostButton(onTap: postMessage),
              ],
            ),
            const SizedBox(height: 20,),
            // Posts
            StreamBuilder(
              stream: dataBase.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final posts = snapshot.data!.docs;

                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No posts... Post something!"),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];
                      String userName = post['UserName'];
                      String postId = post.id; // Use the document ID as postId

                      Timestamp timestamp = post['TimeStamp'];
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate = _formatDate(dateTime);

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  message,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    MyLikeButton(
                                      isLiked: true,
                                      onTap: (){},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      );
                    },
                  ),

                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
