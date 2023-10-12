import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sims/pages/dashboard_page.dart';
import 'package:sims/pages/register_page.dart';
import 'package:sims/provider/login_provider.dart';
import 'package:sims/provider/profile_provider.dart';
import 'package:sims/widgets/text_field/email_text_field.dart';
import 'package:sims/widgets/text_field/password_text_field.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = "/login";

  void pushToMain(BuildContext context) {
    print("Push to main");
    var prov = Provider.of<ProfileProvider>(context, listen: false);
    prov.login();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    // });
  }

  void pushToRegister(BuildContext context) {
    print("Push to register");
    Navigator.pushReplacementNamed(context, RegisterPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<LoginProvider>(context);
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          if (!provider.afterChangePage) {
            if (!provider.loading) {
              if (provider.data != null) {
                if (provider.data?.data != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    provider.setAfterChangePage();
                    pushToMain(context);
                  });
                }
              }
            }
          }
          return Form(
            child: provider.loading
              ? Center(
                  child: Container(
                    child: const CircularProgressIndicator(),
                  ),
                )
              :Container(
                margin: EdgeInsets.all(30),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  'assets/image/Logo.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Container(
                                child: Text(
                                  'SIMS PPOB',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Masuk atau buat akun untuk memulai',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: EmailTextField(
                                errorMessage: provider.emailMessage,
                                emailController: emailController),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: PasswordTextField(
                                hint: "masukkan password anda",
                                errorMessage: provider.passwordMessage,
                                passwordController: passwordController,
                                provider: provider),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                            child: ElevatedButtonRed(
                                activeText: "Masuk",
                                onPressed:() {
                                  provider.checkValidity(
                                      emailController.text,
                                      passwordController.text);
                                  if(WidgetsBinding.instance.window.viewInsets.bottom > 0.0){
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  }
                                  if (provider.isValid) {
                                    provider.login();
                                  }
                                },
                                isActive: true,
                              ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pushToRegister(context);
                            },
                            child: Container(
                              // width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("belum punya akun? registrasi ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      )),
                                  Text(
                                    "disini",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: provider.responseMessage!= null && provider.token == null,
                      // visible: true,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        constraints: BoxConstraints.tightFor(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Color(0xfffff5f3)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                provider.responseMessage!= null 
                                ?provider.responseMessage!
                                :""
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  provider.removeResponseMessage();
                                }, 
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                  size: 15,
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          );
        },
      ),
    );
  }
}

