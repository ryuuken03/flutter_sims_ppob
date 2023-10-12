import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sims/pages/dashboard_page.dart';
import 'package:sims/pages/login_page.dart';
import 'package:sims/pages/register_page.dart';
import 'package:sims/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:sims/provider/dashboard_provider.dart';
import 'package:sims/provider/history_transaction_provider.dart';
import 'package:sims/provider/home_provider.dart';
import 'package:sims/provider/login_provider.dart';
import 'package:sims/provider/payment_provider.dart';
import 'package:sims/provider/profile_provider.dart';
import 'package:sims/provider/register_provider.dart';
import 'package:sims/provider/splash_provider.dart';
import 'package:sims/provider/top_up_provider.dart';

Future main() async {
  await dotenv.load(fileName: "lib/.env" );
  
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SplashProvider>(
              create: (_) => SplashProvider()),
          ChangeNotifierProvider<RegisterProvider>(create: (_) => RegisterProvider()),
          ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
          ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
          ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
          ChangeNotifierProvider<TopUpProvider>(create: (_) => TopUpProvider()),
          ChangeNotifierProvider<HistoryTransactionProvider>(
              create: (_) => HistoryTransactionProvider()),
          ChangeNotifierProvider<ProfileProvider>(
              create: (_) => ProfileProvider()),
          ChangeNotifierProvider<PaymentProvider>(
              create: (_) => PaymentProvider()),
        ],
        child: MainApp(),
      ),
    );
  });
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      routes: {
        SplashPage.routeName: (context) => const SplashPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
      },
      initialRoute: SplashPage.routeName,
    );
  }
}
