import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final int selectedIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    required this.selectedIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/books');
        break;
      case 2:
        // Placeholder for settings or other pages
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text(widget.title),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.menu_book, size: 48, color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'Library Manager',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    selected: widget.selectedIndex == 0,
                    onTap: () => _onDestinationSelected(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.library_books),
                    title: const Text('Books'),
                    selected: widget.selectedIndex == 1,
                    onTap: () => _onDestinationSelected(1),
                  ),
                ],
              ),
            ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(Icons.menu_book, size: 40),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books),
                  label: Text('Books'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                if (isDesktop)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: double.infinity,
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
