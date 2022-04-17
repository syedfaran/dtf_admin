import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/model/main_category.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateCategoryAndSubCategory extends StatefulWidget {
  const CreateCategoryAndSubCategory({Key? key}) : super(key: key);

  @override
  State<CreateCategoryAndSubCategory> createState() =>
      _CreateCategoryAndSubCategoryState();
}

class _CreateCategoryAndSubCategoryState
    extends State<CreateCategoryAndSubCategory> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  late TextEditingController _categoryEditingController;
  late TextEditingController _subCategoryEditingController;
  ValueNotifier<MainCategory> mainCategoryNotifier =
      ValueNotifier(const MainCategory(categoryId: '', mainCategory: ''));

  @override
  void initState() {
    _categoryEditingController = TextEditingController();
    _subCategoryEditingController = TextEditingController();
    //context.read<FireStoreProvider>().getListOfMainCategory((e) {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const KText(AppString.addCategory,
                          fontSize: 34.0, fontWeight: FontWeight.bold),
                      TextFormField(
                        controller: _categoryEditingController,
                        decoration: InputDecoration(
                          hintText: AppString.addCategory,
                          filled: true,
                          fillColor: Colors.grey[200],
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //todo also add Id
                                await context
                                    .read<FireStoreProvider>()
                                    .addCategory((e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Something Went Wrong')));
                                },
                                        string: _categoryEditingController.text,
                                        id: uuid.v4());

                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  )),

              ///
              Form(
                  key: _formKeyTwo,
                  child: Column(
                    //      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const KText(AppString.addSubCategory,
                          fontSize: 34.0, fontWeight: FontWeight.bold),
                      ValueListenableBuilder<MainCategory>(
                        valueListenable: mainCategoryNotifier,
                        builder: (context, value, child) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Select Category',
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                            ),
                            isEmpty: value.mainCategory.isEmpty,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<MainCategory>(
                              focusColor: Colors.transparent,
                              value: value.mainCategory.isEmpty ? null : value,
                              isDense: true,
                              items: context
                                  .watch<FireStoreProvider>()
                                  .mainCategoryList
                                  .map((e) => DropdownMenuItem(
                                      child: KText(e.mainCategory), value: e))
                                  .toList(),
                              onChanged: (val) {
                                mainCategoryNotifier.value = val!;
                              },
                            )),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _subCategoryEditingController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: AppString.addSubCategory,
                          fillColor: Colors.grey[200],
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      ValueListenableBuilder<MainCategory>(
                          valueListenable: mainCategoryNotifier,
                          builder: (_, value, child) {
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: !(value.mainCategory.isEmpty ||
                                          value.categoryId.isEmpty)
                                      ? () async {
                                          if (_formKeyTwo.currentState!.validate()) {
                                            await context.read<FireStoreProvider>().addSubCategory((e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text('Error Data $e')));
                                            },
                                                string: _subCategoryEditingController.text,
                                                id: mainCategoryNotifier.value.categoryId);
                                          }
                                        }
                                      : null,
                                  child: const Text('Submit'),
                                ),
                              ),
                            );
                          }),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
