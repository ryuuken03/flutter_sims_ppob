import 'package:flutter/material.dart';
import 'package:sims/provider/home_provider.dart';

class ToolbarHome extends StatelessWidget implements PreferredSizeWidget {
  const ToolbarHome({
    required this.provider,
    Key? key,
  }) : super(key: key);

  final HomeProvider provider;
  @override
  Widget build(BuildContext context) {
    var imageUrl = "";
    if(provider.data?.profile_image!=null){
      imageUrl = provider.data!.profile_image!;
    }
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/image/Logo.png',width: 20, height: 20,),
            Text(
              " SIMS PPOB",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(10),
          width: preferredSize.height-20,
          height: preferredSize.height-20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((preferredSize.height-20)/2),
            border: Border.all(width: 1, color: Colors.grey)
          ),
          child: CircleAvatar(
            foregroundImage: NetworkImage(imageUrl),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/image/Profile.png'),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
