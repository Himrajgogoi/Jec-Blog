import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import 'package:signup_login_template_v1/database/savedArticles.dart';
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';
import 'package:signup_login_template_v1/fetched_data/All_users.dart';
import 'package:signup_login_template_v1/fetched_data/Personal_articles.dart';
import 'package:signup_login_template_v1/shared/common.dart';
import "dart:core";

class Personal extends StatefulWidget {
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {

  List<dynamic> list = [];
  String loader = "yes";
  String message = " ";
  List<Map<String,dynamic>> savedList = [];



  void getPersonalArticles() async {
    PersonalArticles art = PersonalArticles();
    await art.getToken();
    await art.getData();

    setState(() {
      list = art.data;
      message = art.message;
      loader = "false";
    });
  }

  void getSavedArticles() async {
    Saved_for_Editing art = Saved_for_Editing(header: null, textArea: null, image: null);
    savedList = await art.getArticles();
    print(savedList);
    setState(() {
      savedList = savedList;
    });

  }
  void deleteSavedArticle(int id) async {
    setState(() {
      loader = "yes";
    });
    Saved_for_Editing art = Saved_for_Editing(header: null, textArea: null, image: null);
    await art.DeleteById(id);

    setState(() {
      loader = "false";
    });
    Navigator.popAndPushNamed(context, "home");
  }

  void getSpecificArticle(int id) async {
    setState(() {
      loader = "yes";
    });
    AllArticles art = AllArticles();
    await art.getToken();
    await art.get_specific_article(id);


    Navigator.pushNamed(context, "article", arguments: {
      "article": art.article,
      "message": art.message
    });

    setState(() {
      loader = "false";
    });

  }

  void _deleteArticle(int id) async {
    PersonalArticles per = PersonalArticles();
    await per.getToken();
    await per.deleteArticle(id);
    if(per.message == "Deleted!"){
      Navigator.popAndPushNamed(context, "home");
    }
  }




  _buildList(dynamic item) {
    return InkWell(
      onTap: (){
        getSpecificArticle(item["id"]);
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white
          ),
          margin: EdgeInsets.only(bottom: 12.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(15, 18, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex:3,
                      child: Text("${item["header"]}"
                        ,style: TextStyle(
                          fontWeight: FontWeight.bold,

                        ),),
                    ),
                    SizedBox(width: 2.0,),
                    Expanded(
                      flex:2,
                      child: Text(": posted on ${item["createdAt"].toString().substring(0,10)}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.grey
                        ),),
                    ),
                    Spacer(flex:1),
                    PopupMenuButton(
                      child: Icon(
                          Icons.more_vert
                      ),
                        itemBuilder: (_)=> <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(
                            child: InkWell(
                              child: Text("Edit"),
                              onTap: (){
                                Navigator.of(context).pushNamed("addArticle", arguments: {
                                  "previouslyPosted": "yes",
                                  "articleId": item["id"],
                                  "header": item["header"],
                                  "textArea": item["textArea"],
                                  "image": item["image"]
                                });
                              },
                            ),
                          ),
                          new PopupMenuItem<String>(
                            child: InkWell(
                              child: Text("Delete"),
                              onTap: (){
                                _deleteArticle(item["id"]);
                              },
                            ),
                          )
                        ])
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:15),
                child: Text("by ${item["username"]}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey[700]
                  ),),
              ),
              SizedBox(height:5.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child:  Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(item["image"]),
                          fit: BoxFit.fill
                      )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("${item["textArea"]}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(

                      ))
              )

            ],
          )
      ),
    );
  }
  _buildsavedList(dynamic item) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white
        ),
        margin: EdgeInsets.only(bottom: 12.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(15, 18, 10, 10),
              child: Row(
                children: [
                  Text("${item["header"]}"
                    ,style: TextStyle(
                      fontWeight: FontWeight.bold,

                    ),),
                  Spacer(flex:1),
                  PopupMenuButton(
                      child: Icon(
                          Icons.more_vert
                      ),
                      itemBuilder: (_)=> <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                          child: InkWell(
                            child: Text("Edit"),
                            onTap: (){
                              Navigator.of(context).pushNamed("addArticle", arguments: {
                                "previouslyPosted": "no",
                                "articleId": item["articleId"],
                                "header": item["header"],
                                "textArea": item["textArea"],
                                "image": item["image"]
                              });
                            },
                          ),
                        ),
                        new PopupMenuItem<String>(
                          child: InkWell(
                            child: Text("Delete"),
                            onTap: (){
                              deleteSavedArticle(item["articleId"]);
                            },
                          ),
                        )
                      ])
                ],
              ),
            ),
            SizedBox(height:5.0),
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("${item["textArea"]}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(

                    ))
            )

          ],
        )
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedArticles();
    getPersonalArticles();
  }

  @override
  Widget build(BuildContext context) {
                 if ((list.isEmpty && savedList.isEmpty) || message == " ") {
                   return Center(
                   child: Text("You haven't posted/saved anything", style: TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 15.0,
                   ),),
                     );
                 } else {
                   if (loader== "yes") {
                     return Center(child: SpinKitHourGlass(color: Colors.lightBlue,),);
                   } else {
                     return SingleChildScrollView(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.0),
                           Text("Posted", style: TextStyle(
                             fontSize: 20.0,
                           )),
                           Divider(height: 12.0,),
                            SizedBox(height: 6.0),
                           if(list.isEmpty)Center(
                             child: Text("You haven't posted anything", style: TextStyle(
                               color: Colors.white,
                              fontWeight: FontWeight.bold,
                               fontSize: 15.0,
                            ),),
                           )
                           else ...List.generate(list.length, (index) => _buildList(list[index])),
                            SizedBox(height: 12.0),
                             Text("Saved", style: TextStyle(

                               fontSize: 20.0,
                             )),
                            Divider(height: 12.0,),
                            SizedBox(height: 6.0),
                            if(savedList.isEmpty)Center(
                              child: Text("You haven't saved anything", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                             ),),
                            )
                            else ...List.generate(savedList.length, (index) => _buildsavedList(savedList[index])),
                            SizedBox(height: 12.0),
                          ],
                       ),
                     );
                   }
                 }

  }
}
