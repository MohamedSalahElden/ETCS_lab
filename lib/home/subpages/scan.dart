import 'package:etcs_lab_manager/home/subpages/itemdetailscard.dart';
import 'package:etcs_lab_manager/home/subpages/itemdetailscardForScan.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

const bgCOlor = Color(0xfffafafa);

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool _isBottomSheetVisible = false; // Flag to track bottom sheet visibility

  void closeScreen() {
    // Reset the flag when the bottom sheet is closed
    setState(() {
      _isBottomSheetVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MobileScannerController controller = MobileScannerController(
      torchEnabled: false,
      // formats: [BarcodeFormat.qrCode]
      // facing: CameraFacing.front,
    ); 
    
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: bgCOlor,
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
                  Text("Scanning starts automatically"),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: MobileScanner(
                controller: controller,
                fit: BoxFit.contain,
                onDetect: (capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  dynamic item = await Provider.of<ComponentProvider>(context, listen: false).getItemFromInstance(barcodes[0].rawValue?? 'unknown code');
                  print("[salah] ${item['item name']}");
                  if (!_isBottomSheetVisible) { // Check if the bottom sheet is already visible
                    setState(() {
                      _isBottomSheetVisible = true; // Set the flag to true when the sheet is shown
                    });

                    print("QR code detected");
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
                              ItemDetailsCardForScan(scannedCode: barcodes[0].rawValue?? 'unknown code', base64Image: "" , itemCodes: Provider.of<ComponentProvider>(context, listen: false).getInstanceCodesForItemId(item["item id"]) , itemDetails: item["item id"],),
                            ],
                          ),
                        ),
                      );
                    },
                  ).then((value) {
                      // Reset the flag when the bottom sheet is closed
                      closeScreen();
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
