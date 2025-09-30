// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/cart_provider.dart'; // Adjust path as needed
//
// import 'package:flutter/material.dart';
//
// import 'home_screen.dart';
//
// class PaymentSuccessScreen extends StatelessWidget {
//   const PaymentSuccessScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           width: 300,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 12,
//                 offset: Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Gradient circle icon
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration:  BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [Colors.red.shade300, const Color(0xFFE31E24)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//                 child: const Icon(Icons.check, size: 40, color: Colors.white),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Success text
//               const Text(
//                 'Success!',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFD32F2F),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Subtext
//               const Text(
//                 'Your payment was successful.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//
//               const SizedBox(height: 30),
//
//               // Back Home button
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 // child: ElevatedButton(
//                 //   onPressed: () {
//                 //
//                 //   },
//                 //   style: ElevatedButton.styleFrom(
//                 //     padding: EdgeInsets.zero,
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(25),
//                 //     ),
//                 //     elevation: 0,
//                 //   ),
//                 //   child: Ink(
//                 //     decoration: BoxDecoration(
//                 //       gradient:  LinearGradient(
//                 //         colors: [Colors.red.shade300, const Color(0xFFE31E24)],
//                 //       ),
//                 //       borderRadius: BorderRadius.circular(25),
//                 //     ),
//                 //     child: Container(
//                 //       alignment: Alignment.center,
//                 //       child: const Text(
//                 //         'Back Home',
//                 //         style: TextStyle(fontSize: 16, color: Colors.white),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 child: Consumer<CartProvider>(
//               builder: (context, cartProvider, _) {
//                 return ElevatedButton(
//                   onPressed: () {
//                     cartProvider.clearCart();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const HomeScreen()
//                       ),
//                     );//
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.zero, // Remove internal padding
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 3,
//                     backgroundColor: Colors.transparent, // Required for gradient to show
//                     shadowColor: Colors.black.withOpacity(0.2),
//                   ),
//                   child: Ink(
//                     decoration: BoxDecoration(
//                       gradient:  LinearGradient(
//                         colors: [Colors.red.shade300, const Color(0xFFE31E24)], // Pink to red
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
//                       child: const Text(
//                         'Back to Home',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//
//               },
//             ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
