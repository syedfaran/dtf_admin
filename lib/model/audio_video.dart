class AudioVideo {
  final String image;
  final String thumbnail;
  final String url;
  final String title;

  const AudioVideo(
      {required this.image,
      required this.thumbnail,
      required this.title,
      required this.url});

  Map<String, dynamic> toMap() {
    return {
      'img': image,
      'thumbnail': thumbnail,
      'url': url,
      'title': title,
    };
  }

  factory AudioVideo.fromMap(Map<String, dynamic> map) {
    return AudioVideo(
      image: map['img'] as String,
      thumbnail: map['thumbnail'] as String,
      url: map['url'] as String,
      title: map['title'] as String,
    );
  }

  AudioVideo copyWith({
    String? image,
    String? thumbnail,
    String? url,
    String? title,
  }) {
    return AudioVideo(
      image: image ?? this.image,
      thumbnail: thumbnail ?? this.thumbnail,
      url: url ?? this.url,
      title: title ?? this.title,
    );
  }
}
