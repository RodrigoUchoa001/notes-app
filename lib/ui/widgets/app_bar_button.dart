import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Function function;
  final IconData icon;
  final bool? isLoading;
  const AppBarButton({
    super.key,
    required this.function,
    required this.icon,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Color(0xFF3B3B3B), // set color here, so the inkwell animation appears
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => function(),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: isLoading == true
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white))
                : Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }
}
