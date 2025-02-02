import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/models/livestream.dart';
import 'package:streamzlive/provider/userprovider.dart';
import 'package:streamzlive/utils/utils.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> startLiverstream(
      String title, Uint8List? image, BuildContext context) async {
    String channelId = '';
    try {
      final user = Provider.of<UserProvider>(context, listen: false);

      print('Stream About to Start !');
      if (!((await _firestore
              .collection('livestream')
              .doc(channelId = '${user.user.userId}_${user.user.username}')
              .get())
          .exists)) {
        //todo : Implement Thumbnail Image Storage
        // String thumnailUrl = await _storageMethod. (...)
        String thumnailUrl =
            "${DateTime.now().toString()}-Image-not-Uploaded-Yet";

        // print('\n\n\n Thumbanil Url : $thumnailUrl \n\n\n');

        channelId = channelId = '${user.user.userId}_${user.user.username}';

        LiveStream liveStream = LiveStream(
          title: title,
          image: thumnailUrl,
          userId: user.user.userId,
          username: user.user.username,
          viewers: 0,
          channelId: channelId,
          startedAt: DateTime.now(),
        );

        _firestore
            .collection('livestream')
            .doc(channelId)
            .set(liveStream.toMap());
      } else {
        if (context.mounted) {
          showSnackBar(context, 'Cannot Start two LiveStrems');
          channelId = '';
        }
      }
    } on FirebaseException catch (er) {
      print('Firebase Error : ${er.message}');
    } catch (er2) {
      print('Some Other Error Occured : ${er2.toString()}');
    }
    return channelId;
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    // print('\n\n Updating all View Count .......');
    try {
      await _firestore
          .collection('livestream')
          .doc(id)
          .update({'viewers': FieldValue.increment(isIncrease ? 1 : -1)});
    } catch (e) {
      debugPrint(e.toString());
    }
    // print('updated  !   ! ! !');
  }

  Future<void> endLiveStream(String channelId) async {
    // print('\n\nLive Stream Ending .......');
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc(channelId)
            .collection('comments')
            .doc((snap.docs[i].data() as dynamic)['commentId'])
            .delete();
      }
      await _firestore.collection('livestream').doc(channelId).delete();
      // print('\n\nEnded and deleted all the comments');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
