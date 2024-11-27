import 'package:etcs_lab_manager/home/subpages/itemActions.dart';
import 'package:etcs_lab_manager/home/subpages/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
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
  Map<String , dynamic> parentItem = {};

  void _closeBottomSheet() {
    setState(() {
      _isBottomSheetVisible = false;
    });
  }

  
  Color getCategoryColor(String category) {
    int hash = category.hashCode;
    int red = (hash & 0xFF0000) >> 16;
    int green = (hash & 0x00FF00) >> 8;
    int blue = hash & 0x0000FF;
    return Color.fromARGB(255, red, green, blue);
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
    parentItem = componentProvider.getItemFromInstance(scannedCode);


    setState(() {
      _isBottomSheetVisible = true;
    });


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
      child: SingleChildScrollView(  // Wrap in SingleChildScrollView to handle overflow
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Ensures the column takes the size of its children
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: getCategoryColor(parentItem['section']),
                  child: Text(
                    parentItem["section"].substring(0, 2),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  parentItem.containsKey("item name") && parentItem["item name"] != null
                      ? parentItem["item name"]!
                      : "",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Row(
                children: [
                  Text(
                    "code: $scannedCode",
                    style: const TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.black), // Copy icon
                    onPressed: () {
                      // Copy the scannedCode to the clipboard
                      Clipboard.setData(ClipboardData(text: scannedCode));
                    },
                  ),
                  
                ],
              ),
                trailing: const Icon(
                  Icons.expand_more,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    ItemCard(item: parentItem),
                    ItemActions(
                      item: parentItem,
                      bottonType: "return",
                      bottonState: "active",
                      action: () {},
                      instanceCode: scannedCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
