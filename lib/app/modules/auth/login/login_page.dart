import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/notifier/default_listener_notifier.dart';
import '../../../core/routes/routes.dart';
import '../../../core/ui/messages.dart';
import '../../../core/widgets/todo_list_divider.dart';
import '../../../core/widgets/todo_list_field.dart';
import '../../../core/widgets/todo_list_logo.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _formKey = GlobalKey<FormState>();
final _emailEC = TextEditingController();
final _passwordEC = TextEditingController();
final _emailFocus = FocusNode();

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      successVoidCallBack: (notifier, listenerNotifier) {
        Messages.of(context).showInfo('Login feito com sucesso');
      },
      everVoidCallBack: (notifier, listenerNotifier) {
        if (notifier is LoginController && notifier.hasInfo) {
          Messages.of(context).showInfo(notifier.infoMessage!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TodoListDivider(),
                    const TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TodoListField(
                              label: 'Email',
                              focusNode: _emailFocus,
                              controller: _emailEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('Email obrigatório'),
                                Validatorless.email('Email Inválido')
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TodoListField(
                              label: 'Senha',
                              controller: _passwordEC,
                              obscureText: true,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(6,
                                    'Senha deve ter pelo menos 6 caracteres'),
                              ]),
                            ),
                            const TodoListDivider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isNotEmpty) {
                                      final email = _emailEC.text.trim();
                                      context
                                          .read<LoginController>()
                                          .forgotPassword(email);
                                    } else {
                                      Messages.of(context).showError(
                                          'Digite um email para recuperar sua senha');
                                      _emailFocus.requestFocus();
                                    }
                                  },
                                  child: const Text('Esqueceu sua senha?'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      final email = _emailEC.text.trim();
                                      final password = _passwordEC.text.trim();

                                      context
                                          .read<LoginController>()
                                          .loginUser(email, password);
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Login'),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F3F7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            SignInButton(Buttons.Google,
                                text: 'Continue com o google',
                                padding: const EdgeInsets.all(5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                onPressed: () {
                              context.read<LoginController>().googleLogin();
                            }),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Não tem conta? '),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, Routes.register);
                                    },
                                    child: const Text('Cadastre-se'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
