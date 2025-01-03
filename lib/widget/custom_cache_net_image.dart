import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    this.height,
    this.width,
    required this.imagePath,
    this.fit,
  });

  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: fit ?? BoxFit.cover,
      height: height ?? 398,
      width: width ?? double.infinity,
      imageUrl: imagePath,
      progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset(
        "assets/icons/loading-gif.gif",
        height: 50,
        width: 50,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
