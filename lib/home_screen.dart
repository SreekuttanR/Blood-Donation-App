import 'package:fbproject/add_donor.dart';
//import 'package:fbproject/update_donor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');
  void delete(docId) {
    donor.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Blood Donation App'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddDonor()));
          },
          child: const Icon(Icons.add)),
      body: SafeArea(
        child: StreamBuilder(
            stream: donor.orderBy('name').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot donorsnap =
                          snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 9,
                                spreadRadius: 2,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                  child: Text(donorsnap['group']),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      donorsnap['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Text(donorsnap['phone'].toString())
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/update',
                                            arguments: {
                                              'name': donorsnap['name'],
                                              'phone':
                                                  donorsnap['phone'].toString(),
                                              'group': donorsnap['group'],
                                              'id': donorsnap.id,
                                            });
                                      },
                                      icon: const Icon(Icons.edit),
                                      iconSize: 30,
                                      color: Colors.blue,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        delete(donorsnap.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                      iconSize: 30,
                                      color: Colors.red,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              return Container();
            }),
      ),
    );
  }
}
