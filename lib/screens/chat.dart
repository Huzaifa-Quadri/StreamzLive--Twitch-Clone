import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/provider/userprovider.dart';
import 'package:streamzlive/resources/firestore_methods.dart';
import 'package:streamzlive/utils/utils.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';
import 'package:streamzlive/widgets/loading_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String channelId;
  const ChatScreen({super.key, required this.channelId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatcontroller = TextEditingController();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  @override
  void dispose() {
    super.dispose();
    _chatcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return showSnackBar(context, 'Error Loading Chat, Try Again');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loadingindicator();
                }

                if (!snapshot.hasData) {
                  return const Text('Start Chat');
                }

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data.docs[index]['username'],
                      style: TextStyle(
                        color: snapshot.data.docs[index]['uid'] ==
                                userProvider.user.userId
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(snapshot.data.docs[index]['message']),
                  ),
                );
              },
            ),
          ),
          CustomTextField(
            textcontroller: _chatcontroller,
            onTap: (val) async {
              await _firestoreMethods.chat(
                  _chatcontroller.text, widget.channelId, context);
              setState(() {
                _chatcontroller.text = '';
              });
            },
          )
        ],
      ),
    );
  }
}
