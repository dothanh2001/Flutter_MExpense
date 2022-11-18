import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mexpense/helper/helper.dart';
import 'package:flutter_mexpense/mexpense/constant.dart';
import 'package:flutter_mexpense/mexpense/route_names.dart';
import 'package:flutter_mexpense/mexpense/trip_entity.dart';
import 'package:intl/intl.dart';

class NewTrip extends StatefulWidget {
  NewTrip({Key? key, this.theTrip}) : super(key: key);
  TripEntity? theTrip;
  @override
  State<NewTrip> createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  _NewTripState() {
    tripName = listOfName[0];
  }
  String? tripName = "";
  final List<String> listOfName = [
    'Conference',
    'Client Meeting',
  ];

  final TextEditingController txtDestination = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.theTrip ??= TripEntity.empty();

    txtDestination.text = widget.theTrip!.destination;
    txtDate.text = widget.theTrip!.date;
    txtDescription.text = widget.theTrip!.description;
    txtNumber.text = widget.theTrip!.participant.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add or Update a New Trip'),
        actions: buildMenus,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Trip name
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField(
                    value: tripName,
                    items: listOfName
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        tripName = value as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.blue,
                    ),
                    dropdownColor: Colors.blue.shade50,
                    decoration: InputDecoration(
                      labelText: "Trip name",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      String text = '';
                      if (isEmpty(value)) {
                        text = 'Please enter trip name';
                      }
                      return text;
                    },
                  ),
                ),
                //Destination
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: txtDestination,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: "Destination"),
                    validator: (value) {
                      String text = '';
                      if (isEmpty(value?.trim())) {
                        text = 'Please enter destination name';
                      }
                      return text;
                    },
                  ),
                ),
                // Date
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: txtDate,
                    decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                    readOnly: true, //user cant change text
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          txtDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      });
                    },
                    validator: (value) {
                      String text = '';

                      if (isEmpty(value?.trim())) {
                        text = 'Please enter date.';
                      }
                      return text;
                    },
                  ),
                ),
                // Risk
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: risk,
                    items: riskNeed
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        risk = value as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.blue,
                    ),
                    dropdownColor: Colors.blue.shade50,
                    decoration: InputDecoration(
                      labelText: "Need risk assessment?",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      String text = '';
                      if (isEmpty(value)) {
                        text = 'Please choose yes or no';
                      }
                      return text;
                    },
                  ),
                ),
                //Description
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: txtDescription,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                ),
                // Participant numbers
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: txtNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Number of participants"),
                  ),
                ),

                // Save button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                      onPressed: saveTrip,
                      child: Text('Save',
                          style: TextStyle(
                            fontSize: fontSize,
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get buildMenus {
    var d = <Widget>[];
    if (widget.theTrip!.id != Constants.newTripId) {
      d.add(IconButton(onPressed: deleteTrip, icon: Icon(Icons.delete)));
      d.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 5)));
    }
    return d;
  }

  void deleteTrip() {
    FirebaseFirestore.instance
        .collection(Constants.fsTrip)
        .doc(widget.theTrip!.id)
        .delete()
        .then((_) => goToRoute(RouteNames.TripList, "document deleted"), onError: (e) => print("Error updating document $e"));
  }

  void goToRoute(String routeName, [String msg = ""]) {
    if (msg != "") {
      print(msg);
    }
    Navigator.pushNamed(context, routeName);
  }

  @override
  void dispose() {
    txtDescription.dispose();
    txtDestination.dispose();
    txtNumber.dispose();
    super.dispose();
  }

  void saveTrip() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        //close keyboard
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        var aTrip = TripEntity.newTrip(
            tripName.toString(), txtDestination.text, txtDate.text, risk.toString(), txtDescription.text, int.parse(txtNumber.text));
        var tId = widget.theTrip!.id;
        if (tId == Constants.newTripId) {
          //add a new book
          FirebaseFirestore.instance.collection(Constants.fsTrip).add(aTrip.getHashMap()).then(
              (docSnapshot) => goToRoute(RouteNames.TripList, "Document added with id: ${docSnapshot.id}"),
              onError: (e) => print("Error updating document $e"));
        } else {
          //update an existing book
          FirebaseFirestore.instance
              .collection(Constants.fsTrip)
              .doc(tId)
              .update(aTrip.getHashMap())
              .then((_) => goToRoute(RouteNames.TripList, "Document saved"), onError: (e) => print("Error updating document $e"));
        }
      });
    }
  }
}
