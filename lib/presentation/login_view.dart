import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/constants/image_string.dart';
import 'package:dtf_web/presentation/audio_video.dart';
import 'package:dtf_web/presentation/create_category_subcategory.dart';
import 'package:dtf_web/presentation/upload_quote.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()async {
      //
      //    //context.read<FireStoreProvider>().getListOfMainCategory((e) { });
      //
      //   },
      // ),
      drawer: Provider.of<AuthProvider>(context).loginState==ApplicationLoginState.loggedIn?Drawer(
        child: ListView(
          children: [
            const DrawerHeader(

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

                context.read<AuthProvider>().signOut();
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
      case ApplicationLoginState.loggedOut:
        return Center(
          child: InkWell(

            onTap: (){
              provider.signInWithGoogle((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppString.errorText)));
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Image(image: ImageString.google,height: 20),
                    SizedBox(width: 16.0),
                    KText(AppString.signInWithGoogle),
                  ],
                ),
              ),
            ),
          ),
        );
      case ApplicationLoginState.loggedIn:
        switch (context.watch<DrawerProvider>().enumBody) {
          case EnumBody.categoriesAndSubCategories:
            return const CreateCategoryAndSubCategory();
          case EnumBody.uploadQuote:
            return const UploadQuote();
          case EnumBody.audioAndVideo:
            return const AudioAndVideoView();
        }
    }
  }
}



