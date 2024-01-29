import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackButtonn extends StatefulWidget {
  final bool? isActive;

  const BackButtonn({Key? key, this.isActive}) : super(key: key);

  @override
  _BackButtonnState createState() => _BackButtonnState();
}

class _BackButtonnState extends State<BackButtonn> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    if (widget.isActive != null) {
      _isActive = widget.isActive!;
    }
  }

  @override
  void didUpdateWidget(covariant BackButtonn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != null) {
      setState(() {
        _isActive = widget.isActive!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isActive ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: _isActive ? () => context.router.pop() : null,
        child: SvgPicture.asset('assets/shared/back.svg'),
      ),
    );
  }
}
