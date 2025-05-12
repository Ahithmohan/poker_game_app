import 'package:flutter/material.dart';

class BuildIconImageWidget extends StatefulWidget {
  final String imgName;
  final VoidCallback? onTap;
  const BuildIconImageWidget({super.key, required this.imgName, this.onTap});

  @override
  State<BuildIconImageWidget> createState() => _BuildIconImageWidgetState();
}

class _BuildIconImageWidgetState extends State<BuildIconImageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Image.asset(
        widget.imgName,
        width: MediaQuery.of(context).size.width / 9,
      ),
    );
  }
}
