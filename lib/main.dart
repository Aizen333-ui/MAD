import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MadRestaurantApp());
}

class MadRestaurantApp extends StatelessWidget {
  const MadRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/welcome': (context) => const WelcomePage(),
        '/menu': (context) => const RestaurantMenuPage(),
        '/help': (context) => const HelpPage(), // Program 2 & Task 2
        '/about': (context) => const AboutPage(), // Program 7 & Task 7
        '/profile': (context) => const ProfilePage(), // Program 1 & Task 1
      },
    );
  }
}

class RestaurantDish {
  const RestaurantDish({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  final String name;
  final String description;
  final double price;
  final String image;
}

const _dishes = [
  RestaurantDish(
    name: 'Margherita Pizza',
    description: 'Tomato, mozzarella & fresh basil',
    price: 299,
    image: 'assets/images/margherita.jpg',
  ),
  RestaurantDish(
    name: 'Classic Burger',
    description: 'Grilled beef, cheddar & house sauce',
    price: 349,
    image: 'assets/images/burger.jpg',
  ),
  RestaurantDish(
    name: 'Creamy Alfredo Pasta',
    description: 'Fettuccine in a parmesan cream sauce',
    price: 329,
    image: 'assets/images/pasta.jpg',
  ),
  RestaurantDish(
    name: 'Crispy Chicken',
    description: 'Golden fried chicken with herb fries',
    price: 399,
    image: 'assets/images/chicken.jpg',
  ),
  RestaurantDish(
    name: 'Garden Salad',
    description: 'Seasonal greens, avocado & lemon dressing',
    price: 249,
    image: 'assets/images/salad.jpg',
  ),
  RestaurantDish(
    name: 'Chocolate Brownie',
    description: 'Warm chocolate brownie with vanilla cream',
    price: 179,
    image: 'assets/images/brownie.jpg',
  ),
];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('restaurant_user');

    var isValidLogin = false;

    if (savedUser != null) {
      final user = jsonDecode(savedUser) as Map<String, dynamic>;
      isValidLogin =
          user['email'] == _emailController.text.trim().toLowerCase() &&
              user['password'] == _passwordController.text;
    }

    if (!mounted) return;

    if (isValidLogin) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      setState(() {
        _errorMessage = 'Email or password is incorrect';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.trim().contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _login,
                    child: const Text('Log in'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: const Text('Create an account'),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'restaurant_user',
      jsonEncode({
        'email': _emailController.text.trim().toLowerCase(),
        'password': _passwordController.text,
      }),
    );

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.trim().contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    final password = value ?? '';

                    if (password.length < 6) return 'Use at least 6 characters';
                    if (!RegExp(r'[A-Z]').hasMatch(password)) {
                      return 'Include an uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(password)) {
                      return 'Include a lowercase letter';
                    }
                    if (!RegExp(r'\d').hasMatch(password)) return 'Include a number';
                    if (!RegExp(r'[^A-Za-z0-9\s]').hasMatch(password)) {
                      return 'Include a special character';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _signup,
                    child: const Text('Sign up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/menu');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.restaurant, size: 72, color: Colors.deepOrange),
              const SizedBox(height: 24),
              Text(
                'Welcome to MAD Restaurant!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Loading your delicious menu...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({super.key});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  final Set<int> _selectedDishIndices = {};
  int _currentNavIndex = 0;
  String _userEmail = 'customer@example.com';
  String? _selectedCustomerName;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('restaurant_user');
    if (savedUser != null) {
      final user = jsonDecode(savedUser) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _userEmail = user['email'] ?? _userEmail;
        });
      }
    }
  }

