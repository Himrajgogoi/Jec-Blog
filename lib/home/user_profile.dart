import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  String message;
  Map<String,dynamic> data = {};
  String loader = "true";


  void getSpecificArticle(int id) async {
    // setState(() {
    //   loader2 = "yes";
    // });
    AllArticles art = AllArticles();
    await art.getToken();
    await art.get_specific_article(id);


    Navigator.pushNamed(context, "article", arguments: {
      "article": art.article,
      "message": art.message
    });
    // setState(() {
    //   loader2 = "false";
    // });

  }


  _buildList(dynamic item) {
    return InkWell(
      onTap: (){
        getSpecificArticle(item["id"]);
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.8), blurRadius: 5.0, spreadRadius: 3.0, offset: Offset(1,1))]
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
                child: Text("by ${data["username"]}",
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
                    maxLines: 2,)
              )

            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    message = data["message"];
    data = data["user"];
    loader = "false";

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: loader == "true"?Center(
              child: SpinKitHourGlass(
                color: Colors.blue,
              )
          ):message != null?Center(
              child: Text("$message", style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),)
          ):SingleChildScrollView(
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
                      Text("User Profile",
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  CircleAvatar(
                    minRadius: 40,
                    maxRadius: 60,
                    backgroundImage: NetworkImage("${data["user_profile"]["dp"]}"),
                  ),
                  SizedBox(height: 25.0,),
                  Padding(padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${data["username"]}",
                                style: TextStyle(
                                  fontSize: 30.0
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 20.0,),
                  Divider(
                    height: 15.0, thickness: 2,
                  ),

                  SizedBox(height: 12.0),
                  Text("Username"),
                  SizedBox(height: 15.0),
                  Text("${data["username"]}", style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 12.0),
                  Text("Email"),
                  SizedBox(height: 12.0),
                  Text("${data["email"]}", style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 12.0),
                  Text("Bio"),
                  SizedBox(height: 12.0),
                  Text("${data["user_profile"]["bio"]}", style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 12.0),
                  Center(child: message != null?Text("$message"): Text(" ")),
                  SizedBox(height: 12.0),
                  Text("Posted", style: TextStyle(
                      fontSize: 18.0,
                  ),),
                  Divider(
                    height: 12.0, thickness: 1.0,
                  ),
                  SizedBox(height: 12.0),
                  ...List.generate(data["posted"].length, (index) => _buildList(data["posted"][index]))
                ],
              ),
            ),
          ),
        )
    );
  }
}
