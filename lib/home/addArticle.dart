import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:signup_login_template_v1/database/savedArticles.dart';
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';
import 'package:signup_login_template_v1/fetched_data/Personal_articles.dart';
import 'package:signup_login_template_v1/fetched_data/Personal_info.dart';
import 'package:signup_login_template_v1/shared/textdecoration.dart';

class AddArticle extends StatefulWidget {
  final Map<String,dynamic> saved;
  AddArticle(this.saved);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  String username,textArea,header, previouslyPosted;
  int id;
  var image;
  String message=" ";
  final _formKey = GlobalKey<FormState>();
  List<Map<String,dynamic>> list = [];
  
  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      image = tempImage.path;
      message = "picked Image!";
    });
  }

  void postData() async {

    if(previouslyPosted == "no"){
      AllArticles art = AllArticles();
      await art.getToken();
      await art.postData(username, textArea, header, image);
      if(id !=null){
        Saved_for_Editing artic = Saved_for_Editing(header: null, textArea: null, image: null);
        await artic.DeleteById(id);
      }
      if(art.message == "Updated!") Navigator.popAndPushNamed(context, "home");
      else{
        setState(() {
          message = art.message;
        });
      }
    }

    else if(previouslyPosted == "yes"){
      print(id);
      PersonalArticles article = PersonalArticles();
      await article.getToken();
      await article.getData();

      if(image !=null) {
        await article.putData(id, username, textArea, header, image, isImage: true);
      }
      else{
        await article.putData(id, username, textArea, header, image);
      }

      if(article.message == "Updated!") Navigator.popAndPushNamed(context, "home");
      else{
        setState(() {
          message = article.message;
        });
      }
    }
  }

  void updateState(){
    if(widget.saved != null){
      previouslyPosted = widget.saved["previouslyPosted"];
      id = widget.saved["articleId"];
      header = widget.saved["header"];
      textArea = widget.saved["textArea"];
    }
  }

  void getUser() async {
    PersonalInfo per = PersonalInfo();
    await per.getToken();
    await per.getData();
   setState(() {
     username = per.data["username"];
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
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
                      InkWell(
                      onTap: () async {
                       if(_formKey.currentState.validate()){
                             if(widget.saved == null){
                               Saved_for_Editing art = Saved_for_Editing(header: header, textArea: textArea, image: image);
                               await art.insertArticle();
                               list = await art.getArticles();
                               Navigator.popAndPushNamed(context, "home");
                             }
                             else{
                               print("update is run");
                               print(id);
                               print(header);
                               print(textArea);
                               Saved_for_Editing arti = Saved_for_Editing(header: header, textArea: textArea, image: image);
                               await arti.update({"articleId": id, "header": header, "textArea": textArea, "image": image});
                               list = await arti.getArticles();
                               Navigator.popAndPushNamed(context, "home");
                             }
                       }

                      },
                      child: Container(
                        height: 30.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Center(child: Text("Save", style:TextStyle( color:  Colors.white)))
                      ),
                      ),
                      SizedBox(width: 10.0,),
                      InkWell(
                        onTap: (){
                           if(_formKey.currentState.validate()){
                             postData();
                           }
                        },
                        child: Container(
                            width: 60.0,
                          height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12.0)
                            ),
                            child: Center(child: Text("Post", style:TextStyle( color:  Colors.white)))
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Create Something Amazing.",
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Divider(
                    height: 12.0, thickness: 1.0,
                  ),
                  SizedBox(height: 12.0),
                  Text("Username"),
                  SizedBox(height: 12.0),
                  Text("$username", style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 12.0),
                  SizedBox(height: 12.0),
                  Text("Header"),
                  SizedBox(height: 12.0),
                  TextFormField(
                    initialValue: header??null,
                    decoration: textDecoration.copyWith(hintText: "header", fillColor: Colors.green[200]),
                    onChanged: (val){
                      setState(() {
                        header = val;
                        print(header);
                      });
                    },
                    validator: (val)=> val.isEmpty? "Enter a valid header": null,
                  ),
                  SizedBox(height: 12.0),
                  Text("Content"),
                  SizedBox(height: 12.0),
                  TextFormField(
                    initialValue: textArea??null,
                    decoration: textDecoration.copyWith(hintText: "Content", fillColor: Colors.green[200]),
                    minLines: 10,
                    maxLines: 15,
                    onChanged: (val){
                      setState(() {
                        print(val);
                        textArea = val;
                      });
                    },
                    validator: (val)=> val.isEmpty? "Write Something": null,
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pick An Image"),
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