  void _orderSelectedDish() async {
    if (_selectedDishIndices.isEmpty) return;

    // Bonus & Task 8: Return Data from a Screen (Select Customer Name)
    final selectedName = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerSelectionPage(),
      ),
    );

    if (selectedName != null && mounted) {
      setState(() {
        _selectedCustomerName = selectedName;
      });
    }

    if (!mounted) return;

    final customerMsg = _selectedCustomerName != null
        ? 'Order placed for $_selectedCustomerName!'
        : 'Your food has been ordered!';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(customerMsg),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

    setState(_selectedDishIndices.clear);
  }

  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _openPage(Widget page) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedDishIndices.length;
    final totalPrice = _selectedDishIndices.fold<double>(
      0,
      (total, index) => total + _dishes[index].price,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // Program 7 & Task 7: Side Drawer with Menu items & About item
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_selectedCustomerName ?? 'Restaurant Customer'),
              accountEmail: Text(_userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 35, color: Colors.deepOrange),
              ),
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Menu'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => _openPage(const ProfilePage()), // Task 1
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () => _openPage(const HelpPage()), // Task 2
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _openPage(const AboutPage()), // Task 7
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                children: [
                  Text(
                    'Our Menu',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  for (var index = 0; index < _dishes.length; index++)
                    _DishTile(
                      dish: _dishes[index],
                      selected: _selectedDishIndices.contains(index),
                      onTap: () {
                        setState(() {
                          if (!_selectedDishIndices.add(index)) {
                            _selectedDishIndices.remove(index);
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: selectedCount == 0 ? null : _orderSelectedDish,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(
                    selectedCount == 0
                        ? 'Select dishes to order'
                        : 'Order $selectedCount '
                            '${selectedCount == 1 ? 'dish' : 'dishes'} · '
                            'Rs. ${totalPrice.toStringAsFixed(0)}',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Program 5 & Task 5: FloatingActionButton displaying custom SnackBar message
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Special Chef Offer added! 🍕'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.local_offer),
      ),
      // Program 4 & Task 4: BottomNavigationBar with automatic revert to Menu (0) on return
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
          if (index == 0) {
            setState(() => _currentNavIndex = 0);
            return;
          }
          setState(() => _currentNavIndex = index);

          if (index == 1) {
            await Navigator.pushNamed(context, '/help');
          } else if (index == 2) {
            await Navigator.pushNamed(context, '/about');
          } else if (index == 3) {
            await Navigator.pushNamed(context, '/profile'); // Task 4: Profile tab
          }

          if (mounted) {
            setState(() => _currentNavIndex = 0);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // Practice Task 4
          ),
        ],
      ),
    );
  }
}

class _DishTile extends StatelessWidget {
  const _DishTile({
    required this.dish,
    required this.selected,
    required this.onTap,
  });

  final RestaurantDish dish;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Program 3 & Task 3: Open Detail Screen with Hero animation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishDetailPage(dish: dish),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Program 3 & Task 3: Hero animation on dish image
                Hero(
                  tag: dish.name,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      dish.image,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 76,
                        height: 76,
                        color: Colors.deepOrange.shade100,
                        child: const Icon(Icons.restaurant, color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dish.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Rs. ${dish.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: selected,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

// Program 3 & Practice Task 3: Dish Detail Page with Hero Animation
class DishDetailPage extends StatelessWidget {
  final RestaurantDish dish;
  const DishDetailPage({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: dish.name,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    dish.image,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 220,
                      height: 220,
                      color: Colors.deepOrange.shade100,
                      child: const Icon(Icons.restaurant, size: 80, color: Colors.deepOrange),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                dish.name,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                dish.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Price: Rs. ${dish.price.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Program 1 & Practice Task 1: Profile Screen
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Restaurant Customer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('customer@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Program 2 & Practice Task 2: Help Route Screen
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Need help with your order?\nContact us at support@madrestaurant.com',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// Program 7 & Practice Task 7: About Screen
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Screen')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, size: 72, color: Colors.deepOrange),
              SizedBox(height: 16),
              Text('MAD Restaurant App v1.0', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Delicious food delivered right to your table.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// Bonus Example & Practice Task 8: Return Data from a Screen
class CustomerSelectionPage extends StatelessWidget {
  const CustomerSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final names = ['Alice', 'Bob', 'Charlie', 'Family Table'];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Customer Name')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          final name = names[index];
          return ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(name),
            onTap: () {
              // Navigator.pop returns selected name value to calling screen
              Navigator.pop(context, name);
            },
          );
        },
      ),
    );
  }
}
