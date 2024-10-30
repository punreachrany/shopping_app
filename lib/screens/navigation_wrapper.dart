import 'package:flutter/material.dart';
import 'package:shopping_app/screens/concerts/concert_list_screen.dart';
import 'package:shopping_app/screens/orders/orders.dart';
import 'package:shopping_app/screens/user_info/user_info.dart';
import 'package:shopping_app/themes/colors.dart';

class NavigationWrapper extends StatefulWidget {
  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int currentTab = 0;
  final List<Widget> screens = [
    ConcertListScreen(), // Home
    OrdersPage(), // Shopping_Cart
    UserDetails(), // Developer
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageStorage(
        bucket: bucket,
        child: screens[currentTab],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // Use spaceAround to distribute evenly
            children: <Widget>[
              _buildNavItem(0, Icons.home, "Home", () {
                setState(() {
                  currentTab = 0;
                });
              }),
              _buildNavItem(1, Icons.shopping_cart, "Cart", () {
                setState(() {
                  currentTab = 1;
                });
              }),
              _buildNavItem(2, Icons.person, "User", () {
                setState(() {
                  currentTab = 2;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each navigation item
  Widget _buildNavItem(
      int index, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      // Use Expanded to allow flexibility
      child: MaterialButton(
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: currentTab == index ? bottomNavigatorColor : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: currentTab == index ? bottomNavigatorColor : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
