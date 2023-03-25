import 'package:flutter/material.dart';

typedef DataLoaderBuilder<T> = Widget Function(BuildContext context, T data);

@immutable
class DataLoader<T> extends StatefulWidget {
  const DataLoader({
    super.key,
    required this.loader,
    required this.builder,
    this.emptyMessage = 'No data',
  });

  final Future<T> loader;
  final DataLoaderBuilder<T> builder;
  final String emptyMessage;

  @override
  State<DataLoader<T>> createState() => _DataLoaderState<T>();
}

class _DataLoaderState<T> extends State<DataLoader<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.loader,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("An error occurred ${snapshot.error}"),
          );
        } else if (snapshot.hasData == false) {
          return Center(child: Text(widget.emptyMessage));
        }
        return widget.builder(context, snapshot.requireData);
      },
    );
  }
}

@immutable
class SliverDataLoader<T> extends StatefulWidget {
  const SliverDataLoader({
    super.key,
    required this.loader,
    required this.sliverBuilder,
    this.emptyMessage = 'No data',
  });

  final Future<T> loader;
  final DataLoaderBuilder<T> sliverBuilder;
  final String emptyMessage;

  @override
  State<SliverDataLoader<T>> createState() => _SliverDataLoaderState<T>();
}

class _SliverDataLoaderState<T> extends State<SliverDataLoader<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.loader,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Text("An error occurred ${snapshot.error}"),
            ),
          );
        } else if (snapshot.hasData == false) {
          return SliverFillRemaining(
            child: Center(child: Text(widget.emptyMessage)),
          );
        }
        return widget.sliverBuilder(context, snapshot.requireData);
      },
    );
  }
}
