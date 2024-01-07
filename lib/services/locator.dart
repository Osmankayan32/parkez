import 'package:get_it/get_it.dart';
import 'package:login_screen/services/auth_service.dart';
import 'package:login_screen/services/firestore_services.dart';

final getIt = GetIt.instance;

void setupLocator() {

  getIt.registerSingleton<FireStoreServices>(FireStoreServices());
  getIt.registerSingleton<AuthService>(AuthService());
}