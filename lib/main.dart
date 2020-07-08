import 'package:flutter/material.dart';

import 'floating_window.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Window Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Floating Window Demo"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var floatingWindow = FloatingWindowContainer(
        child: Container(
            color: Color.fromARGB(255, 240, 240, 240), // #C0C0C0
            child: Center(
              child: Builder(builder: (context) {
                return RaisedButton(
                    child: Text('Move to bottom-right'),
                    onPressed: () {
                      var state = FloatingWindowContainer.of(context);
                      state.setFloatingWindowMargin(
                          leftMargin: state.getContainerSize().width - 40,
                          topMargin: state.getContainerSize().height -
                              state.getFloatingWidgetSize().height -
                              60,
                          animated: true,
                          completeCallback: () {
                            print("Complete!");
                          });
                    });
              }),
            )),
        floatingWidget: FloatingWindow());
    floatingWindow.marginCalculation = MyMarginCalculation();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: floatingWindow,
      ),
    );
  }
}

class FloatingWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 240,
        height: 128,
        color: Color.fromARGB(255, 255, 204, 0), // #FFCC00
        child: Center(
            child: Text("Floating window.\nDrag me!",
                textAlign: TextAlign.center)));
  }
}

class MyMarginCalculation extends MarginCalculation {
  @override
  double getMinLeftMargin({double containerWidth, double floatingWindowWidth}) {
    return -floatingWindowWidth + 40;
  }

  @override
  double getMinTopMargin(
      {double containerHeight, double floatingWindowHeight}) {
    return -floatingWindowHeight + 40;
  }

  @override
  double getMaxLeftMargin({double containerWidth, double floatingWindowWidth}) {
    return containerWidth - 40;
  }

  @override
  double getMaxTopMargin(
      {double containerHeight, double floatingWindowHeight}) {
    return containerHeight - 40;
  }
}
