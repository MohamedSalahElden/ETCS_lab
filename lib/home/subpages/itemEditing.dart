import 'package:flutter/material.dart';

class ModifyDataScreen extends StatefulWidget {
  @override
  _ModifyDataScreenState createState() => _ModifyDataScreenState();
}

class _ModifyDataScreenState extends State<ModifyDataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Example data to populate fields
  Map<String, dynamic> data = {
    "item id": "3a30cf0fe88e",
    "item name": "SparkFun LTE CAT M1/NB-IoT Shield - SARA-R4",
    "related to": "Protocol",
    "type": "HW",
    "section": "Wireless",
    "category": "device",
    "technology": "LTE",
    "quantity": 1,
    "details": "SparkFun LTE CAT M1/NB-IoT Shield - SARA-R4",
    "model": "",
    "link": "https://www.sparkfun.com/products/13678",
    "total price": "",
    "notes": "",
    "arrival date": "",
    "instances": {
      "3a30cf0fe88e0101": {
        "working_status": "working",
        "status": "available",
        "labeled": "false",
        "location": "",
        "borrowed_by": "",
        "date_borrowed": "",
      }
    }
  };

  // Controllers for the fields
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController relatedToController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController technologyController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController arrivalDateController = TextEditingController();

  // Instance-specific fields
  String workingStatus = "working";
  String status = "available";

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default data
    itemNameController.text = data["item name"];
    relatedToController.text = data["related to"];
    typeController.text = data["type"];
    sectionController.text = data["section"];
    categoryController.text = data["category"];
    technologyController.text = data["technology"];
    quantityController.text = data["quantity"].toString();
    detailsController.text = data["details"];
    linkController.text = data["link"];
    notesController.text = data["notes"];
    arrivalDateController.text = data["arrival date"];
    workingStatus = data["instances"]["3a30cf0fe88e0101"]["working_status"];
    status = data["instances"]["3a30cf0fe88e0101"]["status"];
  }

  @override
  void dispose() {
    // Dispose controllers when done
    itemNameController.dispose();
    relatedToController.dispose();
    typeController.dispose();
    sectionController.dispose();
    categoryController.dispose();
    technologyController.dispose();
    quantityController.dispose();
    detailsController.dispose();
    linkController.dispose();
    notesController.dispose();
    arrivalDateController.dispose();
    super.dispose();
  }

  void applyChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        data["item name"] = itemNameController.text;
        data["related to"] = relatedToController.text;
        data["type"] = typeController.text;
        data["section"] = sectionController.text;
        data["category"] = categoryController.text;
        data["technology"] = technologyController.text;
        data["quantity"] = int.tryParse(quantityController.text) ?? 0;
        data["details"] = detailsController.text;
        data["link"] = linkController.text;
        data["notes"] = notesController.text;
        data["arrival date"] = arrivalDateController.text;
        data["instances"]["3a30cf0fe88e0101"]["working_status"] = workingStatus;
        data["instances"]["3a30cf0fe88e0101"]["status"] = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes applied successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modify Data', style: TextStyle(color: Colors.white),) , backgroundColor: const Color(0xffbf1e2e) ,) ,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Item Name", itemNameController),
              buildTextField("Related To", relatedToController),
              buildTextField("Type", typeController),
              buildTextField("Section", sectionController),
              buildTextField("Category", categoryController),
              buildTextField("Technology", technologyController),
              buildTextField("Quantity", quantityController, keyboardType: TextInputType.number),
              buildTextField("Details", detailsController),
              buildTextField("Link", linkController),
              buildTextField("Notes", notesController),
              buildTextField("Arrival Date", arrivalDateController),
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
                child: Text("Apply Changes" , style: TextStyle(color: Colors.white),),
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

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
