import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:goodedunote/edu/view/lecture_apply_screen.dart';
import 'package:goodedunote/edu/view/lecture_search_screen.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/splash_screen.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/user/view/student/student_join_screen.dart';
import 'package:goodedunote/user/view/student/student_root.dart';
import 'package:goodedunote/user/view/teacher/teacher_join_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_aaply_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_create_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_list_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_linked_students_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_root.dart';
import 'package:goodedunote/user/view/user_login_screen.dart';

final auth_status_provider = ChangeNotifierProvider<AuthStatusProvider>((ref) {
  return AuthStatusProvider(ref: ref);
});

class AuthStatusProvider extends ChangeNotifier {
  final Ref ref;

  AuthStatusProvider({
    required this.ref,
  }) {
    ref.listen<UserBaseModel?>(userProvider, (prev, next) {
      if (prev != next) {
        notifyListeners();
      }
    });
  }

  // 라우터 등록

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          pageBuilder: (_, __) => buildPageWithTransition(
              const SplashScreen(), SplashScreen.routeName),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          pageBuilder: (_, __) => buildPageWithTransition(
            LoginScreen(),
            LoginScreen.routeName,
          ),
          routes: [
            GoRoute(
              path: '/studentJoin',
              name: StudentJoinScreen.routeName,
              pageBuilder: (_, __) => buildPageWithTransition(
                StudentJoinScreen(),
                StudentJoinScreen.routeName,
              ),
            ),
            GoRoute(
              path: '/teacherJoin',
              name: TeacherJoinScreen.routeName,
              pageBuilder: (_, __) => buildPageWithTransition(
                TeacherJoinScreen(),
                TeacherJoinScreen.routeName,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/student',
          name: StudentRootScreen.routeName,
          pageBuilder: (_, __) => buildPageWithTransition(
            StudentRootScreen(),
            StudentRootScreen.routeName,
          ),
          routes: [
            GoRoute(
              path: '/lectureList',
              name: LectureSearchScreen.routeName,
              pageBuilder: (_, state) {
                final teacher = state.extra as TeacherModel;
                return buildPageWithTransition(
                  LectureSearchScreen(teacher: teacher),
                  LectureSearchScreen.routeName,
                );
              },
            ),
            GoRoute(
              path: '/lectureApply',
              name: LectureApplyScreen.routeName,
              pageBuilder: (_, __) {
                final lecture = __.extra as LectureModel;
                return CustomTransitionPage(
                  child: LectureApplyScreen(lecture: lecture),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              },

              // {
              //   final lecture = state.extra as LectureModel;
              //   return LectureApplyScreen(lecture: lecture,);
              // },
            ),
          ],
        ),
        GoRoute(
          path: '/teacher',
          name: TeacherRootScreen.routeName,
          pageBuilder: (_, __) => buildPageWithTransition(
            TeacherRootScreen(),
            TeacherRootScreen.routeName,
          ),
          routes: [
            GoRoute(
              path: '/linkedStudentList',
              name: TeacherLinkedStudentScreen.routeName,
              pageBuilder: (_, __) => buildPageWithTransition(
                TeacherLinkedStudentScreen(),
                TeacherLinkedStudentScreen.routeName,
              ),
            ),
            GoRoute(
              path: '/createLecture',
              name: TeacherLectureCreateScreen.routeName,
              pageBuilder: (_, __) => buildPageWithTransition(
                TeacherLectureCreateScreen(),
                TeacherLectureCreateScreen.routeName,
              ),
            ),
            GoRoute(
              path: '/MyLectureList',
              name: TeacherLectureListScreen.routeName,
              pageBuilder: (_, __) => buildPageWithTransition(
                TeacherLectureListScreen(),
                TeacherLectureListScreen.routeName,
              ),
            ),
            GoRoute(
              path: '/teacherLectureApplyList',
              name: TeacherLectureApplyScreen.routeName,
              pageBuilder: (_, __) {
                final lecture = __.extra as LectureModel;
                return CustomTransitionPage(
                  child: TeacherLectureApplyScreen(lectureModel: lecture),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ];

  // 앱을 시작했을 때 토큰 확인하고 경로 설정
  String? redirectLogic(GoRouterState state) {
    final UserBaseModel? user = ref.read(userProvider);

    final logIn = state.path == '/login';
    final location = state.fullPath;

    print('full path : $location');

    if (user == null) {
      print('[authStatusProvider] >> user null > 로그인 페이지로 이동');
      return logIn ? null : '/login';
    } else if (user is UserLoadingModel) {
      print('[authStatusProvider] >> user null > 로딩 중 ');
    } else {
      if (location == '/login' || location == '/splash') {
        if (user is StudentModel) {
          print('[authStatusProvider] >> user null > 학생 메인으로 이동');
          print('[authStatusProvider] >> user null > location : $location');
          return '/student';
        } else if (user is TeacherModel) {
          print('[authStatusProvider] >> user null > 선생 메인으로 이동');
          print('[authStatusProvider] >> user null > location : $location');
          return '/teacher';
        }
      } else {
        location;
      }
    }

    return null;
  }

  CustomTransitionPage buildPageWithTransition(Widget child, String key) {
    return CustomTransitionPage(
        key: ValueKey(key),
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(animation),
              child: child);
        });
  }
}
