import 'package:provider/provider.dart';

import '../../core/modules/todo_list_module.dart';
import '../../core/routes/routes.dart';
import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impl.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impl.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends TodoListModule {
  HomeModule()
      : super(routers: {
          Routes.home: (context) => HomePage(
                homeController: context.read(),
              )
        }, bindings: [
          Provider<TasksRepository>(
              create: (context) =>
                  TasksRepositoryImpl(sqliteConnectionFactory: context.read())),
          Provider<TasksService>(
            create: (context) =>
                TasksServiceImpl(tasksRepository: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeController(tasksService: context.read()),
          ),
        ]);
}
