import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goodedunote/common/component/custom_elevated_button.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/popupFunc.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageSelectPopup extends ConsumerStatefulWidget {
  final Function? onImageUploadComplete;
  final String? networkImgUrl;
  final String? cashImgUrl;

  const ImageSelectPopup({
    this.onImageUploadComplete,
    this.networkImgUrl,
    this.cashImgUrl,
    super.key,
  });

  @override
  ConsumerState<ImageSelectPopup> createState() => _ImageSelectPopupState();
}

class _ImageSelectPopupState extends ConsumerState<ImageSelectPopup> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile as XFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider.notifier);
    UserModel user = ref.watch(userProvider) as UserModel;

    return AlertDialog(
      title: const Center(
        child: Text(
          '프로필 변경',
          style: TextStyle(
            fontSize: CONST_TEXT_20,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: CONST_SIZE_16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _renderImgCircle(),
            const SizedBox(height: CONST_SIZE_20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    _pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _image = null;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_camera_back),
                  onPressed: () async {
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // 팝업 버튼 액션
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(
              text: '변경 완료',
              onPressed: () async {
                if (_image != null) {
                  File file = File(_image!.path);
                  final uploadResult= await state.uploadProfileImg(user,file);

                  if(uploadResult.responseCode!=CONST_SUCCESS_CODE){
                    showAlertPopUp(context: context, title: '프로필 업로드 실패', content: uploadResult.responseMsg);
                  } else {

                    if(widget.onImageUploadComplete != null){
                     widget.onImageUploadComplete!.call();
                   }

                    showAlertPopUp(context: context, title: '변경완료', onPressed:(){
                      Navigator.of(context).pop();
                    });

                  }

                }
              },
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: '닫기',
            ),
          ],
        ),
      ],
    );
  }

  CircleAvatar _renderImgCircle(){
    print('selected Img : $_image');
    print('cash Img : ${widget.cashImgUrl}');
    print('info Img : ${widget.networkImgUrl}');
    if(_image!= null){
      return CircleAvatar(
        radius: 80.0,
        backgroundImage:
        Image.file(File(_image!.path)).image,
      );
    } else if(widget.cashImgUrl!= null){
      print('cash!');
      return CircleAvatar(
        radius: 80.0,
        backgroundImage: FileImage(
            File(widget.cashImgUrl!)),
      );
    } else if(widget.networkImgUrl!= null){
      print('network!');
      return CircleAvatar(
        radius: 80.0,
        backgroundImage: NetworkImage(
          widget.networkImgUrl!,
        ),
      );
    } else {
      return const CircleAvatar(
          radius: 40.0,
          backgroundImage: AssetImage('assets/images/no-profile-picture-icon.png')
      );
    }
  }
}
