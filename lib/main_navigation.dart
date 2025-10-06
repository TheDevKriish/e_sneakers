import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selected = 0;
  static final pages = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
