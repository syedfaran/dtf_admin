import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/presentation/audio_video.dart';
import 'package:dtf_web/presentation/create_category_subcategory.dart';
import 'package:dtf_web/presentation/upload_quote.dart';
import 'package:dtf_web/source/database_service.dart';
import 'package:dtf_web/state_provider/auth_provider.dart';
import 'package:dtf_web/state_provider/drawer_provider.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //context.watch<AuthProvider>().loginState==ApplicationLoginState.loggedIn
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {

         //context.read<FireStoreProvider>().getListOfMainCategory((e) { });

        },
      ),
      drawer: true?Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Add Category/SubCategory'),
              onTap: () {
                context.read<DrawerProvider>().enumBody =
                    EnumBody.categoriesAndSubCategories;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Upload Quote'),
              onTap: () {
                context.read<DrawerProvider>().enumBody =
                    EnumBody.uploadQuote;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Audio and Video'),
              onTap: () {
                context.read<DrawerProvider>().enumBody =
                    EnumBody.audioAndVideo;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('LogOut'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ):null,
      appBar: AppBar(),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    switch (provider.loginState) {
      case ApplicationLoginState.loggedIn:
        return Center(
          child: OutlinedButton(
              child: const Text('Google'),
              onPressed: () {
                provider.signInWithGoogle((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppString.errorText)));
                });
              }),
        );
      case ApplicationLoginState.loggedOut:
        switch (context.watch<DrawerProvider>().enumBody) {
          case EnumBody.categoriesAndSubCategories:
            return const CreateCategoryAndSubCategory();
          case EnumBody.uploadQuote:
            return const UploadQuote();
          case EnumBody.audioAndVideo:
            return const AudioAndVideo();
        }
    }
  }
}
