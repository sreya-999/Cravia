import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/widgets/app_text_style.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/utlis/widgets/floating_message.dart';
import 'package:ravathi_store/utlis/widgets/loading_circle.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';
import 'package:ravathi_store/views/payment_screen.dart';

import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/dashboard_provider.dart';
import '../service/sync_manager.dart';
import '../utlis/App_color.dart';
import '../utlis/App_style.dart';
import 'package:provider/provider.dart';

import '../utlis/widgets/snack_bar.dart';


class TableSelectionScreen extends StatefulWidget {
  final OrderModel? order;
  const TableSelectionScreen({super.key, this.order});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  String? selectedTableId;
  String? selectedTableName;


  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
      Provider.of<DashboardProvider>(context, listen: false);

      categoryProvider.getTable(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<DashboardProvider>(context);
    final tables = tableProvider.table;
    final totalTables = tables?.length ?? 0; // total count
    final availableTables = tables?.where((t) => t.status?.toLowerCase() == 'available').length;

    final isLoading = tableProvider.isLoading;
    final resp = Responsiveness(context);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final double baseFontSize = isTablet ? 20 : 14;
    final double buttonSize = isTablet ? 20 : 18;

    // Flatten tables based on table_count
    // final Map<int, List<Map<String, dynamic>>> tablesBySeater = {};
    // for (final table in tables ?? []) {
    //   final count = int.tryParse(table.tableCount ?? '1') ?? 1;
    //   final seater = int.tryParse(table.seater ?? '2') ?? 2;
    //   final list = tablesBySeater.putIfAbsent(seater, () => []);
    //   for (int i = 0; i < count; i++) {
    //     list.add({
    //       'id': table.id,
    //       'uniqueId': "${table.id}_$i",
    //       'seater': seater,
    //     });
    //   }
    // }
    final Map<int, List<Map<String, dynamic>>> tablesBySeater = {};
    for (final table in tables ?? []) {
      final count = int.tryParse(table.tableCount ?? '1') ?? 1;
      final seater = int.tryParse(table.seater ?? '2') ?? 2;

      final list = tablesBySeater.putIfAbsent(seater, () => []);

      for (int i = 0; i < count; i++) {
        list.add({
          'id': table.id,
          'uniqueId': "${table.id}_$i",
          'seater': seater,
          'table_name': table.tableCount, // <- add this!
          'status': table.status ,
        });
      }
    }

    // Sort seater types ascending
    final seaterTypes = tablesBySeater.keys.toList()..sort();


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Table Availability',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035),
        child: isLoading
            ?  Center(child: LoadingCircle())
            : (tables == null || tables.isEmpty)
            ?  Center(child: Text("No tables available", style: AppStyle.textStyleReemKufi.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.greyColor,
          fontSize: 18,
          height: 1.0, // remove extra line height
        ),))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),

              // Header Row
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/spoon.svg",
                    height: resp.isDesktop
                        ? 22
                        : resp.isTablet
                        ? 18
                        : 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Choose your table',
                    style: AppTextStyles.nunitoMedium(
                      resp.isDesktop ? 25 : resp.isTablet ? 20 : 18,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.025),

              // Legend
              Row(
                children: [
                  _buildLegend(const Color(0xFF21B05D), 'Available', resp),
                  const SizedBox(width: 20),
                  _buildLegend(const Color(0xFFE31E24), 'Occupied', resp),
                  Spacer(),
                  _buildLegend(const Color(0xFF21B05D),  '$availableTables Free / $totalTables Total Tables', resp),

                ],
              ),

              SizedBox(height: height * 0.03),

              // Horizontal scroll for columns
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: seaterTypes.map((seater) {
                    final tableList = tablesBySeater[seater] ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        children: tableList.map((table) {
                          final uniqueId = table['uniqueId'] ?? '';
                          final tableName = table['table_name']?.toString() ?? '';
                          final seaterCount = table['seater'] ?? 0;
                          final tableStatus = table['status']?.toString().toLowerCase() ?? 'available';

                          final isSelected = selectedTableId == uniqueId;
                          final isAvailable = tableStatus == 'available';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (isAvailable) {
                                  // Table is available → normal selection
                                  setState(() {
                                    if (isSelected) {
                                      selectedTableId = null;
                                      selectedTableName = null; // reset
                                    } else {
                                      selectedTableId = uniqueId;
                                      selectedTableName = tableName; // store table name
                                    }
                                  });

                                  if (!isSelected) {
                                    final tableProviderCart =
                                    Provider.of<CartProvider>(context, listen: false);
                                    tableProviderCart.selectTable(tableName);
                                  }
                                } else {
                                  // Table is reserved → show custom snack
                                  final snackBar = ShowSnackBar();
                                  snackBar.customSnackBar(
                                    context: context,
                                    type: "0", // your type
                                    strMessage: 'This table is reserved',
                                  );
                                }
                              },

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildSeatRow((seaterCount / 2).ceil(), resp),
                                  _buildTableBox(tableName, seaterCount, isSelected, tableStatus, resp),
                                  _buildSeatRow((seaterCount / 2).ceil(), resp),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),




              SizedBox(height: height * 0.03),

              // Confirm & Skip buttons
              Padding(
                padding: EdgeInsets.only(
                    bottom: height * 0.02, top: height * 0.01),
                child: Column(
                  children: [
                ElevatedButton(
                style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(double.infinity, isTablet ? 60 : 50)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(BorderSide(color: AppColor.primaryColor, width: 1)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onPressed: () async {

          if (selectedTableId == null) {

            final snackBar = ShowSnackBar();
            snackBar.customSnackBar(
              context: context,
              type: "0", // your type
              strMessage: 'Please select a table first',
            );
            return;
          }

          await SyncManager.addTable(
            context,
            selectedTableName!,
            widget.order?.orderNo,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PaymentScreen(order: widget.order)),
          );
        },
        child: Text(
          "Confirm & Proceed to Pay",
          style: AppStyle.textStyleReemKufi.copyWith(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: buttonSize,
          ),
        ),
      ),


                 SizedBox(height: 20,)
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (_) => PaymentScreen(order: widget.order)),
                    //     );
                    //   },
                    //   child: Text(
                    //     "Skip table selection",
                    //     style: AppStyle.textStyleReemKufi.copyWith(
                    //       color: Colors.black.withOpacity(0.6),
                    //       fontSize: baseFontSize,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


// ----------------- Helper Widgets -----------------

  Widget _buildLegend(Color color, String text, Responsiveness resp) {
    final responsive = Responsiveness(context);
    return Row(
      children: [
        Container(
          width: resp.isDesktop ? 22 : resp.isTablet ? 14 : 11,
          height: resp.isDesktop ? 22 : resp.isTablet ? 14 : 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.nunitoRegular(
            responsive.time
          ),
        ),
      ],
    );
  }

  Widget _buildSeatRow(int seatCount, Responsiveness resp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          seatCount,
              (i) => Container(
            margin: seatCount > 1
                ? const EdgeInsets.symmetric(horizontal: 5)
                : EdgeInsets.zero,
            width: resp.isDesktop ? 18 : 15,
            height: resp.isDesktop ? 8 : 6,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCBCB),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableBox(
      String id, int seatType, bool isSelected, String status,Responsiveness resp) {
    // final Color borderColor =
    // isSelected ? AppColor.tableGreenColor : AppColor.tableGreenColor;
    Color borderColor;
    if (isSelected) {
      borderColor = AppColor.tableGreenColor; // keep green if selected
    } else if (status.toLowerCase() == 'available') {
      borderColor = Colors.green;
    } else if (status.toLowerCase() == 'reserved') {
      borderColor = Colors.red;
    } else {
      borderColor = Colors.grey;
    }
    // Base width by screen size
    double baseWidth = resp.isDesktop
        ? 240
        : resp.isTablet
        ? 180
        : 130;

    // Adjust based on seatType
    double tableWidthFactor;
    switch (seatType) {
      case 2:
        tableWidthFactor = 0.7;
        break;
      case 4:
        tableWidthFactor = 0.9;
        break;
      case 6:
        tableWidthFactor = 1.1;
        break;
      case 8:
        tableWidthFactor = 1.3;
        break;
      default:
        tableWidthFactor = 0.8;
    }

    final double tableWidth = baseWidth * tableWidthFactor;
    final double tableHeight = resp.isDesktop
        ? 100
        : resp.isTablet
        ? 85
        : 70;
  final responsive = Responsiveness(context);
    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: tableWidth,
            height: tableHeight,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.tableGreenColor.withOpacity(0.4)
                  : Colors.white,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$id',
                  style: AppTextStyles.nunitoMedium(
                    color: Colors.black,
                    responsive.priceTotal
                  ),
                ),
                Text(
                  status.isNotEmpty
                      ? status[0].toUpperCase() + status.substring(1).toLowerCase()
                      : '',
                  style: AppTextStyles.nunitoRegular(
                    color: Colors.black,
                    resp.isDesktop ? 16 : resp.isTablet ? 14 : 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 8,
            left: 4,
            child: SvgPicture.asset(AppImage.tickIcon),
          ),
      ],
    );
  }

}
