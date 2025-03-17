import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/common/provider/edu_note_route.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(auth_status_provider);
  return GoRouter(
    redirect: (_,state)=>provider.redirectLogic(state),
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    // debugLogDiagnostics: false,

  );
});