import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streamzlive/resources/firestore_methods.dart';
import 'package:streamzlive/screens/broadcast_screen.dart';
import 'package:streamzlive/utils/colors.dart';
import 'package:streamzlive/utils/image_picker.dart';
import 'package:streamzlive/utils/utils.dart';
import 'package:streamzlive/widgets/customButton.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';

class GoLiveScreen extends StatefulWidget {
  static String routename = './golive';
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  Uint8List? _img;

  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  void startStream() async {
    String channelId = '';

    if (_titlecontroller.text != null && _img != null) {
      channelId = await _firestoreMethods.startLiverstream(
          _titlecontroller.text, _img, context);
    } else {
      if (context.mounted) {
        debugPrint(
            'Either of fileds not Entered :-\n Title -${_titlecontroller.text}, Image -$_img');
        showSnackBar(context, 'Enter all the fields !');
      }
    }

    if (channelId.isNotEmpty && mounted) {
      showSnackBar(context, 'Stream Started Succesfully');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              BroadcastScreen(channelId: channelId, isBroadcaster: true),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titlecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _img = null;
                      });
                    },
                    onTap: () async {
                      //** image pick from gallery
                      Uint8List pickedimage =
                          await pickImage(ImageSource.gallery);
                      if (pickedimage != null) {
                        setState(() {
                          _img = pickedimage;
                        });
                      }
                    },
                    child: _img != null
                        ? SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image.memory(_img!),
                          )
                        : DottedBorder(
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            color: buttonColor,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: buttonColor.withOpacity(0.05),
                              ),
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    color: buttonColor,
                                    size: 40,
                                  ),
                                  const Gap(10),
                                  Text(
                                    'Select Your Thumbnail',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomTextField(textcontroller: _titlecontroller),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomButton(
                text: 'Go Live',
                onTap: startStream,
              ),
            )
          ],
        ),
      ),
    );
  }
}
