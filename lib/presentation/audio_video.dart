import 'dart:html';
import 'dart:typed_data';

import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/model/audio_video.dart';
import 'package:dtf_web/presentation/widgets/kText.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
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

  static List<String> get collectionAudioList =>
      [
        'hot10_audio',
        'myCollection_audio',
        'topFavourite_audio',
        'trending_audio'
      ];

  static List<String> get collectionVideoList =>
      [
        'hot10_video',
        'myCollection_video',
        'topFavourite_video',
        'trending_video'
      ];
  final TextEditingController _imageEditing = TextEditingController();
  final TextEditingController _titleEditing = TextEditingController();
  final TextEditingController _audioEditing = TextEditingController();
  final TextEditingController _thumbnailEditing = TextEditingController();

  ///----------------------------

  final ValueNotifier<EnumVideoAudio> audioOrVideoNotifier =
  ValueNotifier(EnumVideoAudio.Audios);

  ///--------------
  int? trackIndex;

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
                            audioOrVideoNotifier.value = EnumVideoAudio.Audios;
                            trackIndex = null;
                          },
                          videoAudio: EnumVideoAudio.Audios),
                      const SizedBox(width: 16.0),
                      _Box(
                          isSelected: value,
                          string: AppString.video,
                          onTapped: () {
                            collectionNotifier = ValueNotifier('');
                            audioOrVideoNotifier.value = EnumVideoAudio.Videos;
                            trackIndex = null;
                          },
                          videoAudio: EnumVideoAudio.Videos),
                    ],
                  );
                },
              ),
              ValueListenableBuilder<EnumVideoAudio>(
                  valueListenable: audioOrVideoNotifier,
                  builder: (_, parent, child) {
                    return ValueListenableBuilder<String>(
                      valueListenable: collectionNotifier,
                      builder: (__, value, child) =>
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
                                    items: parent == EnumVideoAudio.Audios
                                        ? collectionAudioList
                                        .asMap()
                                        .map((i, element) =>
                                        MapEntry(
                                            i,
                                            DropdownMenuItem<String>(
                                                onTap: () {
                                                  trackIndex = i;
                                                },
                                                child: KText(element),
                                                value: element)))
                                        .values
                                        .toList()
                                        : collectionVideoList
                                        .asMap()
                                        .map((i, element) =>
                                        MapEntry(
                                            i,
                                            DropdownMenuItem<String>(
                                                onTap: () {
                                                  trackIndex = i;
                                                },
                                                child: KText(element),
                                                value: element)))
                                        .values
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
                        // OutlinedButton(
                        //     onPressed: () {
                        //       context.read<StorageProvider>().upLoadImage(
                        //               (failure) {
                        //
                        //               },
                        //           index: trackIndex!,
                        //           isAudioSelected: audioOrVideoNotifier.value ==
                        //               EnumVideoAudio.Audios);
                        //     },
                        //     child: KText('upload')),
                        OutlinedButton(
                            onPressed: () {
                              context
                                  .read<StorageProvider>()
                                  .unSelectImage(string: _imageEditing);
                            },
                            child: KText('unSelect Image')),
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
                        controller: _audioEditing,
                        validator: kValidator),
                    ValueListenableBuilder<EnumVideoAudio>(
                        valueListenable: audioOrVideoNotifier,
                        builder: (_, value, child) {
                          return value == EnumVideoAudio.Audios
                              ? Row(
                            children: [
                              OutlinedButton(
                                  onPressed: () async {
                                    await context
                                        .read<StorageProvider>()
                                        .selectAudio((e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(e.message)));
                                    }, _audioEditing);
                                  },
                                  child: const KText('select Audio')),
                              // OutlinedButton(
                              //     onPressed: () {
                              //       context
                              //           .read<StorageProvider>()
                              //           .upLoadAudio((failure) {},
                              //           index: trackIndex!,
                              //           isAudioSelected:
                              //           audioOrVideoNotifier
                              //               .value ==
                              //               EnumVideoAudio
                              //                   .Audios);
                              //     },
                              //     child: KText('upload')),
                              OutlinedButton(
                                  onPressed: () {
                                    context
                                        .read<StorageProvider>()
                                        .unSelectImage(
                                        string: _audioEditing);
                                  },
                                  child: KText('unSelect Audio')),
                            ],
                          )
                              : const SizedBox.shrink();
                        }),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final storagePro = context.read<StorageProvider>();
                            if (_formKey.currentState!.validate()) {
                              if (trackIndex == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        KText('on Collection Selected')));
                                return;
                              } else {
                                await Future.wait([
                                  storagePro.upLoadImage((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text(e.message)));
                                  },
                                      index: trackIndex!,
                                      isAudioSelected:
                                      audioOrVideoNotifier.value ==
                                          EnumVideoAudio.Audios),
                                  storagePro.upLoadAudio((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text(e.message)));
                                  },
                                      index: trackIndex!,
                                      isAudioSelected:
                                      audioOrVideoNotifier.value ==
                                          EnumVideoAudio.Audios),
                                ]);
                                if (storagePro.audioUrl == null || storagePro.imageUrl == null) {
                                  print(storagePro.audioUrl);
                                  print(storagePro.imageUrl);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                          KText(
                                              'Audio Or Video Link not Generated')));
                                  return;
                                } else {
                                  AudioVideo audioVideoObj = AudioVideo(
                                      image: storagePro.imageUrl!,
                                      thumbnail: _thumbnailEditing.text,
                                      title: _titleEditing.text,
                                      url: storagePro.audioUrl!);

                                  context.read<FireStoreProvider>()
                                      .uploadAudioAndVideo((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data Interrupted')),
                                    );
                                  }, collection:audioOrVideoNotifier.value.name,
                                      map:audioVideoObj.toMap(), subCollection:collectionNotifier.value);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('data added')),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(AppString.submit),
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

  const _Box({Key? key,
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

enum EnumVideoAudio { Audios, Videos }
