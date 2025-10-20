import 'package:flutter/material.dart';
import 'package:pos_app/models/user_model.dart';
import 'package:pos_app/screens/auth/login_screen.dart';
import 'package:pos_app/screens/pos/pos_screen.dart';
import 'package:pos_app/screens/product/product_management_screen.dart';
import 'package:pos_app/screens/transaction/transaction_history_screen.dart';
import 'package:pos_app/screens/profile/profile_screen.dart';
import 'package:pos_app/screens/laporan/laporan_screen.dart';
import 'package:pos_app/screens/laporan/grafik_penjualan.dart'; 

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; 
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _dashboard(context),
      const TransactionHistoryScreen(),
      ProfileScreen(user: _currentUser),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Transactions'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PosScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _dashboard(BuildContext context) {
    final dailyRevenueMaps = [
      {'daily_revenue': 50000},
      {'daily_revenue': 75000},
      {'daily_revenue': 100000},
      {'daily_revenue': 30000},
      {'daily_revenue': 120000},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${_currentUser.fullname}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.point_of_sale,
                  label: 'Transaksi Baru',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PosScreen()),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.inventory,
                  label: 'Manajemen Produk',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.history,
                  label: 'Riwayat Transaksi',
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.bar_chart,
                  label: 'Laporan Hari Ini',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LaporanScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Grafik Penjualan Harian",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: DailySalesChart(dailyRevenueMaps: dailyRevenueMaps),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _openProfile() async {
    final updated = await Navigator.push<User?>(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user: _currentUser)),
    );
    if (updated != null) {
      setState(() {
        _currentUser = updated;
      });
    }
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
