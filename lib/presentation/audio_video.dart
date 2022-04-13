import 'dart:html';
import 'dart:typed_data';

import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/model/audio_video.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
import 'package:dtf_web/state_provider/storage_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioAndVideoView extends StatefulWidget {
  const AudioAndVideoView({Key? key}) : super(key: key);

  @override
  State<AudioAndVideoView> createState() => _AudioAndVideoViewState();
}

class _AudioAndVideoViewState extends State<AudioAndVideoView> {
  final _formKey = GlobalKey<FormState>();

  InputDecoration kInputDecoration(String hintText) => InputDecoration(
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

  static List<String> get collectionAudioList => [
        'hot10_audio',
        'myCollection_audio',
        'topFavourite_audio',
        'trending_audio'
      ];

  static List<String> get collectionVideoList => [
        'hot10_video',
        'myCollection_video',
        'topFavourite_video',
        'trending_video'
      ];
  final TextEditingController _imageEditing = TextEditingController();
  final TextEditingController _titleEditing = TextEditingController();
  final TextEditingController _audioVideoUrlEditing = TextEditingController();
  final TextEditingController _thumbnailEditing = TextEditingController();

  ///----------------------------

  final ValueNotifier<EnumVideoAudio> audioOrVideoNotifier = ValueNotifier(EnumVideoAudio.audio);

  ///--------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              ValueListenableBuilder<EnumVideoAudio>(
                valueListenable: audioOrVideoNotifier,
                builder: (_, value, child) {
                  return Row(
                    children: [
                      _Box(
                          isSelected: value,
                          string: AppString.audio,
                          onTapped: () {
                            collectionNotifier = ValueNotifier('');
                            audioOrVideoNotifier.value = EnumVideoAudio.audio;
                          },
                          videoAudio: EnumVideoAudio.audio),
                      const SizedBox(width: 16.0),
                      _Box(
                          isSelected: value,
                          string: AppString.video,
                          onTapped: () {
                            collectionNotifier = ValueNotifier('');
                            audioOrVideoNotifier.value = EnumVideoAudio.video;
                          },
                          videoAudio: EnumVideoAudio.video),
                    ],
                  );
                },
              ),
              ValueListenableBuilder<EnumVideoAudio>(
                  valueListenable: audioOrVideoNotifier,
                  builder: (_, parent, child) {
                    return ValueListenableBuilder<String>(
                      valueListenable: collectionNotifier,
                      builder: (__, value, child) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: InputDecorator(
                          decoration: kInputDecoration('Select Collection'),
                          isEmpty: value.isEmpty,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            focusColor: Colors.transparent,
                            value: value.isEmpty ? null : value,
                            isDense: true,
                            items: parent == EnumVideoAudio.audio
                                ? collectionAudioList
                                    .map((e) => DropdownMenuItem(
                                        child: KText(e), value: e))
                                    .toList()
                                : collectionVideoList
                                    .map((e) => DropdownMenuItem(
                                        child: KText(e), value: e))
                                    .toList(),
                            onChanged: (val) async {
                              collectionNotifier.value = val!;
                            },
                          )),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 26.0),
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
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () async {
                              await context.read<StorageProvider>().selectImage(
                                  (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)));
                              }, _imageEditing);
                            },
                            child: const KText('select Image')),
                        OutlinedButton(onPressed: (){
                          context.read<StorageProvider>().uploadImage();
                        }, child: KText('upload'))
                      ],
                    ),
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
                    OutlinedButton(
                        onPressed: () async {
                          await context.read<StorageProvider>().selectAudioOrVideo(
                                  (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)));
                              }, _audioVideoUrlEditing);
                        },
                        child: const KText('select Image')),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Map map = AudioVideo(
                                      image: _imageEditing.text,
                                      thumbnail: _thumbnailEditing.text,
                                      title: _titleEditing.text,
                                      url: _audioVideoUrlEditing.text)
                                  .toMap();
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

class _Box extends StatefulWidget {
  final EnumVideoAudio isSelected;
  final EnumVideoAudio videoAudio;
  final String string;

  final void Function() onTapped;

  const _Box(
      {Key? key,
      required this.isSelected,
      required this.string,
      required this.onTapped,
      required this.videoAudio})
      : super(key: key);

  @override
  State<_Box> createState() => _BoxState();
}

class _BoxState extends State<_Box> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTapped,
      onHighlightChanged: (value) {
        setState(() {
          isTapped = value;
        });
      },
      hoverColor: Colors.transparent,
      child: SizedBox(
        width: 80,
        height: 55,
        child: Align(
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(18.0),
                border: widget.isSelected == widget.videoAudio
                    ? Border.all(color: Colors.amber)
                    : null),
            height: isTapped ? 30.0 : 35.0,
            width: isTapped ? 70.0 : 80.0,
            child: KText(widget.string),
          ),
        ),
      ),
    );
  }
}

enum EnumVideoAudio { audio, video }
