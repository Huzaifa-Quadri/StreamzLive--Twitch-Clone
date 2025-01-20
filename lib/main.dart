import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/resources/auth_Methods.dart';
import 'package:streamzlive/resources/userprovider.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/screens/loginScreen.dart';
import 'package:streamzlive/screens/onboardingScreen.dart';
import 'package:streamzlive/screens/signupScreen.dart';
import 'package:streamzlive/secrets/initialize_keys.dart';
import 'package:streamzlive/utils/colors.dart';
import 'package:streamzlive/models/user.dart' as model;
import 'package:streamzlive/widgets/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: apiKey,
            appId: appId,
            messagingSenderId: messagingSenderId,
            projectId: projectId),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('\n\n\tSome Error has Occured : ${e.toString()}\n\n');
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamZ Live',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColor,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
      ),
      routes: {
        OnBoardingScreen.routName: (context) => const OnBoardingScreen(),
        Loginscreen.routname: (context) => const Loginscreen(),
        SignUpScreen.routname: (context) => const SignUpScreen(),
        HomeScreen.routename: (context) => const HomeScreen()
      },
      home: FutureBuilder(
        future: AuthMethods()
            .getCurrentUser(
          FirebaseAuth.instance.currentUser
              ?.uid, /*same as-> FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : null */
        )
            .then(
          (onValue) {
            if (onValue != null && context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(model.User.fromMap(onValue));
            }
            return onValue;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child:
                  Text('Some Error has Occured ${snapshot.error.toString()}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loadingindicator();
          }
          // print(snapshot.data);
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          return const OnBoardingScreen();
        },
      ),
      // home: const OnBoardingScreen(),
    );
  }
}
