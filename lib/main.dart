import 'package:dtf_web/my_app.dart';
import 'package:dtf_web/source/auth.dart';
import 'package:dtf_web/state_provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if(!kIsWeb){
  //   await Firebase.initializeApp();
  // }else{
  //   await Firebase.initializeApp();
  // }

  // runApp(ChangeNotifierProvider(
  //     create: (_) => AuthProvider(auth: Auth()), child: const MyApp()));

  runApp(MultiProvider(providers: [
    Provider(create: (_) => Auth()),
    ChangeNotifierProxyProvider<Auth, AuthProvider>(
      create: (_) => AuthProvider(auth: Provider.of<Auth>(_,listen: false)),
      update: (_,auth,authPro)=>AuthProvider(auth: auth),
    )
  ], child: const MyApp()));
}
