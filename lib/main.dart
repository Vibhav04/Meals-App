// ignore_for_file: library_private_types_in_public_api

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import './dummy_data.dart';
import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/filters_screen.dart';
import './models/meal.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  final List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan']! && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: const TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      home: SplashScreen(),
      routes: {
        TabsScreen.routeName: (ctx) => TabsScreen(
              favoriteMeals: _favoriteMeals,
            ),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(
              availableMeals: _availableMeals,
            ),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(
              isFavorite: _isMealFavorite,
              toggleFavorite: _toggleFavorite,
            ),
        FiltersScreen.routeName: (ctx) => FiltersScreen(
              currentFilters: _filters,
              saveFilters: _setFilters,
            ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(
            favoriteMeals: _favoriteMeals,
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  final List<Meal> _favoriteMeals = [];

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset("assets/icon.png"),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'DeliMeals',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.pink,
      nextScreen: TabsScreen(
        favoriteMeals: _favoriteMeals,
      ),
      splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(
        seconds: 1,
      ),
    );
  }
}
