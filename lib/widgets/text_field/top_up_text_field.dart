import 'package:flutter/material.dart';
import 'package:sims/constant/currency_format.dart';
import 'package:sims/provider/top_up_provider.dart';

class TopUpTextField extends StatelessWidget {
  const TopUpTextField({
    super.key,
    this.provider = null,
    this.enable = true,
    required this.topUpController,
  });
  final TextEditingController topUpController;
  final TopUpProvider? provider;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    if(provider!=null){
      if(provider!.topUp != "0"){
        var newValue = CurrencyFormat.convertToIdr2(int.parse(provider!.topUp), 0);
        topUpController.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newValue.length),
        );
      }
    }
    return TextField(
      enableInteractiveSelection: false,
      autocorrect: false,
      readOnly: !enable,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      controller: topUpController,
      onChanged: (value){
        value = value.replaceAll(".", "");
        value = value.replaceAll(",", "");
        if(provider!=null){
          provider?.setTopUp(value.toString());
        }
        var newValue = CurrencyFormat.convertToIdr2(int.parse(value), 0);
        topUpController.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newValue.length),
        );
      },
      
      maxLines: 1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          prefixIconConstraints: BoxConstraints.tight(Size.fromRadius(20)),
          hintText: enable ? "masukkan nominal Top Up" : topUpController.value.text,
          hintStyle: TextStyle(
            fontSize: 14, 
            color: enable ?Colors.grey : Colors.black,
            fontWeight: enable ? FontWeight.normal : FontWeight.bold  
          ),
          labelStyle: TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.money,
            size: 20,
          ),
          prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            return Colors.grey;
          })
          // prefixIconColor: Colors.black,
          ),
    );
  }
}
