import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sims/pages/login_page.dart';
import 'package:sims/provider/register_provider.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red.dart';
import 'package:sims/widgets/text_field/email_text_field.dart';
import 'package:sims/widgets/text_field/name_text_field.dart';
import 'package:sims/widgets/text_field/password_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String routeName = "/register";

  void pushToLogin(BuildContext context) {
    print("Push to Login 1");
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    return Scaffold(
      body: Consumer<RegisterProvider>(
        builder: (context, provider, child) {
          if (!provider.afterChangePage) {
            if (!provider.loading) {
              if (provider.successType > 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  provider.setAfterChangePage();
                  pushToLogin(context);
                });
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
                      child: SingleChildScrollView(
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
                                'Lengkapi data untuk membuat akun',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: EmailTextField(
                                  errorMessage: provider.emailMessage,
                                  emailController: emailController),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: NameTextField(
                                  hint: "masukkan nama depan anda",
                                  errorMessage: provider.firstNameMessage,
                                  nameController: firstNameController),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: NameTextField(
                                  hint: "masukkan nama belakang anda",
                                  errorMessage: provider.lastNameMessage,
                                  nameController: lastNameController),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: PasswordTextField(
                                  hint: "masukkan password anda",
                                  errorMessage: provider.passwordMessage,
                                  passwordController: passwordController,
                                  registerProvider: provider),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: PasswordTextField(
                                    hint: "konfirmasi password",
                                    errorMessage: provider.confirmPasswordMessage,
                                    passwordController: confirmPasswordController,
                                    registerProvider: provider,
                                    isConfirm: true,),
                              ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                              child: ElevatedButtonRed(
                                    activeText: "Registrasi",
                                    onPressed: () {
                                      provider.checkValidity(
                                        emailController.text,
                                        firstNameController.text,
                                        lastNameController.text,
                                        passwordController.text,
                                        confirmPasswordController.text);
                                    if(WidgetsBinding.instance.window.viewInsets.bottom > 0.0){
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    }
                                    if (provider.isValid) {
                                      provider.register();
                                    }
                                    },
                                    isActive: true,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pushToLogin(context);
                              },
                              child: Container(
                                // width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("saya sudah punya akun? login ",
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
                    ),
                    Visibility(
                      visible: provider.responseMessage!= null,
                      //  && provider.token == null,
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

