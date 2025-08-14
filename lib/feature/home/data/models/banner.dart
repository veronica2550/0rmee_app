class BannerModel {
  final int id;
  final String image;
  final String iosPath;
  final String aosPath;

  BannerModel({
    required this.id,
    required this.image,
    required this.iosPath,
    required this.aosPath,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      iosPath: json['iosPath'],
      aosPath: json['aosPath'],
    );
  }
}
