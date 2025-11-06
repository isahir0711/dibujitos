import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback action;
  final Future? asyncAction;
  final bool isAsync;
  const CustomButton({super.key, this.asyncAction, required this.label, required this.action, this.isAsync = false});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
            ),
            onPressed: !widget.isAsync ? widget.action : () async => {await widget.asyncAction},
            child: Text(widget.label),
          ),
        ),
      ],
    );
  }
}
