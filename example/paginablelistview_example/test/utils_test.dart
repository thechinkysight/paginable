import 'package:flutter_test/flutter_test.dart';
import 'package:paginablelistview_example/utils.dart';

void main() {
  test(
    'Variable `numbers` should have fifteen items in it',
    () => expect(numbers.length, 15),
  );

  test(
    'fetchFiveMore() method should add five more numbers to `numbers` variable',
    () async {
      expect(numbers.length, 15);
      await fetchFiveMore();
      expect(numbers.length, 20);
    },
  );
}
