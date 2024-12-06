import 'package:ansarbazzarweb/util/images.dart';
import 'package:flutter/material.dart';

import '../../../smtp_services.dart';

class SupportScreen extends StatelessWidget {
  TextEditingController _nameCtr = TextEditingController();
  TextEditingController _phoneCtr = TextEditingController();
  TextEditingController _cityCtr = TextEditingController();
  TextEditingController _addressCtr = TextEditingController();
  TextEditingController _quantityCtr = TextEditingController();
  //TextEditingController _noteCtr=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _richTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextFormField(
        controller: controller,
        // onChanged: (val){
        //   print(val);
        // },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Some fields are empty. Please enter details!';
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: '$hint',
            contentPadding: EdgeInsets.only(left: 5),
            border: OutlineInputBorder()),
      ),
    );
  }

  _inputFields(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Some fields are empty. Please enter details!';
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: '$hint',
            contentPadding: EdgeInsets.only(left: 5),
            border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Container(
        // height: height,
        // width: width ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(Images.support_image, height: 120),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Please complete the form below and one of the Resteez Team will come back to you.",
                            //overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Color(0xfff08113), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _richTextField('First Name', _nameCtr),

                  _richTextField('Last Name', _phoneCtr),

                  _richTextField('Email', _cityCtr),

                  _richTextField('Number', _addressCtr),

                  _richTextField('Message', _quantityCtr),
                  //_inputFields('الملاحظات',_noteCtr),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Center(
                      child: MaterialButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          if (_formKey.currentState.validate()) {
                            SmtpServices().mail(
                                _nameCtr.text,
                                _phoneCtr.text,
                                _cityCtr.text,
                                _addressCtr.text,
                                _quantityCtr.text //_noteCtr.text
                                ,
                                context);
                            _nameCtr.clear();
                            _phoneCtr.clear();
                            _cityCtr.clear();
                            _addressCtr.clear();
                            _quantityCtr.clear();
                            //  _noteCtr.clear();
                          }
                        },
                        color: Color(0xfff08113),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
