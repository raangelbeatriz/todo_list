import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_widget.dart';
import 'core/auth/auth_provider.dart';
import 'core/database/sqlite_connection_factory.dart';
import 'repositories/tasks/tasks_repository.dart';
import 'repositories/tasks/tasks_repository_impl.dart';
import 'repositories/user/user_repository.dart';
import 'repositories/user/user_repository_impl.dart';
import 'services/user/user_service.dart';
import 'services/user/user_service_impl.dart';

class AppModule extends StatelessWidget {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => FirebaseAuth.instance,
        ),
        Provider(
          create: (_) => SqliteConnectionFactory(),
          lazy: false,
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(
            firebaseAuth: context.read(),
          ),
        ),
        Provider<TasksRepository>(
          create: (context) =>
              TasksRepositoryImpl(sqliteConnectionFactory: context.read()),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(
              userRepository: context.read(), tasksRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            firebaseAuth: context.read(),
            userService: context.read(),
          )..loadListener(),
          lazy: false,
        ),
      ],
      child: const AppWidget(),
    );
  }
}
