import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/component/popup/image_select_popup.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/provider/image_provider.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';

class UserProfileCircle extends ConsumerStatefulWidget {
  const UserProfileCircle({super.key});

  @override
  ConsumerState<UserProfileCircle> createState() => _UserProfileCircle();
}

class _UserProfileCircle extends ConsumerState<UserProfileCircle> {

  String? _cashUrl;
   late UserModel _user;


   @override
  void initState() {
     _user = ref.read(userProvider) as UserModel;
     _getCashImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0)
                  .animate(animation),
              child: ImageSelectPopup(
                networkImgUrl: _user.userImgUrl,
                cashImgUrl: _cashUrl,
              ),
            );
          },
        );
      },
      child: _getProfileImg()
    );
  }

  Widget _getProfileImg() {
    if(_cashUrl!= null){
      print('cash > img!');
      return  CircleAvatar(
        radius: 40.0,
        backgroundImage: FileImage(
            File(_cashUrl!)),
      );
    } else if(_user.userImgUrl!= null){
      print('userInfo > img');
      return  CircleAvatar(
      radius: 40.0,
      backgroundImage: NetworkImage(
          "${_user.userImgUrl}"),
      );
    } else {
      return const CircleAvatar(
        radius: 40.0,
        backgroundImage: AssetImage('assets/images/no-profile-picture-icon.png')
      );
    }
  }

  Future<void> _getCashImage() async{
    final cashResult=await ref.read(imageProvider).getProfileImg(_user.userId);
    if(cashResult.responseCode == CONST_SUCCESS_CODE){
      setState(() {
        _cashUrl = cashResult.responseObj as String;
      });
    }
  }
}
