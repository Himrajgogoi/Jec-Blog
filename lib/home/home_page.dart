import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:signup_login_template_v1/api_connection/logout.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';
import 'package:signup_login_template_v1/fetched_data/All_users.dart';
import 'package:signup_login_template_v1/fetched_data/Recent_articles.dart';
import 'package:signup_login_template_v1/home/allArticles.dart';
import 'package:signup_login_template_v1/home/personal.dart';
import 'package:signup_login_template_v1/shared/common.dart';
import "dart:core";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> list = [];
  String loader = "yes";
  String loader2 = "false";
  String message;



  void getRecentArticles() async {
    RecentArticles art = RecentArticles();
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
      loader2 = "yes";
    });
     AllArticles art = AllArticles();
     await art.getToken();
     await art.get_specific_article(id);


    Navigator.pushNamed(context, "article", arguments: {
        "article": art.article,
       "message": art.message
     });
    setState(() {
      loader2 = "false";
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
                    child: Text("${item["header"]}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
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
                  maxLines: 2,)
            )

          ],
        )
      ),
    );
  }

  PageController _controller = PageController(
      initialPage: 0
  );
  double currentPage=0;

  @override
  void initState() {
    super.initState();
    getRecentArticles();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _recent(){
    return list.isEmpty || message != null? Center(
      child: Text("Sorry!", style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
      ),),
    ): loader2=="yes"?Center(child: SpinKitHourGlass(color: Colors.lightBlue,),):ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return _buildList(list[index]);
        });
  }


  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page;
      });
    });
    return loader == "yes"?Center(child: SpinKitHourGlass(color: Colors.lightBlue)): Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions:[
              // Padding(
              //   padding: EdgeInsets.fromLTRB(20, 30, 10, 10),
              //   child: InkWell(
              //       onTap:() async {
              //         await Logout().getToken();
              //         await Logout().logout();
              //         BlocProvider.of<AuthenticateBloc>(context).add(LoggedOut());
              //         SystemChannels.platform.invokeMethod("SystemNavigator.pop");
              //        },
              //       child: Icon(
              //         Icons.person,
              //         color: Colors.black,
              //       )
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 40, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "search");
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[800],
                  ),
                ),
              )
            ]
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:Alignment.bottomRight,
                  stops: [0.3,1],
                  colors: [Colors.white,Colors.black]
              )
          ),
          child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 20, 50),
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                      child: Row(
                        children: [
                          Text("Articles", style: TextStyle(
                            fontSize: 36.0,
                          ),),
                        ],
                      ),
                    ),
                    Divider(height: 12.0, thickness: 2.0 ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: currentPage==0?Colors.blue[800]: Colors.lightBlue,
                          ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("Recent Articles", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,

                                ),),
                              ),

                          ),
                          SizedBox(
                              width: 12.0
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: currentPage==1?Colors.blue[800]: Colors.lightBlue,
                            ),
                            child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("All Articles",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),),)
                          ),

                          SizedBox(
                              width: 12.0
                          ),
                          Container(decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: currentPage==2?Colors.blue[800]: Colors.lightBlue,
                          ),child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Personal",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),),
                          ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex:6,
                      child: PageView(
                        controller: _controller,
                        children: [
                         _recent(),
                          All(),
                          Personal()
                        ],
                      ),
                    )

                  ],
                ),
              )
          )
        ),
      bottomSheet: BottomAppBar(
        color: Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){},
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "addArticle");
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "personalinfo");
                },
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
