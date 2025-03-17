import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/provider/router_provider.dart';
import 'package:goodedunote/firebase_options.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // 카카오 연동
  KakaoSdk.init(
    nativeAppKey: '258a72256265c3d88645562d72f20440',
  );
  
  // firebase 연동
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   // appleProvider: AppleProvider.appAttest,
  // );

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      locale: const Locale('ko', 'KR'), // 한국어 로케일 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어 지원
      ],
      routerConfig : router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: CONST_TEXT_FONT,
      ),
    );

  }

}
