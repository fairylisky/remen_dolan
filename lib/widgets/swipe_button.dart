import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SwipeButton extends StatefulWidget {
  final String label;
  final VoidCallback onComplete;

  const SwipeButton({
    super.key,
    required this.label,
    required this.onComplete,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double _dragPosition = 0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxDrag = maxWidth - 58;

        return Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  widget.label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // Swipe Circle
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition += details.delta.dx;

                      if (_dragPosition < 0) {
                        _dragPosition = 0;
                      }

                      if (_dragPosition > maxDrag) {
                        _dragPosition = maxDrag;
                      }
                    });
                  },

                  onHorizontalDragEnd: (_) async {
                    if (_dragPosition > maxDrag * 0.8) {
                      setState(() {
                        _dragPosition = maxDrag;
                        _completed = true;
                      });

                      await Future.delayed(
                        const Duration(milliseconds: 300),
                      );

                      widget.onComplete();
                    } else {
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },

                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}