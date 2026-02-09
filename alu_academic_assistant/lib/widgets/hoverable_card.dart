import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HoverableCard extends StatefulWidget {
  final Widget child;
  final Color? glowColor;

  const HoverableCard({super.key, required this.child, this.glowColor});

  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (widget.glowColor ?? ALUColors.accentYellow)
                      .withOpacity(0.4 * _animation.value),
                  blurRadius: 20 * _animation.value,
                  spreadRadius: 2 * _animation.value,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
