import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../../../models/task_filter_enum.dart';
import '../../../models/total_tasks_model.dart';
import '../home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTaskModel? totalTaskModel;
  final bool selected;
  const TodoCardFilter(
      {Key? key,
      required this.label,
      required this.taskFilter,
      this.totalTaskModel,
      required this.selected})
      : super(key: key);
  double _getFinishPercent() {
    final total = totalTaskModel?.totalTask ?? 0;
    final totalFinished = totalTaskModel?.totalFinishedTasks ?? 0.1;
    if (total == 0) {
      return 0.0;
    }
    return ((totalFinished * 100) / total) / 100;
  }

  int activeTasks() {
    int totalTasks = totalTaskModel?.totalTask ?? 0;
    if (totalTasks == 0) {
      return totalTasks;
    }
    int finishedTasks = totalTaskModel?.totalFinishedTasks ?? 0;
    int activeTasks = totalTasks - finishedTasks;
    return activeTasks;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeController>().findTasks(taskFilter),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120, maxWidth: 150),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: selected ? context.primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${activeTasks()} de ${totalTaskModel?.totalTask ?? 0} TASKS',
              style: context.titleStyle.copyWith(
                  fontSize: 10, color: selected ? Colors.white : Colors.grey),
            ),
            Text(
              label,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _getFinishPercent()),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor: selected
                      ? context.primaryColorLight
                      : Colors.grey.shade300,
                  value: _getFinishPercent(),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    selected ? Colors.white : context.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
