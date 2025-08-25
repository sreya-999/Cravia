import 'package:flutter/material.dart';
import 'package:ravathi_store/providers/cart_provider.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import '../utlis/App_style.dart';
import 'order_success_screen.dart';
import 'package:provider/provider.dart';

class TableSelectionScreen extends StatefulWidget {
  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();

  static Widget _buildLegend(Color color, String label, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(width: fontSize, height: fontSize, color: color),
        const SizedBox(width: 6),
        Text(label,
    style: AppStyle.textStyleReemKufi.copyWith(
    color: AppColor.blackColor,
    fontSize: fontSize * 0.85
    ),),
      ],
    );
  }
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  final List<Map<String, dynamic>> tables = [
    {'name': 'T1', 'status': 'available'},
    {'name': 'T2', 'status': 'occupied'},
    {'name': 'T3', 'status': 'reserved'},
    {'name': 'T4', 'status': 'reserved'},
    {'name': 'T5', 'status': 'available'},
    {'name': 'T6', 'status': 'occupied'},
    {'name': 'T7', 'status': 'reserved'},
    {'name': 'T8', 'status': 'reserved'},
    {'name': 'T9', 'status': 'available'},
    {'name': 'T10', 'status': 'occupied'},
    {'name': 'T11', 'status': 'reserved'},
    {'name': 'T12', 'status': 'available'},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.red;
      case 'reserved':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;

    // Scale values based on screen size
    final double baseFontSize = isTablet ? 18 : 14;
    final double iconSize = isTablet ? 24 : 20;
    final int gridCount = isDesktop ? 6 : (isTablet ? 5 : 4);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Table Availability'),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.table_restaurant, size: iconSize),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  "Choose your table",
                  style: AppStyle.textStyleReemKufi.copyWith(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: baseFontSize + 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "7 Free / 12 Total Table",
                style: AppStyle.textStyleReemKufi.copyWith(
                  color: Colors.grey,
                  fontSize: baseFontSize,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TableSelectionScreen._buildLegend(Colors.green, "Available", baseFontSize),
                TableSelectionScreen._buildLegend(Colors.red, "Occupied", baseFontSize),
                TableSelectionScreen._buildLegend(Colors.yellow, "Reserved", baseFontSize),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: tables.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  mainAxisSpacing: isTablet ? 20 : 16,
                  crossAxisSpacing: isTablet ? 20 : 16,
                  childAspectRatio: isTablet ? 2.6 : 2.8,
                ),
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final statusColor = _getStatusColor(table['status']);

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Only allow selecting available tables
                            if (table['status'] != 'available') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "This table is ${table['status']}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return; // Stop here if not available
                            }

                            final tableProvider = Provider.of<CartProvider>(context, listen: false);

                            setState(() {
                              for (var t in tables) {
                                t['selected'] = false;
                              }
                              table['selected'] = true;
                            });

                            // Store selected table in Provider
                            tableProvider.selectTable(table['name']);
                          },

                          child: Container(
                            width: isTablet ? 24 : 20,
                            height: isTablet ? 24 : 20,
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black26, width: 1),
                            ),
                            child: table['selected'] ?? false
                                ? Icon(Icons.check,
                                size: isTablet ? 18 : 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        SizedBox(width: isTablet ? 10 : 8),
                        Expanded(
                          child: Text(
                            table['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: baseFontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isTablet ? 60 : 50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColor.primaryColor, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => OrderSuccessScreen()),
                // );
              },
              child: Text(
                "Confirm Table",
                style: AppStyle.textStyleReemKufi.copyWith(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: baseFontSize,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                final cartProvider =
                Provider.of<CartProvider>(context,
                    listen: false);
                cartProvider.clearSelection();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: null,)),
                );
              },
              child: Text(
                "Skip table selection",
                style: AppStyle.textStyleReemKufi.copyWith(
                  color: Colors.grey,
                  fontSize: baseFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
