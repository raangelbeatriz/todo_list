import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/notifier/default_listener_notifier.dart';
import '../../core/routes/routes.dart';
import '../../core/ui/messages.dart';
import '../../core/ui/theme_extensions.dart';
import '../../models/task_filter_enum.dart';
import '../tasks/task_module.dart';
import 'home_controller.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_filters.dart';
import 'widgets/home_header.dart';
import 'widgets/home_tasks.dart';
import 'widgets/home_week_filter.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({Key? key, required HomeController homeController})
      : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToCreateTask(BuildContext context) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           TaskModule().getPage(Routes.taskCreate, context)),
    // );

    await Navigator.push(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.bottomRight,
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return TaskModule().getPage(Routes.taskCreate, context);
          }),
    );
    widget._homeController.refreshPage();
  }

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
        context: context,
        successVoidCallBack: (notifier, listenerInstance) {
          listenerInstance.dispose();
        },
        everVoidCallBack: (notifier, listenerNotifier) {
          if (notifier is HomeController && notifier.infoMessage != null) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTasks();
      widget._homeController.findTasks(TaskFilterEnum.today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        backgroundColor: const Color(0xFFFAFBFE),
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) =>
                context.read<HomeController>().showOrHideFinishedTasks(),
            itemBuilder: (_) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                    '${context.read<HomeController>().showFinishedTasks ? 'Esconder' : 'Mostrar'} tarefas concluídas'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFAFBFE),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _goToCreateTask(context);
        },
      ),
      body: LayoutBuilder(
        builder: (context, constrains) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constrains.maxHeight,
                  minWidth: constrains.minWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
