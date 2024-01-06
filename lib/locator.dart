import 'package:get_it/get_it.dart';
import 'package:login_screen/services/auth_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<AuthService>(AuthService());
}