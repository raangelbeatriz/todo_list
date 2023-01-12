import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/ui/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Selector<AuthProvider, String>(
        selector: ((_, authProvider) {
          return authProvider.user?.displayName ?? 'Não informado';
        }),
        builder: (_, value, __) => Text(
          'E ai, $value!',
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: context.textTheme.headline5
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
