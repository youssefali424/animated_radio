import 'dart:math';

import 'package:flutter/material.dart';

import 'oval_painter.dart';

class AnimatedRadio extends StatefulWidget {
  final Color active, inactive;
  final double radius;
  final Color? fill;

  const AnimatedRadio({
    Key? key,
    required this.active,
    required this.inactive,
    this.fill,
    required this.radius,
  }) : super(key: key);

  @override
  State<AnimatedRadio> createState() => _AnimatedRadioState();
}

const Duration duration = Duration(milliseconds: 1000);

class CustomTween extends Tween<double> {
  CustomTween({
    double? begin,
    double? end,
  }) : super(begin: begin, end: end);
  @override
  double transform(double t) {
    if (t < 0.3) {
      return begin ?? 0;
    }
    if (t > .7) {
      return end ?? 1;
    }
    return lerp(t);
  }
}

class _AnimatedRadioState extends State<AnimatedRadio>
    with SingleTickerProviderStateMixin {
  Color get currentColor =>
      Color.lerp(widget.inactive, widget.active, colorAnimation.value)!;
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> colorAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    animation = Tween(
      begin: 0.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const SpringCurve(),
      reverseCurve: const SpringCurve(a: 0.30).flipped,
    ));
    colorAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutExpo,
      reverseCurve: Curves.easeInExpo,
    );
  }

  toggle() {
    if (controller.status == AnimationStatus.reverse ||
        controller.status == AnimationStatus.dismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius,
      width: widget.radius,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    blurStyle: BlurStyle.normal,
                    color: currentColor,
                    spreadRadius: -5.0,
                  )
                ],
              ),
              child: InkWell(
                onTap: toggle,
                enableFeedback: false,
                borderRadius: BorderRadius.circular(widget.radius / 2),
                child: Center(
                    child: FractionallySizedBox(
                  heightFactor: 0.35,
                  widthFactor: 0.35,
                  child: CustomPaint(
                      painter: OvalPainter(
                    percent: 1 - animation.value,
                    color: widget.fill ?? Colors.white,
                  )),
                )),
              ),
            );
          }),
    );
  }
}

class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 5.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}
