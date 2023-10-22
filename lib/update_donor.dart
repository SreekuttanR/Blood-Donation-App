import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateDonor extends StatefulWidget {
  const UpdateDonor({super.key});

  @override
  State<UpdateDonor> createState() => _UpdateDonorState();
}

class _UpdateDonorState extends State<UpdateDonor> {
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  String? selectedGroup;

  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  void updatDonor(docId) {
    final data = {
      'name': namecontroller.text,
      'phone': phonecontroller.text,
      'group': selectedGroup,
    };
    donor.doc(docId).update(data);
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    namecontroller.text = arg['name'];
    phonecontroller.text = arg['phone'];
    selectedGroup = arg['group'];
    final docId = arg['id'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Donor'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Name')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: phonecontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Phone Number'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: DropdownButtonFormField(
                  value: selectedGroup,
                  decoration:
                      const InputDecoration(label: Text('Select Bloodgroup')),
                  items: bloodGroups
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectedGroup = val as String;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    updatDonor(docId);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(
                        double.infinity,
                        40,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 10),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
