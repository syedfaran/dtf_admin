class AudioVideo {
  final String image;
  final String thumbnail;
  final String url;
  final String title;
  final bool isFreemium;

  const AudioVideo(
      {required this.image,
      required this.thumbnail,
      required this.title,
      required this.isFreemium,
      required this.url});

  Map<String, dynamic> toMap() {
    return {
      'img': image,
      'thumbnail': thumbnail,
      'url': url,
      'title': title,
      'isFreemium':isFreemium
    };
  }

  factory AudioVideo.fromMap(Map<String, dynamic> map) {
    return AudioVideo(
      image: map['img'] as String,
      thumbnail: map['thumbnail'] as String,
      url: map['url'] as String,
      title: map['title'] as String,
      isFreemium: map['isFreemium'] as bool,
    );
  }

  AudioVideo copyWith({
    String? image,
    String? thumbnail,
    String? url,
    String? title,
    bool? isFreemium
  }) {
    return AudioVideo(
      image: image ?? this.image,
      thumbnail: thumbnail ?? this.thumbnail,
      url: url ?? this.url,
      title: title ?? this.title,
      isFreemium: isFreemium??this.isFreemium
    );
  }
}
