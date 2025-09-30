import 'package:flutter/material.dart';
import 'package:ravathi_store/providers/cart_provider.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';
import '../models/order_model.dart';
import '../utlis/App_image.dart';
import '../utlis/App_style.dart';
import '../utlis/widgets/app_text_style.dart';
import 'order_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableSelectionScreen extends StatefulWidget {
  final OrderModel? order;
  const TableSelectionScreen({Key? key, this.order}) : super(key: key);
  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();

  static Widget _buildLegend(Color color, String label, double size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3), // optional: rounded corners
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.nunitoMedium(
            size, // you can use the same size or a different font size
            color: AppColor.blackColor,
          ),
        ),
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
    final responsive = Responsiveness(context);
    // Scale values based on screen size
    final double baseFontSize = isTablet ? 20 : 14;
    final double buttonSize = isTablet ? 20 : 18;
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
                SvgPicture.asset(
                  AppImage.spoon,
                  height:isTablet ? 35 :20,
                ),
                SizedBox(width: 5,),
                Text(
                  "Choose your table",
                  style: AppTextStyles.nunitoMedium(
                    responsive.mainTitleSize,
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "4 Free / 12 Total Table",
                style: AppStyle.textStyleReemKufi.copyWith(
                  color: Colors.black54,
                  fontSize: baseFontSize,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: widget.order,)),
                );
              },
              child: Text(
                "Confirm Table",
                style: AppStyle.textStyleReemKufi.copyWith(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: buttonSize,
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
                  MaterialPageRoute(builder: (_) => OrderSuccessScreen(order:widget.order,)),
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
