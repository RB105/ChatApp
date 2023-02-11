import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatapp/core/router/router.dart';
import 'package:chatapp/core/theme/dark_mode.dart';
import 'package:chatapp/core/theme/light_mode.dart';
import 'package:chatapp/provider/remote/chat_provider.dart';
import 'package:chatapp/provider/total/theme_provider.dart';
import 'package:chatapp/view/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/auth/sign_in_provider.dart';
import 'provider/auth/sign_up_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignUpProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatThemeProvider(),
        )
      ],
      child: EasyLocalization(
        startLocale: const Locale('ru'),
          supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
          path: 'lib/core/lang',
          child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: LightThemMode.theme,
      dark: DarkThemMode.theme,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        return MaterialApp(
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          onGenerateRoute: RouteGenerator.router.onGenerate,
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
