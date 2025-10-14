import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/App_style.dart';
import 'package:ravathi_store/utlis/widgets/app_text_style.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/utlis/widgets/loading_circle.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';
import 'package:ravathi_store/views/payment_screen.dart';

import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/dashboard_provider.dart';
import '../service/sync_manager.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.getTable(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<DashboardProvider>(context);
    final tables = tableProvider.table;
    final isLoading = tableProvider.isLoading;
    final resp = Responsiveness(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final double buttonWidth = width * 0.87; // 2% less than screen width
    final double buttonHeight = isTablet ? 60 : 50;

    final totalTables = tables?.length ?? 0;
    final availableTables =
        tables?.where((t) => t.status?.toLowerCase() == 'available').length;

    // ✅ Group tables by seater
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
          'table_name': table.tableCount,
          'status': table.status,
        });
      }
    }

    final seaterTypes = tablesBySeater.keys.toList()..sort();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Table Availability',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? width * 0.05 : width * 0.035,
        ),
        child: isLoading
            ?  Center(child: LoadingCircle())
            : (tables == null || tables.isEmpty)
            ? Center(
          child: Text(
            "No tables available",
            style: AppStyle.textStyleReemKufi.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColor.greyColor,
              fontSize: isTablet ? 22 : 16,
            ),
          ),
        )
            : LayoutBuilder(builder: (context, constraints) {
          // Scale factor for tablet & desktop
          double scaleFactor = 1.0;
          if (resp.isTablet) scaleFactor = 1.2;
          if (resp.isDesktop) scaleFactor = 1.5;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Transform.scale(
              scale: scaleFactor,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.03),
                  Padding(
                    padding: isTablet
                        ? const EdgeInsets.only(left: 33.0, right: 40) // tablet-specific
                        : EdgeInsets.symmetric(horizontal: width * 0.015), // default for mobile/desktop
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Center the title row
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/spoon.svg",
                          height: resp.isTablet ? 22 : 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Choose your table',
                          style: AppTextStyles.nunitoMedium(
                            resp.isTablet ? 22 : 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  Padding(
                    padding: isTablet
                        ? const EdgeInsets.only(left: 33.0, right: 40) // tablet-specific
                        : EdgeInsets.symmetric(horizontal: width * 0.015), // default for mobile/desktop
                    child: Row(
                      children: [
                        _buildLegend(
                            const Color(0xFF21B05D), 'Available', resp),
                        const SizedBox(width: 20),
                        _buildLegend(
                            const Color(0xFFE31E24), 'Occupied', resp),
                        const Spacer(),
                        _buildLegend(
                          const Color(0xFF21B05D),
                          '$availableTables Free / $totalTables Total',
                          resp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.04),

                  /// ✅ Table Layout
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: seaterTypes.map((seater) {
                        final tableList =
                            tablesBySeater[seater] ?? [];

                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Column(
                            children: tableList.map((table) {
                              final uniqueId =
                                  table['uniqueId'] ?? '';
                              final tableName = table['table_name']
                                  ?.toString() ??
                                  '';
                              final seaterCount =
                                  table['seater'] ?? 0;
                              final tableStatus = table['status']
                                  ?.toString()
                                  .toLowerCase() ??
                                  'available';

                              final isSelected =
                                  selectedTableId == uniqueId;
                              final isAvailable =
                                  tableStatus == 'available';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (isAvailable) {
                                      setState(() {
                                        if (isSelected) {
                                          selectedTableId = null;
                                          selectedTableName = null;
                                        } else {
                                          selectedTableId = uniqueId;
                                          selectedTableName =
                                              tableName;
                                        }
                                      });
                                      if (!isSelected) {
                                        final tableProviderCart =
                                        Provider.of<CartProvider>(
                                            context,
                                            listen: false);
                                        tableProviderCart
                                            .selectTable(tableName);
                                      }
                                    } else {
                                      ShowSnackBar().customSnackBar(
                                        context: context,
                                        type: "0",
                                        strMessage:
                                        'This table is reserved',
                                      );
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildSeatRow(
                                          (seaterCount / 2).ceil(),
                                          resp),
                                      _buildTableBox(
                                          tableName,
                                          seaterCount,
                                          isSelected,
                                          tableStatus,
                                          resp),
                                      _buildSeatRow(
                                          (seaterCount / 2).ceil(),
                                          resp),
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

                  SizedBox(height: height * 0.06),

                  /// ✅ Confirm Button
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(buttonWidth, buttonHeight),
                      ),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.white),
                      side: MaterialStateProperty.all(BorderSide(
                          color: AppColor.primaryColor, width: 1.2)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (selectedTableId == null) {
                        ShowSnackBar().customSnackBar(
                          context: context,
                          type: "0",
                          strMessage:
                          'Please select a table first.',
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
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentScreen(order: widget.order),
                        ),
                      );
                    },
                    child: Text(
                      "Confirm & Proceed to Pay",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: resp.priceTotal
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ----------------- Helper Widgets -----------------
  Widget _buildLegend(Color color, String text, Responsiveness resp) {
    return Row(
      children: [
        Container(
          width: resp.isTablet ? 16 : 11,
          height: resp.isTablet ? 16 : 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.nunitoRegular(resp.isTablet ? 14 : 12),
        ),
      ],
    );
  }

  Widget _buildSeatRow(int seatCount, Responsiveness resp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          seatCount,
              (i) => Container(
            margin: seatCount > 1
                ? const EdgeInsets.symmetric(horizontal: 5)
                : EdgeInsets.zero,
            width: resp.isTablet ? 18 : 14,
            height: resp.isTablet ? 8 : 6,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCBCB),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableBox(String id, int seatType, bool isSelected,
      String status, Responsiveness resp) {
    Color borderColor;
    if (isSelected) {
      borderColor = AppColor.tableGreenColor;
    } else if (status.toLowerCase() == 'available') {
      borderColor = Colors.green;
    } else if (status.toLowerCase() == 'reserved') {
      borderColor = Colors.red;
    } else {
      borderColor = Colors.grey;
    }

    double baseWidth = resp.isTablet ? 180 : 130;
    double baseHeight = resp.isTablet ? 85 : 70;

    // Adjust based on seater
    double factor = seatType <= 2
        ? 0.8
        : seatType <= 4
        ? 1.0
        : seatType <= 6
        ? 1.2
        : 1.4;

    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: baseWidth * factor,
            height: baseHeight,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.tableGreenColor.withOpacity(0.35)
                  : Colors.white,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  id,
                  style: AppTextStyles.nunitoMedium(resp.buttonFontSize),
                ),
                Text(
                  status.toLowerCase() == 'reserved'
                      ? 'Occupied'
                      : status[0].toUpperCase() + status.substring(1).toLowerCase(),
                  style: AppTextStyles.nunitoRegular(resp.hintTextSize),
                ),

              ],
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 8,
            left: 4,
            child: SvgPicture.asset(AppImage.tickIcon, height: 18),
          ),
      ],
    );
  }
}
