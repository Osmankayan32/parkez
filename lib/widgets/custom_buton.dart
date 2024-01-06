import 'package:flutter/material.dart';

class CustomButon extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final Color? color;
  final Function() onTap;

  const CustomButon({
    Key? key,
    required this.onTap,
    required this.child,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? double.minPositive,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
