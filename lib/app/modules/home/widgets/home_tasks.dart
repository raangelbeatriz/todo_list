import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../../../models/task_filter_enum.dart';
import '../../../models/task_model.dart';
import '../home_controller.dart';
import 'dismiss_task.dart';
import 'task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Selector<HomeController, String>(selector: (context, controller) {
            return controller.filterSelected.description;
          }, builder: (context, value, child) {
            return Text(
              'TASKS $value',
              style: context.titleStyle,
            );
          }),
          Column(
              children: context
                  .select<HomeController, List<TaskModel>>(
                      (controller) => controller.filteredTasks)
                  .map(
                    (e) => Dismissible(
                      key: Key(
                        e.id.toString(),
                      ),
                      onDismissed: (direction) {
                        context.read<HomeController>().deleteTask(e.id);
                      },
                      background: const DismissTask(),
                      child: Task(taskModel: e),
                    ),
                  )
                  .toList())
        ],
      ),
    );
  }
}
