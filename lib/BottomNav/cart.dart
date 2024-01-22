import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users-cart-items')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something is wrong"),
              );
            }

            return ListView.builder(
                itemCount:
                snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index ) {
                  DocumentSnapshot _documentSnapshot =
                  snapshot.data!.docs[index];

                  return Column(
                    children: [
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Text(_documentSnapshot['name']),
                          title: Text(
                            "Tk ${_documentSnapshot['price']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          trailing: GestureDetector(
                            child: CircleAvatar(
                              child: Icon(Icons.remove_circle),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('users-cart-items')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("items")
                                  .doc(_documentSnapshot.id)
                                  .delete();
                            },
                          ),
                        ),
                      ),

                    ],
                  );
                }
            );
          },
        ),
      ),
    );
  }
}
