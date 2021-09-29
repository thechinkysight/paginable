Paginable is a Flutter package which makes pagination easier.

<p>
  <img src="https://github.com/chinkysight/paginable/blob/main/doc_assets/PaginableListViewBuilder.gif?raw=true"
    alt="An animated image of the PaginableListViewBuilder" height="500"/>
  <img src="https://github.com/chinkysight/paginable/blob/main/doc_assets/PaginableListViewBuilder_Error.gif?raw=true"
   alt="An animated image of the PaginableListViewBuilder with error" height="500"/>
   <img src="https://github.com/chinkysight/paginable/blob/main/doc_assets/PaginableSliverChildBuilderDelegate.gif?raw=true"
    alt="An animated image of the PaginableListViewBuilder" height="500"/>
  <img src="https://github.com/chinkysight/paginable/blob/main/doc_assets/PaginableSliverChildBuilderDelegate_Error.gif?raw=true"
   alt="An animated image of the PaginableListViewBuilder with error" height="500"/>
</p>

## Paginable Widgets

- `PaginableListViewBuilder` is paginable's version of [`ListView.builder`](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- `PaginableCustomScrollView` is paginable's version of [`CustomScrollView`](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html)
- `PaginableSliverChildBuilderDelegate` is paginable's version of [`SliverChildBuilderDelegate`](https://api.flutter.dev/flutter/widgets/SliverChildBuilderDelegate-class.html)

## Usage

### Using `PaginableListViewBuilder`

As I mentioned earlier, this widget is just a paginable's version of `ListView.builder` which provides only three more parameters.

```dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaginableListViewBuilder'),
        ),
        body: PaginableListViewBuilder(
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
- `errorIndicatorWidget` also takes a function which contains two parameters, one being of type `Exception` and other being a `Function()`, returning a widget which will be displayed at the bottom of the scrollview when an exception occurs in the async function which we passed to the `loadMore` parameter. The parameter with type `Exception` will contain the exception which occured while executing the function passed to the parameter `loadMore` if exception occured and the parameter with type `Function()` will contain the same function which we passed to the `loadMore` parameter.
- `progressIndicatorWidget` takes a widget which will be displayed at the bottom of the scrollview to indicate the user that the async function we passed to the `loadMore` parameter is being executed.

### Using `PaginableCustomScrollView` with `PaginableSliverChildBuilderDelegate`

Paginable also supports [SliverList](https://api.flutter.dev/flutter/widgets/SliverList-class.html), but instead of using `CustomScrollView` one need to use `PaginableCustomScrollView` along with `PaginableSliverChildBuilderDelegate` as the delegate.

```dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PaginableCustomScrollView(
          loadMore: () async {},
          slivers: [
            const SliverAppBar(
              title: Text('PaginableSliverChildBuilderDelegate'),
              floating: true,
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
                childCount: 20,
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
              ).build(),
            ),
          ],
        ),
      ),
    );
  }
}
```

You might miss that the parameter `loadMore` is in `PaginableCustomScrollView`, the rest two `errorIndicatorWidget` & `progressIndicatorWidget` are in `PaginableSliverChildBuilderDelegate` and we are calling `build()` on `PaginableSliverChildBuilderDelegate`. It is mandatory to call `build()` on `PaginableSliverChildBuilderDelegate` because it returns a `SliverChildBuilderDelegate`.

> It is worth noting that Paginable is only resposible for executing the async function passed to the `loadMore` parameter when the scroll is almost at the end, displaying `errorIndicatorWidget` at the bottom of the scrollview when an exception occurs in the `loadMore` and displaying `progressIndicatorWidget` at the bottom of the scrollview to indicate the user that the `loadMore` is being executed.
>
> Paginable is not resposible for managing states, to know about different ways of managing states in Flutter, [https://flutter.dev/docs/development/data-and-backend/state-mgmt/options](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)

## Examples

- [Using `PaginableListViewBuilder`](https://github.com/chinkysight/paginable/tree/main/example/paginablelistviewbuilder_example)
- [Using `PaginableCustomScrollView` with `PaginableSliverChildBuilderDelegate`](https://github.com/chinkysight/paginable/tree/main/example/paginablesliverchildbuilderdelegate_example)

## Contribution

If you would like to contribute to the package (e.g. by improving the documentation, solving a bug or adding a cool new feature), you are welcomed and very much appreciated to send us your pull request and if you find something wrong with the package, please feel free to open an [issue](https://github.com/chinkysight/paginable/issues).
