import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String assetName;
  const SocialButton({
    super.key,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurStyle: BlurStyle.outer,
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(assetName, height: 24, width: 24),
    );
  }
}
