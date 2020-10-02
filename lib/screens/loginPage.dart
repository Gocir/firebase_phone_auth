import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_phone_auth/screens/verifView.dart';
import 'package:firebase_phone_auth/providers/phoneAuth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneController = new TextEditingController();
  String phoneNumber = "";

  void _onCountryChange(CountryCode countryCode) {  
    this.phoneNumber =  countryCode.toString();
  }

  // void check(){
  //   print("Full Text: "+ this.phoneNumber + phoneController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'Silakan masukkan Nomor HP-mu yang terdaftar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0, right: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                            ),
                            child: CountryCodePicker(
                              onChanged: _onCountryChange,
                              initialSelection: 'ID',
                              favorite: ['+62'],
                              showCountryOnly: true,
                              alignLeft: false,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              controller: phoneController,
                              // controller: Provider
                              //   .of<PhoneAuthDataProvider>(context, listen: false)
                              //   .phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Nomor HP',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green
                                  )
                                )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                      child: RaisedButton(
                        elevation: 2.0,
                        onPressed: startPhoneAuth,
                        child: Text(
                          'SEND OTP',
                          style: TextStyle(
                              color: Colors.blue, fontSize: 18.0),
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
  }
    
  startPhoneAuth() async {
    final phoneAuthDataProvider = Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    
    // var countryCode = Provider.of<CountryCode>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
      dialCode: this.phoneNumber,
      onCodeSent: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => PhoneAuthVerify()));
      },
      onFailed: () {
        _showSnackBar(phoneAuthDataProvider.message);
      },
      onError: () {
        _showSnackBar(phoneAuthDataProvider.message);
      });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invalid");
      return;
    }
  }
}