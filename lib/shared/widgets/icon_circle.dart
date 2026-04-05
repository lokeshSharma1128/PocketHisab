import 'package:flutter/cupertino.dart';

class IconCircle extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;

  const IconCircle({
    super.key,
    required this.emoji,
    required this.color,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.4)),
      ),
    );
  }
}