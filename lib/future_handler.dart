import 'package:flutter/material.dart';

class FutureHandler<T> extends StatelessWidget {
  const FutureHandler({super.key, required this.future, required this.callback});

  final Future<T>? future;
  final Widget Function(T data) callback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16.0),
                  Text(
                    'Ups... coś poszło nie tak',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'W trakcie ładowania zawartości wystąpił błąd, spróbuj ponownie później.',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          case ConnectionState.none:
          case ConnectionState.done:
            return callback(snapshot.data as T);
        }
      },
    );
  }
}
