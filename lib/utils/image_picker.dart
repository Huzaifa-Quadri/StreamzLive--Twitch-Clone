import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagepicker = ImagePicker();

  XFile? imgfile = await imagepicker.pickImage(source: source);

  if (imgfile == null) {
    print('IMAGE NOT SELECTED');
    return null;
  }

  return await imgfile.readAsBytes();
  //! Using Uint8List method because going with normal -
  //? File(imgfile.path) as it is not compatible on web
  //** With current version; image picker is also availabe for mac
}
