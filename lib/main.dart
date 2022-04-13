import 'package:dtf_web/my_app.dart';
import 'package:dtf_web/source/auth.dart';
import 'package:dtf_web/source/database_service.dart';
import 'package:dtf_web/source/storage_service.dart';
import 'package:dtf_web/state_provider/auth_provider.dart';
import 'package:dtf_web/state_provider/drawer_provider.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
import 'package:dtf_web/state_provider/storage_provider.dart';
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
    Provider<Auth>(create: (_) => Auth()),
    Provider<FirestoreService>(create: (_) => FirestoreService()),
    Provider<StorageService>(create: (_) => StorageService()),
    ChangeNotifierProxyProvider<Auth, AuthProvider>(
      create: (_) => AuthProvider(auth: Provider.of<Auth>(_, listen: false)),
      update: (_, auth, authPro) => AuthProvider(auth: auth),
    ),
    ChangeNotifierProxyProvider<FirestoreService, FireStoreProvider>(
        create: (_) => FireStoreProvider(
            firestoreService: Provider.of<FirestoreService>(_, listen: false)),
        update: (_, service, provider) =>
            FireStoreProvider(firestoreService: service)),
    ChangeNotifierProxyProvider<StorageService, StorageProvider>(
        create: (_) => StorageProvider(
            storageService: Provider.of<StorageService>(_, listen: false)),
        update: (_, service, provider) =>
            StorageProvider(storageService: service)),
    ChangeNotifierProvider<DrawerProvider>(
        create: (context) => DrawerProvider()),
  ], child: const MyApp()));
}
