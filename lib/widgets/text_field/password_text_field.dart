import 'package:flutter/material.dart';
import 'package:sims/provider/login_provider.dart';
import 'package:sims/provider/register_provider.dart';


class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.hint,
    required this.errorMessage,
    required this.passwordController,
    this.provider = null,
    this.registerProvider = null,
    this.isConfirm = false,
  });

  final String hint;
  final String errorMessage;
  final TextEditingController passwordController;
  final LoginProvider? provider;
  final RegisterProvider? registerProvider;
  final bool isConfirm;

  @override
  Widget build(BuildContext context) {
    bool hidePassword = false;
    if(provider!=null){
      hidePassword = provider!.hidePassword;
    }
    if (registerProvider != null) {
      if(isConfirm){
        hidePassword = registerProvider!.hideConfirmPassword;
      }else{
        hidePassword = registerProvider!.hidePassword;
      }
    }
    return TextField(
      autocorrect: false,
      obscureText: hidePassword,
      textInputAction: TextInputAction.done,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          prefixIconConstraints: BoxConstraints.tight(Size.fromRadius(20)),
          error: errorMessage != ""
              ? Container(
                  width: double.infinity,
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                )
              : null,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          labelStyle: TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: errorMessage != "" ? Colors.red : Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: errorMessage != "" ? Colors.red : Colors.grey)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20,
          ),
          prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (errorMessage != "") {
              return Colors.red;
            }
            return Colors.grey;
          }),
          suffixIcon: IconButton(
            onPressed: () {
              if(provider!=null){
                provider!.changeHidePassword();
              }
              if (registerProvider != null) {
                if (isConfirm) {
                  registerProvider!.changeHideConfirmPassword();
                } else {
                  registerProvider!.changeHidePassword();
                }
              }
            },
            icon: Icon(hidePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            iconSize: 20,
          ),
          suffixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return Colors.black;
            }
            return Colors.grey;
          })),
    );
  }
}
