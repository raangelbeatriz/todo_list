import 'package:provider/provider.dart';

import '../../core/modules/todo_list_module.dart';
import '../../core/routes/routes.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impl.dart';
import 'task_create_controller.dart';
import 'task_create_page.dart';

class TaskModule extends TodoListModule {
  TaskModule()
      : super(
          bindings: [
            Provider<TasksService>(
              create: (context) =>
                  TasksServiceImpl(tasksRepository: context.read()),
            ),
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(
                tasksService: context.read(),
              ),
            ),
          ],
          routers: {
            Routes.taskCreate: (context) => TaskCreatePage(
                  controller: context.read(),
                )
          },
        );
}
