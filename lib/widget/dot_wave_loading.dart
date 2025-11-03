import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../utils/app_color.dart';

class WaveDots extends StatefulWidget {
  final Color? color;

  const WaveDots({super.key, this.color});

  @override
  State<WaveDots> createState() => _WaveDotsState();
}

class _WaveDotsState extends State<WaveDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 11.sp),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DotWidget(
                offset: sin(_controller.value * 2 * pi),
                positiveColor: widget.color ?? AppColors.white,
                negativeColor: widget.color ?? AppColors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 8),
              DotWidget(
                offset: sin((_controller.value * 2 * pi) + pi / 2),
                positiveColor: widget.color ?? AppColors.white,
                negativeColor: widget.color ?? AppColors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 8),
              DotWidget(
                offset: sin((_controller.value * 2 * pi) + pi),
                positiveColor: widget.color ?? AppColors.white,
                negativeColor: widget.color ?? AppColors.white.withOpacity(0.4),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  final double offset;
  final Color positiveColor;
  final Color negativeColor;

  const DotWidget({
    super.key,
    required this.offset,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the position of the dot
    Color currentColor = offset >= 0 ? positiveColor : negativeColor;

    return Transform.translate(
      offset: Offset(0, -offset * 3), // Adjust amplitude (height) of wave here
      child: CircleAvatar(
        radius: 4.0,
        backgroundColor: currentColor, // Use the dynamically determined color
      ),
    );
  }
}
class MovingDotLoader extends StatefulWidget {
  final Duration duration;
  final Color activeColor;
  final Color inactiveColor;

  const MovingDotLoader({
    super.key,
    this.duration = const Duration(milliseconds: 400),
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<MovingDotLoader> createState() => _MovingDotLoaderState();
}

class _MovingDotLoaderState extends State<MovingDotLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: widget.duration * 4)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dotSize = constraints.maxWidth * 0.08; // responsive dot size
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final activeIndex = (_controller.value * 4).floor() % 4;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isActive = index == activeIndex;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: dotSize * 0.4),
                  height: dotSize,
                  width: dotSize,
                  decoration: BoxDecoration(
                    color:
                    isActive ? widget.activeColor : widget.inactiveColor,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}