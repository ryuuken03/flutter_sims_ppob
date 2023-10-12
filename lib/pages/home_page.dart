import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sims/constant/currency_format.dart';
import 'package:sims/model/service.dart';
import 'package:sims/model/banner_data.dart';
import 'package:sims/provider/home_provider.dart';
import 'package:sims/widgets/menu_service_home.dart';
import 'package:sims/widgets/progress_loading.dart';
import 'package:sims/widgets/toolbar/toolbar_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key
  });

  static const String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        double grid = 0;
        List<Service> list = [];
        List<BannerData> banner = [];
        if(!provider.hasCheck){
          if(provider.token == ""){
            provider.checkToken();
          }
        }else{
          if(provider.token != ""){
            if(!provider.loading){
              if (provider.data == null) {
                provider.getProfile();
              }else if (provider.dataServices == null) {
                provider.getServices();
              }else if (provider.dataBanners == null) {
                provider.getBanner();
              }else if (provider.dataBalance == null) {
                provider.getBalance();
              }
              if (provider.dataServices != null) {
                if (provider.dataServices?.data != null) {
                  provider.dataServices?.data!.forEach((element) {
                    list.add(element);
                  });
                  grid = list.length / 2;
                }
              }
              if (provider.dataBanners != null) {
                if (provider.dataBanners?.data != null) {
                  provider.dataBanners?.data!.forEach((element) {
                    banner.add(element);
                  });
                }
              }
            }
          }
        }
        return Scaffold(
            appBar: ToolbarHome(provider: provider),
            body: provider.loading
                ? ProgressLoading()
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Selamat Datang,",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(0, 2, 0, 15),
                            child: Text(
                              provider.data!.first_name! +
                                  " " +
                                  provider.data!.last_name!,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            height: 150,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  constraints: BoxConstraints.tightFor(),
                                  child: Image.asset(
                                    "assets/image/Background_Saldo.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(15),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Saldo Anda",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Rp ",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    // fontWeight:
                                                    //     FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 0),
                                                child: Text(
                                                  provider.balance ==
                                                          provider.balanceHide
                                                      ? provider.balance
                                                      : CurrencyFormat
                                                          .convertToIdr2(
                                                              int.parse(provider
                                                                  .balance),
                                                              0),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      letterSpacing: 3,
                                                      fontSize: 35,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          // visible: !provider.loadingBalance,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!provider.loadingBalance) {
                                                provider.changeShowBalance();
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    provider.balance == "••••••"
                                                        ? "Lihat Saldo"
                                                        : "Sembunyikan Saldo",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                                Icon(
                                                  provider.balance == "••••••"
                                                      ? Icons.visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: grid.toInt(),
                                      childAspectRatio: 0.5),
                              itemCount: list.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuServiceHome(data: list[index]);
                              }),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          Visibility(
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                "Temukan Promo Menarik",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: true,
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: banner.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var data = banner[index];
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        child: CachedNetworkImage(
                                          imageUrl: data.banner_image!,
                                          filterQuality: FilterQuality.high,
                                        ),
                                      );
                                    }),
                              ))
                        ],
                      ),
                    ),
                  ),   
            );
      }
    );
  }
}