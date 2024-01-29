import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slots/main.dart';

class Button extends StatefulWidget {
  final Widget child;
  final Function(dynamic)? callback;

  const Button({
    Key? key,
    required this.child,
    this.callback,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    if (widget.callback != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.callback != null) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          widget.callback != null ? widget.callback!('Argument') : null,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: EdgeInsets.only(right: 12.sp, left: 12.sp),
          decoration: BoxDecoration(
              color: widget.callback != null ? accentColor : secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                  color:
                      widget.callback != null ? accentColor : secondaryColor)),
          child: widget.child,
        ),
      ),
    );
  }
}
