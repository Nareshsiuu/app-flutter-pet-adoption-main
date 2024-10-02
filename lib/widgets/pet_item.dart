import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:pet_app/theme/color.dart';
import 'package:pet_app/widgets/favorite_box.dart';

import 'custom_image.dart';

class PetItem extends StatelessWidget {
  const PetItem({
    Key? key,
    required this.data,
    this.width = 350,
    this.height = 400,
    this.radius = 40,
    this.onTap,
    this.onFavoriteTap,
  }) : super(key: key);
  final data;
  final double width;
  final double height;
  final double radius;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildImage(),
            Positioned(
              bottom: 0,
              child: _buildInfoGlass(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGlass() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(25),
      blur: 8,
      opacity: 0.1,
      child: Container(
        width: width,
        height: 120,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfo(),
            SizedBox(height: 5),
            _buildLocation(),
            SizedBox(height: 15),
            _buildAttributes(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return Text(
      data["location"],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white, // Changed color to white for better visibility
        fontSize: 14, // Slightly increased font size
        fontWeight: FontWeight.w500, // Increased font weight
        shadows: [
          Shadow(
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.5),
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        Expanded(
          child: Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              // Changed color to white for better visibility
              fontSize: 20,
              // Increased font size
              fontWeight: FontWeight.bold,
              // Increased font weight
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
        FavoriteBox(
          isFavorited: data["is_favorited"],
          onTap: onFavoriteTap,
        )
      ],
    );
  }

  Widget _buildImage() {
    return CustomImage(
      data["image"],
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius),
        bottom: Radius.zero,
      ),
      isShadow: false,
      width: width,
      height: 350,
    );
  }


  Widget _buildAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _getAttribute(
          Icons.transgender,
          data["sex"],
        ),
        _getAttribute(
          Icons.color_lens_outlined,
          data["color"],
        ),
        _getAttribute(
          Icons.query_builder,
          data["age"],
        ),
      ],
    );
  }

  Widget _getAttribute(IconData icon, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white, // Changed color to white for better visibility
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white, // Changed color to white for better visibility
            fontSize: 13,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}