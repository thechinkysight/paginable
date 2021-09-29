import 'package:flutter_test/flutter_test.dart';
import 'package:paginablesliverchildbuilderdelegate_example/utils.dart';

void main() {
  test('Variable `numbers` should have twenty items in it',
      () => expect(numbers.length, 20));

  test(
    'fetchFiveMore() method should add five more numbers to `numbers` variable',
    () async {
      expect(numbers.length, 20);
      await fetchFiveMore();
      expect(numbers.length, 25);
    },
  );
}