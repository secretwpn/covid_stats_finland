import 'package:flutter/material.dart';

class AdvancedFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) successWidgetBuilder;
  final Widget Function(T) errorWidgetBuilder;

  const AdvancedFutureBuilder({Key key, this.future, this.successWidgetBuilder, this.errorWidgetBuilder})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return this.successWidgetBuilder(snapshot.data);
        } else if (snapshot.hasError) {
          return this.errorWidgetBuilder == null ? Text("${snapshot.error}") : this.errorWidgetBuilder(snapshot.error);
        }
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
