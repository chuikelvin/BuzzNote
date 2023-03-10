import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DeletedPage extends StatefulWidget {
  const DeletedPage({super.key});

  @override
  State<DeletedPage> createState() => _DeletedPageState();
}

class _DeletedPageState extends State<DeletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            String? content = snapshot.data?.photoURL;
            
            return Image.network(content as String);
          },
        ),
      ),
    );
  }
}
