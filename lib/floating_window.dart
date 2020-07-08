import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class FloatingWindowContainer extends StatefulWidget {
  static _FloatingWindowContainerState of(BuildContext context) =>
      context.findAncestorStateOfType<_FloatingWindowContainerState>();

  Widget childWidget;
  Widget floatingWidget;
  MarginCalculation marginCalculation = MarginCalculationToEdge();

  FloatingWindowContainer({Widget child, Widget floatingWidget}) {
    this.childWidget = child;
    this.floatingWidget = floatingWidget;
  }

  void setMarginCalculation(MarginCalculation marginCalculation) {
    this.marginCalculation = marginCalculation;
  }

  void setFloatingWindowMargin(BuildContext context,
      {double leftMargin,
      double topMargin,
      bool animated = false,
      void Function() completeCallback}) {
    var state = FloatingWindowContainer.of(context);
    if (state != null) {
      state.setFloatingWindowMargin(
          leftMargin: leftMargin,
          topMargin: topMargin,
          animated: animated,
          completeCallback: completeCallback);
    } else {
      throw Exception("Error: cannot find the right context.");
    }
  }

//  _FloatingWindowContainerState state = new _FloatingWindowContainerState();
//
//  @override
//  _FloatingWindowContainerState createState() => state;

  @override
  _FloatingWindowContainerState createState() =>
      new _FloatingWindowContainerState();
}

class _FloatingWindowContainerState extends State<FloatingWindowContainer>
    with TickerProviderStateMixin {
  double topMargin = 0;
  double leftMargin = 0;

  GlobalKey _keyContainer = GlobalKey();
  GlobalKey _keyFloatingWidget = GlobalKey();

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: _keyContainer,
        child: Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: [
              widget.childWidget,
              Positioned(
                top: topMargin,
                left: leftMargin,
                child: GestureDetector(
                  onPanStart: (drag) {},
                  onPanUpdate: (drag) {
                    setState(() {
                      Offset pos = drag.delta;
                      final widgetSize = getFloatingWidgetSize();
                      final containerSize = getContainerSize();

                      var newLeftMargin = (leftMargin + pos.dx);
                      var newTopMargin = (topMargin + pos.dy);

                      var cal = widget.marginCalculation;

                      var minLeft = cal.getMinLeftMargin(
                          containerWidth: containerSize.width,
                          floatingWindowWidth: widgetSize.width);
                      var minTop = cal.getMinTopMargin(
                          containerHeight: containerSize.height,
                          floatingWindowHeight: widgetSize.height);
                      newLeftMargin =
                          (newLeftMargin <= minLeft) ? minLeft : newLeftMargin;
                      newTopMargin =
                          (newTopMargin <= minTop) ? minTop : newTopMargin;
                      var maxLeft = cal.getMaxLeftMargin(
                          containerWidth: containerSize.width,
                          floatingWindowWidth: widgetSize.width);
                      var maxTop = cal.getMaxTopMargin(
                          containerHeight: containerSize.height,
                          floatingWindowHeight: widgetSize.height);
                      newLeftMargin =
                          (newLeftMargin >= maxLeft) ? maxLeft : newLeftMargin;
                      newTopMargin =
                          (newTopMargin >= maxTop) ? maxTop : newTopMargin;

                      leftMargin = newLeftMargin;
                      topMargin = newTopMargin;
                    });
                  },
                  child: Container(
                    key: _keyFloatingWidget,
                    child: widget.floatingWidget,
                  ),
                ),
              )
            ]));
  }

  Size getFloatingWidgetSize() {
    final RenderBox renderBox =
        _keyFloatingWidget.currentContext.findRenderObject();
    return renderBox.size;
  }

  Size getContainerSize() {
    final RenderBox renderBox = _keyContainer.currentContext.findRenderObject();
    return renderBox.size;
  }

  void setFloatingWindowMargin(
      {double leftMargin,
      double topMargin,
      bool animated = false,
      void Function() completeCallback}) {
    if (animated) {
      if (_animationController != null) {
        _animationController.dispose();
        _animationController = null;
      }
      _animationController = new AnimationController(
          duration: const Duration(milliseconds: 600), vsync: this);
      _animation = new Tween(begin: 0.0, end: 1.0).animate(_animationController)
        ..addListener(() {
          double originalTop = this.topMargin;
          double originalLeft = this.leftMargin;
          setState(() {
            this.topMargin =
                originalTop + (topMargin - originalTop) * _animation.value;
            this.leftMargin =
                originalLeft + (leftMargin - originalLeft) * _animation.value;
          });
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (completeCallback != null) {
              completeCallback.call();
            }
          }
        });
      _animationController.forward();
    } else {
      setState(() {
        this.topMargin = topMargin;
        this.leftMargin = leftMargin;
        if (completeCallback != null) {
          completeCallback.call();
        }
      });
    }
  }
}

abstract class MarginCalculation {
  double getMinLeftMargin({double containerWidth, double floatingWindowWidth});

  double getMinTopMargin({double containerHeight, double floatingWindowHeight});

  double getMaxLeftMargin({double containerWidth, double floatingWindowWidth});

  double getMaxTopMargin({double containerHeight, double floatingWindowHeight});
}

class MarginCalculationToEdge extends MarginCalculation {
  @override
  double getMinLeftMargin({double containerWidth, double floatingWindowWidth}) {
    return 0;
  }

  @override
  double getMinTopMargin(
      {double containerHeight, double floatingWindowHeight}) {
    return 0;
  }

  @override
  double getMaxLeftMargin({double containerWidth, double floatingWindowWidth}) {
    return containerWidth - floatingWindowWidth;
  }

  @override
  double getMaxTopMargin(
      {double containerHeight, double floatingWindowHeight}) {
    return containerHeight - floatingWindowHeight;
  }
}
