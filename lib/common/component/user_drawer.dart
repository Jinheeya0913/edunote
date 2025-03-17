import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/splash_screen.dart';
import 'package:goodedunote/user/component/user_profile_circle.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class UserDrawer extends ConsumerStatefulWidget {
  const UserDrawer({
    super.key,
  });

  @override
  ConsumerState<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends ConsumerState<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider.notifier);
    final user = ref.watch(userProvider);
    UserModel? model;
    if (user != null) {
      model = user as UserModel;
    }

    return Drawer(
      width: MediaQuery.of(context).size.width / 2,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              color: CONST_COLOR_MAIN,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const UserProfileCircle(),
                  Text(model != null ? model.userAlias : ''),
                  Text(model != null ? model.userEmail : ''),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈으로'),
            onTap: () {
              Navigator.pop(context);
              context.goNamed(SplashScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('메시지'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              final result = state.logout();
            },
          ),
        ],
      ),
    );
  }
}
