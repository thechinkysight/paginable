[![pub package](https://img.shields.io/pub/v/paginable.svg)](https://pub.dev/packages/paginable)
![CI](https://github.com/chinkysight/paginable/actions/workflows/ci.yml/badge.svg?branch=main)
[![codecov](https://codecov.io/gh/chinkysight/paginable/branch/main/graph/badge.svg?token=U0JWJRAQOJ)](https://codecov.io/gh/chinkysight/paginable)

Paginable is a Flutter package which makes pagination easier.

## Paginable Widgets

- `PaginableListView` is paginable's version of [`ListView`](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html) without default constructor.
- `PaginableCustomScrollView` is paginable's version of [`CustomScrollView`](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html)
- `PaginableSliverChildBuilderDelegate` is paginable's version of [`SliverChildBuilderDelegate`](https://api.flutter.dev/flutter/widgets/SliverChildBuilderDelegate-class.html)

## Usage

### Using `PaginableListView`

As I mentioned earlier, this widget is just a paginable's version of `ListView` without a default constructor. Although it does not have a default constructor, it has two named constructors, `PaginableListView.builder()` and `PaginableListView.separated()`

#### Using `PaginableListView.builder()`

This is the paginable's version of [`ListView.builder`](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)

```dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaginableListView'),
        ),
        body: PaginableListView.builder(
            loadMore: () async {},
            errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
            progressIndicatorWidget: const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      index.toString(),
                    ),
                  ),
                ),
            itemCount: 20),
      ),
    );
  }
}
```

- `loadMore` takes an async function which will be executed when the scroll is almost at the end.

  ```dart
  loadMore: () async {}
  ```

- `errorIndicatorWidget` also takes a function which contains two parameters, one being of type `Exception` and other being a `Function()`, returning a widget which will be displayed at the bottom of the scrollview when an exception occurs in the async function which we passed to the `loadMore` parameter. The parameter with type `Exception` will contain the exception which occured while executing the function passed to the parameter `loadMore` if exception occured and the parameter with type `Function()` will contain the same function which we passed to the `loadMore` parameter.

  ```dart
  errorIndicatorWidget: (exception, tryAgain) => Container(
    color: Colors.redAccent,
    height: 130,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          exception.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 16.0,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.green),
          ),
          onPressed: tryAgain,
          child: const Text('Try Again'),
        ),
      ],
    ),
  )
  ```

- `progressIndicatorWidget` takes a widget which will be displayed at the bottom of the scrollview to indicate the user that the async function we passed to the `loadMore` parameter is being executed.

  ```dart
  progressIndicatorWidget: const SizedBox(
    height: 100,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  )
  ```

#### Using `PaginableListView.separated()`

This is the paginable's version of [`ListView.separated()`](https://api.flutter.dev/flutter/widgets/ListView/ListView.separated.html)

```dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaginableListView'),
        ),
        body: PaginableListView.separated(
            separatorBuilder: (context, index) => const Divider(
                  thickness: 1.2,
                ),
            loadMore: () async {},
            errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
            progressIndicatorWidget: const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      index.toString(),
                    ),
                  ),
                ),
            itemCount: 20),
      ),
    );
  }
}
```

- `separatorBuilder` takes a function which returns a widget and that widget only appears between list items that is why it is called separator.

  ```dart
  separatorBuilder: (context, index) => const Divider(thickness: 1.2)
  ```

### Using `PaginableCustomScrollView` with `PaginableSliverChildBuilderDelegate`

Paginable also supports [SliverList](https://api.flutter.dev/flutter/widgets/SliverList-class.html), but instead of using `CustomScrollView` one need to use `PaginableCustomScrollView` along with `PaginableSliverChildBuilderDelegate` as the delegate.

In order to use the `PaginableSliverChildBuilderDelegate`, one need to use one of the two methods provided by `PaginableSliverChildBuilderDelegate`, which are `build()` and `separated()`.

#### Using `build()`

```dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PaginableCustomScrollView(
          loadMore: () async {},
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text('PaginableSliverChildBuilderDelegate'),
            ),
            SliverList(
              delegate: PaginableSliverChildBuilderDelegate(
                (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      index.toString(),
                    ),
                  ),
                ),
                errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
                progressIndicatorWidget: const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                childCount: 20,
              ).build(),
            ),
          ],
        ),
      ),
    );
  }
}
```

  **NOTE:** While using `PaginableCustomScrollView` along with `PaginableSliverChildBuilderDelegate`, the `loadMore` function is situated inside the `PaginableCustomScrollView`, the `errorIndicatorWidget` and `progressIndicatorWidget` are situated inside the `PaginableSliverChildBuilderDelegate`. It is mandatory to call the `build()` on `PaginableSliverChildBuilderDelegate` because it returns a `SliverChildBuilderDelegate`.

#### Using `separated()`

```dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PaginableCustomScrollView(
          loadMore: () async {},
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text('PaginableSliverChildBuilderDelegate'),
            ),
            SliverList(
              delegate: PaginableSliverChildBuilderDelegate(
                (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      index.toString(),
                    ),
                  ),
                ),
                errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
                progressIndicatorWidget: const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                childCount: 20,
              ).separated(
                (context, index) => const Divider(
                  thickness: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

  **NOTE:** The `separated()` method takes a function which returns a widget which is a separator.

### Worth Noting

Paginable is only resposible for executing the async function passed to the `loadMore` parameter when the scroll is almost at the end, displaying `errorIndicatorWidget` at the bottom of the scrollview when an exception occurs in the `loadMore` and displaying `progressIndicatorWidget` at the bottom of the scrollview to indicate the user that the `loadMore` is being executed.

Paginable is not resposible for managing states, to know about different ways of managing states in Flutter, [https://flutter.dev/docs/development/data-and-backend/state-mgmt/options](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)

## Contribution

If you would like to contribute to the package (e.g. by improving the documentation, fixing a bug or adding some cool new features), you are welcomed and very much appreciated to send me your pull request and if you find something wrong with the package, please feel free to open an [issue](https://github.com/chinkysight/paginable/issues).
