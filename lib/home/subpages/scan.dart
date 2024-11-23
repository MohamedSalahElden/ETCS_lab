import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:etcs_lab_manager/home/subpages/itemdetailscardForScan.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';

const bgColor = Color(0xfffafafa);

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  bool _isBottomSheetVisible = false; // Flag to track bottom sheet visibility
  bool isFlashOn = false; // Flash toggle state
  List<Barcode> barcodes = [];

  void _closeBottomSheet() {
    setState(() {
      _isBottomSheetVisible = false;
    });
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn; // Toggle flash state
    });
    controller.toggleTorch(); // Toggle the flashlight
    debugPrint('Flash toggled: $isFlashOn');
  }

  Future<void> _handleBarcodeDetection(BuildContext context, ) async {
    if (barcodes.isEmpty || _isBottomSheetVisible) return;

    final String scannedCode = barcodes.last.rawValue ?? 'Unknown code';
    final componentProvider = Provider.of<ComponentProvider>(context, listen: false);
    dynamic item = await componentProvider.getItemFromInstance(scannedCode);

    setState(() {
      _isBottomSheetVisible = true;
    });

    // Display the bottom sheet
    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.white,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //   ),
    //   elevation: 10,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return Padding(
    //        padding: const EdgeInsets.only(top: 20, bottom: 20), // Add space at the top and bottom,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           ItemDetailsCardForScan(
    //             scannedCode: scannedCode,
    //             base64Image: "",
    //             itemCodes: componentProvider.getAllComponentCodesForItemId(item["item id"]),
    //             itemDetails: item["item id"],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // ).then((_) => _closeBottomSheet());

                  showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      elevation: 10, // Drop shadow
                      isScrollControlled: true, // Allows dynamic height adjustment
                      builder: (BuildContext context) {
                        return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20), // Add space at the top and bottom
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Let the content determine height
                            children: [
                              ItemDetailsCardForScan(scannedCode: barcodes[0].rawValue?? 'unknown code', base64Image: "" , itemCodes: Provider.of<ComponentProvider>(context, listen: false).getAllComponentCodesForItemId(item["item id"]) , itemDetails: item["item id"],),
                            ],
                          ),
                        ),
                      );
                      },
                  ).then((_) => _closeBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: MobileScanner(
                controller: controller,
                fit: BoxFit.contain,
                onDetect: (capture) => { barcodes = capture.barcodes},
              ),
            ),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Small Icon Button
                    Flexible(
                      flex: 1, // Small portion of the available space
                      child: ElevatedButton(
                        onPressed: () {
                          // More Details Button Logic
                          _toggleFlash();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8), // Adjust padding for a smaller button
                          shape: const CircleBorder(), // Circular shape for the button
                          backgroundColor: isFlashOn ? const  Color.fromARGB(255, 42, 153, 27) : const Color.fromARGB(255, 61, 61, 61),
                        ),
                        child: Icon(
                          isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: isFlashOn ? const Color.fromARGB(255, 255, 255, 255) : Colors.grey,
                          size: 20,
                        ), // Small icon
                      ),
                    ),
                    const SizedBox(width: 16), // Space between buttons
                    // Borrow Button
                    Expanded(
                      flex: 5, // Remaining width of the row
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 42, 153, 27), // White text
                        ),
                        onPressed: () {_handleBarcodeDetection(context);},
                        child:  Text('Scan' , style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                )
,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
