import 'package:dtf_web/model/main_category.dart';
import 'package:dtf_web/model/quote.dart';
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
  final Quote quote = const Quote(quote: '',author: '');
  int trackIndex = 0;
  final _formKey = GlobalKey<FormState>();
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
                onChanged: (val) async {
                  mainCategoryNotifier.value = val!;
                  await context
                      .read<FireStoreProvider>()
                      .getSubCategoryList((e) {}, id: val.categoryId);
                },
              )),
            ),
          ),
        ),
        const KText('Plz Select One'),
        Wrap(
          spacing: 15.0,
          runSpacing: 10,
          children: context
              .watch<FireStoreProvider>()
              .subCategoryList
              .asMap()
              .map((i, element) => MapEntry(
                  i,
                  ChoiceChip(
                    label: Text(element),
                    onSelected: (v) {
                      setState(() {
                        trackIndex = i;
                      });
                    },
                    selected: i == trackIndex,
                  )))
              .values
              .toList(),
        ),
        const KText('upload Qoute................'),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Author Name'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  quote.copyWith(author: value);
                  return null;
                },
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: const InputDecoration(hintText: 'Quote'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  quote.copyWith(quote: value);
                  print(quote.toMap());
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      print(quote.toMap());
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                   //   context.read<FireStoreProvider>().upLoadQuote()
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
