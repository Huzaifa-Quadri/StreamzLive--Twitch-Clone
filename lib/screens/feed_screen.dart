import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/models/livestream.dart';
import 'package:streamzlive/resources/firestore_methods.dart';
import 'package:streamzlive/screens/broadcast_screen.dart';
import 'package:streamzlive/utils/utils.dart';
import 'package:streamzlive/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as time;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
        child: Column(
          children: [
            const Text(
              'Live Users',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Gap(height * 0.03),
            Expanded(
              child: StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collection('livestream')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return showSnackBar(
                        context, 'Error Loading Chat, Try Again');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loadingindicator();
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Live Streams at the moment',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Start a LiveStream',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        LiveStream post = LiveStream.fromMap(
                            snapshot.data.docs[index].data());
                        return InkWell(
                          onTap: () async {
                            await FirestoreMethods()
                                .updateViewCount(post.channelId, true);
                            if (context.mounted) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BroadcastScreen(
                                      channelId: post.channelId,
                                      isBroadcaster: false)));
                            }
                          },
                          child: Container(
                            color: Colors.lightBlue,
                            height: 95,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                      'https://cdn.pixabay.com/photo/2023/02/03/04/50/colorful-7764125_1280.jpg'),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        post.username,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        post.title,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${post.viewers} watching ',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Started ${time.format(post.startedAt.toDate())}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
