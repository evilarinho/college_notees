import 'package:college_notees/components/editor.dart';
import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers dos campos de login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

//Controllers dos campos de cadastro
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final _recoveryFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  bool isForgotPasswordForm = false;

  bool isLogin = true;
  late String title;
  late String forgotPasswordBtn;
  late String subtitle;
  late String actionButton;
  late String toggleButtonText;
  late String passwordText = '';

  @override
  void initState() {
    setFormAction(true, false);
    super.initState();

    _registerPasswordController.addListener(() {
      setState(() {
        passwordText = _registerPasswordController.text;
      });
      debugPrint(passwordText);
    });
  }

  setFormAction(bool acao, bool forgotPswForm) {
    setState(() {
      isLogin = acao;
      isForgotPasswordForm = forgotPswForm;
    });

    if (isLogin) {
      if (isForgotPasswordForm) {
        title = 'Recuperar senha';
        subtitle =
            'Um link de recuperação de senha será enviado para o endereço de e-mail fornecido por você.';
        toggleButtonText = 'Cadastre-se';
        actionButton = 'Enviar';
        forgotPasswordBtn = 'Voltar';
      } else {
        title = 'Login';
        subtitle =
            'Bem vindo de volta! Logue-se para acompanhar suas atividades';
        toggleButtonText = 'Cadastre-se';
        actionButton = 'Entrar';
        forgotPasswordBtn = 'Esqueceu sua senha ?';
      }
    } else {
      title = 'Cadastro';
      subtitle =
          'Crie uma conta para poder registrar suas atividades escolares';
      toggleButtonText = 'Login';
      actionButton = 'Cadastrar';
    }
  }

  @override
  void dispose() {
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();

    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.6, 1),
                colors: [
                  Color(0xffd2c2fd),
                  Color(0xffb39afd),
                  Color(0xff916eff),
                  Color(0xff714cfe),
                  Color(0xff714cfe),
                  Color(0xff4a26fd),
                  Color(0xff465EFB)
                ],
                tileMode: TileMode.mirror,
              )),
              height: 200,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: Responsive.isMobile(context)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: Responsive.isMobile(context)
                        ? null
                        : const EdgeInsets.only(right: 30),
                    child: CustomOutlinedButton(
                        text: Text(
                          toggleButtonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.colors.light,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter'),
                        ),
                        onPressed: () => setFormAction(!isLogin, false)),
                  )
                ],
              )),
          Utils.addVerticalSpace(30),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            width: 500,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.title,
                ),
                Utils.addVerticalSpace(30),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.homeText,
                ),
                if (isLogin) ...[
                  Utils.addVerticalSpace(20),
                  TextButton(
                      onPressed: () =>
                          setFormAction(isLogin, !isForgotPasswordForm),
                      child: Text(
                        forgotPasswordBtn,
                        textAlign: TextAlign.center,
                        style: AppTheme.typo.button,
                      )),
                ],
                Utils.addVerticalSpace(40),
                isLogin
                    ? isForgotPasswordForm
                        ? recoverPasswordForm()
                        : loginForm()
                    : registerForm(passwordText),
                Utils.addVerticalSpace(15),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            right: 30, left: 30, top: 20, bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                    onPressed: () {
                      if (isLogin) {
                        if (isForgotPasswordForm) {
                          if (_recoveryFormKey.currentState!.validate()) {
                            debugPrint('Recuperar senha');
                            auth.resetPassword(_emailController.text);

                            _emailController.clear();
                          }
                        } else {
                          if (_loginFormKey.currentState!.validate()) {
                            debugPrint('login');
                            auth.login(
                                _loginEmailController.text,
                                _loginPasswordController
                                    .text); // Chama o método de login
                          }
                        }
                      } else {
                        if (_registerFormKey.currentState!.validate()) {
                          debugPrint('cadastro');
                          auth.register(
                              _registerEmailController.text,
                              _registerPasswordController.text,
                              _registerNameController
                                  .text); // Chama o método de cadastro
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    label: Text(
                      actionButton,
                      textAlign: TextAlign.center,
                      style: AppTheme.typo.button,
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget recoverPasswordForm() {
    return Form(
        key: _recoveryFormKey,
        child: Column(
          children: [
            LoginTextFormField(
                controller: _emailController,
                maxLength: 50,
                labelText: 'E-mail',
                hint: 'Informe o seu e-mail',
                validator: FormValidation.validateEmail(),
                seePassword: false)
          ],
        ));
  }

  Widget loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          LoginTextFormField(
            controller: _loginEmailController,
            maxLength: 50,
            labelText: 'E-mail',
            hint: 'Informe o seu e-mail',
            validator: FormValidation.validateEmail(),
            seePassword: false,
          ),
          LoginTextFormField(
            controller: _loginPasswordController,
            maxLength: 30,
            labelText: 'Senha',
            hint: 'Informe a sua senha',
            validator: FormValidation.validateField(),
            seePassword: true,
          ),
        ],
      ),
    );
  }

  Widget registerForm(passwordText) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          LoginTextFormField(
            controller: _registerNameController,
            maxLength: 50,
            labelText: 'Nome',
            hint: 'Informe o seu nome',
            validator: FormValidation.validateField(),
            seePassword: false,
          ),
          LoginTextFormField(
            controller: _registerEmailController,
            maxLength: 50,
            labelText: 'Email',
            hint: 'Informe o seu e-mail',
            validator: FormValidation.validateEmail(),
            seePassword: false,
          ),
          LoginTextFormField(
            controller: _registerPasswordController,
            maxLength: 30,
            labelText: 'Senha',
            hint: 'Informe a sua senha',
            validator: FormValidation.validateField(),
            seePassword: true,
          ),
          LoginTextFormField(
            controller: _confirmPasswordController,
            maxLength: 30,
            labelText: 'Repetir senha',
            hint: 'Informe novamente a sua senha',
            validator: FormValidation.validateConfirmPassword(passwordText),
            seePassword: true,
          ),
        ],
      ),
    );
  }
}
