import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/date-range-picker.dart';
import 'package:movie_web/common/layout/multi-select-dropdown-menu.dart';
import 'package:movie_web/utils/keyboard_formatter.dart';

class FormScreen extends StatelessWidget {
  static final String routeName = '/form-example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MultiSelectDropdownMenu<String>(
                  autovalidate: true,
                  items: ['ABCD', 'abdsE', 'asdasdF', 'adsasddG'],
                  filter: true,
                  validator: (value) {
                    print(value);
                    if (value == null || value.length == 0) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Multi Select Dropdown',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DatePickerForm(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Date Picker',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateRangePickerForm(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Date Range Picker'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Number Input FreeStyle'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [KeyboardFormatter.positiveInteger()],
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Positive Number Input Filter'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [KeyboardFormatter.positiveInteger()],
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), labelText: 'Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), labelText: 'Phone'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
