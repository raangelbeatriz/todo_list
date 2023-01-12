import 'package:provider/provider.dart';

import '../../core/modules/todo_list_module.dart';
import '../../core/routes/routes.dart';
import 'login/login_controller.dart';
import 'login/login_page.dart';
import 'register/register_controller.dart';
import 'register/register_page.dart';

class AuthModule extends TodoListModule {
  AuthModule()
      : super(bindings: [
          ChangeNotifierProvider(
            create: (context) => LoginController(
              userService: context.read(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => RegisterController(
              userService: context.read(),
            ),
          )
        ], routers: {
          Routes.login: (context) => const LoginPage(),
          Routes.register: (context) => const RegisterPage(),
        });
}
