import 'package:flutter/material.dart';

class AdvancedFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) onResponse;

  const AdvancedFutureBuilder({Key key, this.future, this.onResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return this.onResponse(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          });
  }
}