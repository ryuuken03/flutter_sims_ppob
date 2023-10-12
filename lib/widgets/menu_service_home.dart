import 'package:flutter/material.dart';
import 'package:sims/model/service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sims/pages/payment_page.dart';

class MenuServiceHome extends StatelessWidget {
  const MenuServiceHome({
    super.key,
    required this.data,
  });

  final Service data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Navigator.pushNamed(
        //   context, 
        //   PaymentPage.routeName,
        //   arguments: data);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PaymentPage(data: data,);
            },
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            child: CachedNetworkImage(
              imageUrl: data.service_icon!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              data.service_name!,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
