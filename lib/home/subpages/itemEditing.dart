import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyitemScreen extends StatefulWidget {
  final Map<String, dynamic> item; // Make item a required parameter

  // Modify constructor to accept the required item parameter
  ModifyitemScreen({required this.item});

  @override
  _ModifyitemScreenState createState() => _ModifyitemScreenState();
}

class _ModifyitemScreenState extends State<ModifyitemScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late Map<String, dynamic> item; // Declare a variable to hold the item

  // Controllers for the fields
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController technologyController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Instance-specific fields
  String workingStatus = "working";
  String status = "available";

  @override
  void initState() {
    super.initState();
    item = widget.item; // Initialize item from the passed parameter

    // Initialize controllers with default item
    itemNameController.text = item["item name"];
    technologyController.text = item["technology"];
    detailsController.text = item["details"];
    linkController.text = item["link"];
    notesController.text = item["notes"];
    
    
  }

  @override
  void dispose() {
    // Dispose controllers when done
    itemNameController.dispose();
    technologyController.dispose();
    detailsController.dispose();
    linkController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> applyChanges() async {
    if (_formKey.currentState!.validate()) {
      Map<String , dynamic> data = {};
      data["item name"] = itemNameController.text;
      data["technology"] = technologyController.text;
      data["details"] = detailsController.text;
      data["link"] = linkController.text;
      data["notes"] = notesController.text;
      print("[item] $item");
      await Provider.of<ComponentProvider>(context, listen: false).EditComponent(item["item id"] , data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes applied successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item["item name"], style: TextStyle(color: Colors.white),), backgroundColor: const Color(0xffbf1e2e),),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              buildTextField(isRequired : true , "Item Name", itemNameController),
              buildTextField(isRequired : true ,"Technology", technologyController),
              buildTextField(isRequired : false ,"Details", detailsController),
              buildTextField(isRequired : false ,"Link", linkController),
              buildTextField(isRequired : false ,"Notes", notesController),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: workingStatus,
                decoration: InputDecoration(labelText: "Working Status"),
                items: ["working", "not working", "needs repair"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    workingStatus = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: "Status"),
                items: ["available", "borrowed", "reserved"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: applyChanges,
                child: Text("Apply Changes", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 42, 153, 27),
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        
        ),
      ),
    );
  }

  Widget buildTextField(  String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, required bool isRequired} ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          // border: OutlineInputBorder(),
        ),
         maxLines: null, // Wraps text to multiple lines
          minLines: 1, // Shows at least 3 lines initially
          keyboardType: TextInputType.multiline,
          
          validator: (value) {
            if (isRequired){
              if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
            }
          },
      ),
    );
  }
}
