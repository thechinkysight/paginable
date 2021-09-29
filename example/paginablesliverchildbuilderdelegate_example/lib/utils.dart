List<int> numbers = List.generate(20, (index) => index);

Future<void> fetchFiveMore() async {
  await Future.delayed(
    const Duration(seconds: 3),
  );

  for (int i = 0; i < 5; i++) {
    numbers.add(numbers.last + 1);
  }
}