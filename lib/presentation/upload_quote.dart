import 'package:dtf_web/model/main_category.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadQuote extends StatefulWidget {
  const UploadQuote({Key? key}) : super(key: key);

  @override
  State<UploadQuote> createState() => _UploadQuoteState();
}

class _UploadQuoteState extends State<UploadQuote> {
  ValueNotifier<MainCategory> mainCategoryNotifier =
      ValueNotifier(const MainCategory(categoryId: '', mainCategory: ''));

  @override
  void initState() {
    context.read<FireStoreProvider>().getListOfMainCategory((e) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<MainCategory>(
          valueListenable: mainCategoryNotifier,
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                hintText: 'hintText',
              ),
              isEmpty: value.mainCategory.isEmpty,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<MainCategory>(
                value: value.mainCategory.isEmpty ? null : value,
                isDense: true,
                items: context
                    .watch<FireStoreProvider>()
                    .mainCategoryList
                    .map((e) => DropdownMenuItem(
                        child: KText(e.mainCategory), value: e))
                    .toList(),
                onChanged: (val) async{
                  mainCategoryNotifier.value = val!;
                 await context
                      .read<FireStoreProvider>()
                      .getSubCategoryList((e) {}, id: val.categoryId);
                },
              )),
            ),
          ),
        ),
        KText(context.watch<FireStoreProvider>().subCategoryList.toString())
      ],
    );
  }
}
