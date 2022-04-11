import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/model/audio_video.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
import 'package:flutter/material.dart';

class AudioAndVideoView extends StatefulWidget {
  const AudioAndVideoView({Key? key}) : super(key: key);

  @override
  State<AudioAndVideoView> createState() => _AudioAndVideoViewState();
}

class _AudioAndVideoViewState extends State<AudioAndVideoView> {
  final _formKey = GlobalKey<FormState>();

  InputDecoration kInputDecoration(String hintText) =>
      InputDecoration(
        filled: true,
        hintText: hintText,
        fillColor: Colors.grey[200],
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
      );

  String? kValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  ValueNotifier<String> collectionNotifier = ValueNotifier('');

  static List<String> get collectionList =>
      [
        'hot10_audio',
        'myCollection_audio',
        'topFavourite_audio',
        'trending_audio'
      ];
  final TextEditingController _imageEditing = TextEditingController();
  final TextEditingController _titleEditing = TextEditingController();
  final TextEditingController _audioVideoUrlEditing = TextEditingController();
  final TextEditingController _thumbnailEditing = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: collectionNotifier,
                builder: (context, value, child) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: InputDecorator(
                        decoration: kInputDecoration('Select Collection'),
                        isEmpty: value.isEmpty,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              focusColor: Colors.transparent,
                              value: value.isEmpty ? null : value,
                              isDense: true,
                              items: collectionList
                                  .map((e) =>
                                  DropdownMenuItem(child: KText(e), value: e))
                                  .toList(),
                              onChanged: (val) async {
                                collectionNotifier.value = val!;
                              },
                            )),
                      ),
                    ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///image
                    TextFormField(
                        decoration: kInputDecoration(AppString.image),
                        controller: _imageEditing,
                        validator: kValidator),
                    const SizedBox(height: 26.0),
                    TextFormField(
                        decoration: kInputDecoration(AppString.thumbnail),
                        controller: _thumbnailEditing,
                        validator: kValidator),
                    const SizedBox(height: 26.0),
                    TextFormField(
                        decoration: kInputDecoration(AppString.title),
                        controller: _titleEditing,
                        validator: kValidator),
                    const SizedBox(height: 26.0),
                    TextFormField(
                        decoration: kInputDecoration(AppString.url),
                        controller: _audioVideoUrlEditing,
                        validator: kValidator),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Map map = AudioVideo(image: _imageEditing.text,
                                  thumbnail: _thumbnailEditing.text,
                                  title: _titleEditing.text,
                                  url: _audioVideoUrlEditing.text).toMap();
                              print(map);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
