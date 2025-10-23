import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({required this.allMeals, super.key});
  final List<Meal> allMeals;

  @override
  ConsumerState<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Meal> searchedMeals = [];

  @override
  void initState() {
    searchedMeals = widget.allMeals;
    _controller.addListener(_onSearch);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearch);
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    _search(_controller.text);
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        searchedMeals = widget.allMeals;
      } else {
        searchedMeals = widget.allMeals
            .where((meal) =>
                meal.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  suffixIcon: TextButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      child: const Text('Reset'))),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: searchedMeals.isEmpty
                    ? const Text('No meals found. Sorry!')
                    : ListView.builder(
                        itemCount: searchedMeals.length,
                        itemBuilder: (ctx, index) => MealItem(
                          meal: searchedMeals[index],
                          onSelectMeal: (meal) {
                            selectMeal(context, meal);
                          },
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
