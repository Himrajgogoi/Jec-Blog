import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:signup_login_template_v1/api_connection/logout.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import 'package:signup_login_template_v1/fetched_data/Personal_info.dart';
import 'package:signup_login_template_v1/fetched_data/Profile.dart';
import 'package:signup_login_template_v1/shared/textdecoration.dart';


class personalInfo extends StatefulWidget {
  @override
  _personalInfoState createState() => _personalInfoState();
}

class _personalInfoState extends State<personalInfo> {
  String username,email,bio;
  var dp;
  String message=" ";
  Map<String,dynamic> data = {};
  String loader = "true";
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      dp = tempImage.path;
      message = "picked Image!";
    });
  }

  void getData() async {
    PersonalInfo per = PersonalInfo();
    await per.getToken();
    await per.getData();
    setState(() {
      loader = "false";
      data = per.data;
    });
  }

  void putData() async {

    ///for username and email
    PersonalInfo per = PersonalInfo();
    await per.getToken();

    ///for bio and dp
    Profile prf = Profile();
    await prf.getToken();


    /// updating username and email
    await per.putData(data["id"], username??data["username"], email??data["email"]);

    ///updating bio and dp
    if(data["user_profile"] == null){
      await prf.postData(bio, dp);
      if(prf.message == "Updated!" && per.message == "Updated!"){
        setState(() {
          loader = "true";
          message = " ";
        });
        getData();
      }
      else{
        setState(() {
          message = "An error occured";
        });
      }
    }
    else if(bio != null || dp != null){
      await prf.getData();
      if(bio == null && dp != null){
        await prf.putData(prf.data[0]["id"], dp, isDp: true);
      }
      else if(bio !=null && dp == null){
        await prf.putData(prf.data[0]["id"], bio, isDp: false);
      }
      else if(bio != null && dp != null){
        await prf.fullUpdate(prf.data[0]["id"], bio, dp);
      }

      if(prf.message == "Updated!" && per.message == "Updated!"){
        setState(() {
          loader = "true";
          message = " ";
        });
        getData();
      }
      else{
        setState(() {
          message = "An error occured";
        });
      }
    }
   
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: loader == "true"?Center(
            child: SpinKitHourGlass(
              color: Colors.blue,
            )
          ):Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.popAndPushNamed(context, "home");
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(flex:2),
                        TextButton.icon(onPressed: () async {
                            await Logout().getToken();
                            await Logout().logout();
                           BlocProvider.of<AuthenticateBloc>(context).add(LoggedOut());
                           SystemChannels.platform.invokeMethod("SystemNavigator.pop");
                            },
                            icon: Icon(Icons.logout), label: Text("Logout"))
                      ],
                    ),
                    SizedBox(height: 30.0,),
                    Padding(padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome,",
                                style: TextStyle(
                                  fontSize: 35.0
                                ),),
                                Text("${data["username"]}.",style: TextStyle(
                                    fontSize: 35.0
                                ),),
                              ],
                            ),
                            CircleAvatar(
                              minRadius: 40,
                              maxRadius: 60,
                              backgroundImage: NetworkImage("${data["user_profile"]["dp"]}"),
                            )
                          ],
                        )),
                    SizedBox(height: 20.0,),
                    Divider(
                      height: 15.0, thickness: 2,
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Edit Profile.",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                        InkWell(
                          onTap: (){
                             if(_formKey.currentState.validate()){
                               putData();
                             }
                          },
                          child: Container(
                              width: 60.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Center(child: Text("Update", style:TextStyle( color:  Colors.white)))
                          ),
                        )
                      ],
                    ),

                    Divider(
                      height: 12.0, thickness: 1.0,
                    ),
                    SizedBox(height: 12.0),
                    Text("Username"),
                    SizedBox(height: 12.0),
                    TextFormField(
                      initialValue: data["username"],
                      decoration: textDecoration.copyWith(hintText: "username", fillColor: Colors.blue[100], enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (val){
                        setState(() {
                          username = val;
                        });
                      },
                      validator: (val)=> val.isEmpty? "Enter a valid username": null,
                    ),
                    SizedBox(height: 12.0),
                    Text("Email"),
                    SizedBox(height: 12.0),
                    TextFormField(
                      initialValue: data["email"],
                      decoration: textDecoration.copyWith(hintText: "email", fillColor: Colors.blue[100], enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (val)=> val.isEmpty? "Enter a valid email": null,
                    ),
                    SizedBox(height: 12.0),
                    Text("Bio"),
                    SizedBox(height: 12.0),
                    TextFormField(
                      initialValue: data["user_profile"]["bio"],
                      decoration: textDecoration.copyWith(hintText: "bio", fillColor: Colors.blue[100], enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(12.0))),
                      minLines: 10,
                      maxLines: 15,
                      onChanged: (val){
                        setState(() {
                          bio = val;
                        });
                      },
                      validator: (val)=> val.isEmpty? "Write Something": null,
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pick An Image for dp"),
                        InkWell(
                          onTap: (){
                            getImage();
                          },
                          child: Container(
                              width: 60.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Center(child: Text("Add", style:TextStyle( color:  Colors.white)))
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Center(child: Text("$message")),
                    SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          ),
        )
    );

  }
}
