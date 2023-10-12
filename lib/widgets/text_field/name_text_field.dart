import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.hint,
    required this.errorMessage,
    required this.nameController,
    this.enable = true,
  });
  final String hint;
  final String errorMessage;
  final TextEditingController nameController;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      readOnly: !enable,
      enableInteractiveSelection: enable,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: nameController,
      maxLines: 1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          prefixIconConstraints: BoxConstraints.tight(Size.fromRadius(20)),
          hintText: hint,
          error: Container(
            width: double.infinity,
            child: Text(
              errorMessage,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.red, fontSize: 10),
            ),
          ),
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
            Icons.person_2_outlined,
            size: 20,
          ),
          prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (errorMessage != "") {
              return Colors.red;
            }
            return Colors.grey;
          })
          // prefixIconColor: Colors.black,
          ),
    );
  }
}
