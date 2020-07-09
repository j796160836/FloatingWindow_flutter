# FloatingWindow (Flutter)

A Flutter written floating window view for Android & iOS.

## Screenshot

### iOS

<img src="https://github.com/j796160836/FloatingWindow_flutter/blob/master/screenshots/flutter_ios.gif?raw=true" width="280" />

### Android

<img src="https://github.com/j796160836/FloatingWindow_flutter/blob/master/screenshots/flutter_android.gif?raw=true" width="280" />

## Usage

Sample code:

```
var floatingWindow = FloatingWindowContainer(
    child: Container(),
    floatingWidget: Container());
```

It have two parameters:

- **child:** Your rest layout will be.  
(Gray background with a button of example layout)
- **floatingWidget:** The layout of draggable floating widget.  
(Yellow background of example layout)

### MarginCalculation

You can define your own `MarginCalculation` max and min margin calculation.  
It provide two calculation method in example code.

- MarginCalculationToEdge

	- **Min left:** 0  
	(Stick to left edge.) 
	- **Min top:** 0  
	(Stick to top edge.) 
	- **Max left:** containerWidth - floatingWindowWidth  
	(Stick to right edge.) 
	- **Max top:** containerHeight - floatingWindowHeight  
	(Stick to bottom edge.)
	
- MyMarginCalculation

	- **Min left:** -floatingWindowWidth + 40  
	(Overflow layout with reveal 40px right stitch)
	- **Min top:** -floatingWindowHeight + 40  
	(Overflow layout with reveal 40px bottom stitch)
	- **Max left:** containerWidth - 40  
	(Overflow layout with reveal 40px left stitch)
	- **Max top:** containerHeight - 40  
	(Overflow layout with reveal 40px top stitch)
	
### setFloatingWindowMargin()

You can move floating window by manual using `setFloatingWindowMargin()` method.

```
void setFloatingWindowMargin(
      {double leftMargin,
      double topMargin,
      bool animated = false,
      void Function() completeCallback}) {
      // ...
}
```

See the sample code for details.


