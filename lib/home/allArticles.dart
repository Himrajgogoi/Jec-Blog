import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';
import 'package:signup_login_template_v1/fetched_data/All_users.dart';
import 'package:signup_login_template_v1/shared/common.dart';
import "dart:core";



class All extends StatefulWidget {
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  List<dynamic> list = [];
  String loader = "false";
  String message;



  void getAllArticles() async {
    AllArticles art = AllArticles();
    await art.getToken();
    await art.getData();

    setState(() {
      list = art.data;
      message = art.message;
      loader = "false";
    });
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
                    Expanded(
                      flex:2,
                      child: Text(": posted on ${item["createdAt"].toString().substring(0,10)}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.grey
                        ),),
                    )
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
                child: item["image"] != null? Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(item["image"]),
                        fit: BoxFit.fill
                    )
                ),
              ): Container(
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.article_sharp,
                      size: 60.0,
                    )
                  ),
                  color: Colors.red[200],
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllArticles();
  }

  @override
  Widget build(BuildContext context) {

                return    list.isEmpty || message != null? Center(
                  child: Text("Sorry!", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,

                  ),),
                ):  loader=="yes"?Center(child: SpinKitHourGlass(color: Colors.lightBlue,),):ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return _buildList(list[index]);
                    });

  }
}
