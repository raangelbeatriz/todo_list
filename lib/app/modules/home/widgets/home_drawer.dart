import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/ui/messages.dart';
import '../../../core/ui/theme_extensions.dart';
import '../../../services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  final nameVN = ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: ((context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://icon-library.com/images/no-profile-picture-icon/no-profile-picture-icon-1.jpg';
                  }),
                  builder: ((_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                    );
                  }),
                ),
                Selector<AuthProvider, String>(
                  selector: ((_, authProvider) {
                    return authProvider.user?.displayName ?? 'Não informado';
                  }),
                  builder: ((context, value, child) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Alterar Nome'),
            onTap: () {
              showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Text('Alterar nome'),
                    content: TextField(
                      onChanged: (value) => nameVN.value = value,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final name = nameVN.value;
                          if (name.isEmpty) {
                            Messages.of(context).showError('Nome obrigatório');
                          } else {
                            Loader.show(context);
                            await context
                                .read<UserService>()
                                .updateDisplayName(name);
                            Loader.hide();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Alterar',
                        ),
                      ),
                    ],
                  );
                }),
              );
            },
          ),
          ListTile(
            onTap: () => context.read<AuthProvider>().logout(),
            title: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
