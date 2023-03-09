import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetNotes extends StatelessWidget {
  // final String documentId;
  final user = FirebaseAuth.instance.currentUser!;

  // ignore: empty_constructor_bodies
  GetNotes() {
    print("start");
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference notes = FirebaseFirestore.instance.collection("notes");
    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the documentId specified of the notes
      future: notes.doc(user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Error Handling conditions
        if (snapshot.hasError) {
          print("snr");
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          print("does not exist");
          return Text("Document does not exist");
        }

        // Data is output to the user
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          print(data);
          return Text(
            "Full Name: ${data} ${data['last_name']}",
            style: TextStyle(color: Colors.white),
          );
        }

        print("loading");
        return Text(
          "loading",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
