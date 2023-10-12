import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sims/provider/dashboard_provider.dart';
import 'package:sims/provider/profile_provider.dart';

class ToolbarDefault extends StatelessWidget implements PreferredSizeWidget {
  const ToolbarDefault(
      {Key? key,
      this.provider,
      required this.title,
      })
      : super(key: key);

  final String title;
  final DashboardProvider? provider;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 1,
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: (){
          Navigator.of(context, rootNavigator: true).maybePop();
          if(provider!=null){
            provider!.changeCurrentPage(0);
            if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            }
          } 
          var prov = Provider.of<ProfileProvider>(context, listen: false);
          if(prov.isEdit){
            prov.changeEdit();
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_sharp,
                size: 16,
                color: Colors.black,
              ),
              Text(" Kembali", style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),)
            ],
          ),
        ),
      ),
      title:Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(0, 0, 100, 0),
        child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
