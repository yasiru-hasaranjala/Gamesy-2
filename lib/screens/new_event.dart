import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/screens/confirn_schedule.dart';
import 'package:agora_flutter_quickstart/services/database.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:agora_flutter_quickstart/shared/loading.dart';

class NewEvent extends StatefulWidget {

  final String sport;

  NewEvent ({
    Key key,
    @required this.sport,
  }):super(key:key);

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  DateTime _pickedDate;
  TimeOfDay _pickedTime;

  String _name1 = '';
  String _name2 = '';
  String _evName = '';
  String _organizer = '';
  String _pw = '';
  String _date = '';
  String _time = '';
  String _description = '';
  var _method = ['Open','Closed'];
  var _currentItem = 'Open';

  TextEditingController _textControllerDate = TextEditingController();
  TextEditingController _textControllerTime = TextEditingController();
  final DatabaseService  _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _pickedDate = DateTime.now();
    _pickedTime = TimeOfDay.now();
  }

  @override
  Widget build (BuildContext context) {
    var size = MediaQuery.of(context).size;
    return loading ? Loading() :  Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 3,
                    child: Text(
                      'Create ${widget.sport} Event',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.4,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    heightFactor: 2,
                    child: Text('    Event Name',textAlign: TextAlign.left,textScaleFactor: 1.2),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                    child: TextFormField(
                      validator: (val)=>val.isEmpty?'*Required':null,
                      decoration: InputDecoration(
                        hintText: 'Unique Name for the event',
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onChanged: (String val) {
                        setState(() {
                          _evName = val;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('    Organized By',textAlign: TextAlign.left,textScaleFactor: 1.2),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                    child: TextFormField(
                      validator: (val)=>val.isEmpty?'*Required':null,
                      decoration: InputDecoration(
                        hintText: 'Organizer',
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onChanged: (String val) {
                        setState(() {
                          _organizer = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text('    Broadcast Method',textAlign: TextAlign.left, textScaleFactor: 1.2,),
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: 70,
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
                    child: DropdownButtonFormField(
                      items: _method.map((String dropValue) {
                        return DropdownMenuItem<String>(
                          value: dropValue,
                          child: Text(dropValue),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState((){
                          this._currentItem = newValueSelected;
                        });
                      },
                      value: this._currentItem,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        fillColor: kPrimaryLightColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text('    Admin Password',textAlign: TextAlign.left,textScaleFactor: 1.2),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                    child: TextFormField(
                      validator: (val)=>val.length<4?'*password should more than 4 charactors':null,
                      decoration: InputDecoration(
                        hintText: 'Create a Strong password',
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        fillColor: kPrimaryLightColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (String val) {
                        setState(() {
                          _pw = val;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text('     Team 1',textScaleFactor: 1.2),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text('     Team 2',textScaleFactor: 1.2),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 15),
                        child: TextFormField(
                          validator: (val)=>val.isEmpty?'*Required':null,
                          decoration: InputDecoration(
                            hintText: 'Team Name 1',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            fillColor: kPrimaryLightColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onChanged: (String val) {
                            setState(() {
                              _name1 = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(left: 10,right: 15,top: 5,bottom: 15),
                        child: TextFormField(
                          validator: (val)=>val.isEmpty?'*Required':null,
                          decoration: InputDecoration(
                            hintText: 'Team Name 2',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            fillColor: kPrimaryLightColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onChanged: (String val) {
                            setState(() {
                              _name2 = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('    Description',textAlign: TextAlign.left,textScaleFactor: 1.2),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                    child: TextFormField(
                      validator: (val)=>val.isEmpty?'*Required':null,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Small description about the event',
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (String val) {
                        setState(() {
                          _description = val;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text('     Date',textScaleFactor: 1.2),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text('     Time',textScaleFactor: 1.2),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 15),
                        child: TextFormField(
                          validator: (val)=>val.isEmpty?'*Required':null,
                          controller: _textControllerDate,
                          decoration: InputDecoration(
                            hintText: _pickedDate.toString().substring(0,10),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            fillColor: kPrimaryLightColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onTap: (){
                            // Below line stops keyboard from appearing
                            FocusScope.of(context).requestFocus(FocusNode());
                            // Show Date Picker Here
                            _pickDate();
                          },
                          onChanged: (val) {
                            setState(() {
                              _date = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(left: 10,right: 15,top: 5,bottom: 15),
                        child: TextFormField(
                          validator: (val)=>val.isEmpty?'*Required':null,
                          controller: _textControllerTime,
                          decoration: InputDecoration(
                            hintText: _pickedTime.toString().substring(10,15),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            fillColor: kPrimaryLightColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onTap: (){
                            // Below line stops keyboard from appearing
                            FocusScope.of(context).requestFocus(FocusNode());

                            // Show Time Picker Here
                            _pickTime();
                          },
                          onChanged: (val) {
                            setState(() {
                              _time = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonTheme(
                        height: 42,
                        minWidth: 175,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: RaisedButton(
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _db.saveEvent(
                                  _evName, _organizer, _pw, _name1, _name2,
                                  widget.sport+ ' match  between '+_name1+
                                      ' and '+_name2+ ' is scheduled on '+
                                      _date+ ' at '+ _time+'. '+_description, _date, _time );
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ConfirmSchedule(widget.sport,_pw);
                                  },
                                ),
                              );
                              if(result==null){
                                setState(() {
                                  loading = false;
                                });
                              }
                            }

                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                      ButtonTheme(
                        height: 42,
                        minWidth: 175,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: kPrimaryColor)
                          ),
                          color: kLightColor,
                        ),
                      ),
                    ],
                  ),
                  //myName == null ? Container() : Text( myName, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 4),
    );

    if(date != null){
      setState(() {
        _pickedDate = date;
        _textControllerDate.text = _pickedDate.toString().substring(0,10);
        _date = _textControllerDate.text;
      });
    }
  }

  // ignore: always_declare_return_types
  _pickTime() async {
    var time = await showTimePicker(
      context: context,
      initialTime: _pickedTime,
    );

    if(time != null){
      setState(() {
        _pickedTime = time;
        _textControllerTime.text = _pickedTime.toString().substring(10,15);
        _time = _textControllerTime.text;
      });
    }
  }


}

