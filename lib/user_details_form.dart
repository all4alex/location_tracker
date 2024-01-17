import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:location_tracker/app/app_colors.dart';
import 'package:location_tracker/app/app_toast.dart';
import 'package:location_tracker/map_screen.dart';
import 'package:location_tracker/trip_model.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({Key? key, required this.uuid}) : super(key: key);
  final String uuid;

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String name = '';
  String startLoc = '';
  String endLoc = '';
  String uuid = '';
  int maxPassengerCapacity = 0;

  bool isLoading = false;
  // Create a CollectionReference called users that references the firestore collection
  late CollectionReference users;

  @override
  void initState() {
    super.initState();
    users = FirebaseFirestore.instance.collection('users');

    uuid = widget.uuid;
  }

  Future<void> addUser(
      {required String name,
      required String startLoc,
      required String endLoc,
      required int maxPassengerCapacity}) {
    // Call the user's CollectionReference to add a new user
    return users
        .add(TripModel(
                dateTime: DateTime.now().millisecondsSinceEpoch,
                driver: name,
                from: startLoc,
                to: endLoc,
                tripId: uuid,
                onboardPassengerCount: 0,
                maxPassengerCount: maxPassengerCapacity)
            .toMap())
        .then((value) {
      print("User Added");
      // Navigator.of(context).pop(TripModel(
      //         dateTime: DateTime.now().millisecondsSinceEpoch,
      //         driver: name,
      //         from: startLoc,
      //         to: endLoc,
      //         tripId: uuid)
      //     .toMap());

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
                name: name,
                startLoc: startLoc,
                endLoc: endLoc,
                maxPassenger: maxPassengerCapacity),
          ));
    }).catchError((error) {
      AppToast.showErrorMessage(
          context, 'Something went wrong. Please try again.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'Name',
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'Start',
                  decoration: const InputDecoration(
                    labelText: 'Start location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'Target',
                  decoration: const InputDecoration(
                    labelText: 'Target destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'MaxPassengerCapacity',
                  decoration: const InputDecoration(
                    labelText: 'Max passenger capacity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric()
                  ]),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  color: AppColors.apPurple,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    _formKey.currentState?.saveAndValidate();
                    name = _formKey.currentState?.fields['Name']?.value;
                    startLoc = _formKey.currentState?.fields['Start']?.value;
                    endLoc = _formKey.currentState?.fields['Target']?.value;
                    maxPassengerCapacity = int.parse(_formKey
                        .currentState?.fields['MaxPassengerCapacity']?.value);

                    await addUser(
                        name: name,
                        startLoc: startLoc,
                        endLoc: endLoc,
                        maxPassengerCapacity: maxPassengerCapacity);
                  },
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.appWhite,
                          ))
                      : Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
