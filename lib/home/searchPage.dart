import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:signup_login_template_v1/fetched_data/All_articles.dart';
import 'package:signup_login_template_v1/fetched_data/Search.dart';
import 'package:signup_login_template_v1/shared/textdecoration.dart';


class SearchItem extends StatefulWidget {
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

  String message = " ";
  List<dynamic> data = [];
  String loader = "false";
  String loader2 = "false";

  String word;
  final _formKey = GlobalKey<FormState>();



  void search(String word) async {
    setState(() {
      loader="true";
    });
    Search srch = Search(word: word);
    await srch.getToken();
    await srch.getData();
    srch.search();
    setState(() {
      message = srch.message;
      data = srch.searched;
      loader="false";
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
                    Text("${item["header"]}"
                      ,style: TextStyle(
                        fontWeight: FontWeight.bold,

                      ),),
                    SizedBox(width: 2.0,),
                    Text(": posted on ${item["createdAt"].toString().substring(0,10)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.grey
                      ),)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child:Form(
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
                        Text("Search",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ],
                    ),
                    SizedBox(height: 30.0,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        decoration: textDecoration.copyWith(hintText: "title", fillColor: Colors.blue[100], enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(12.0))),
                        onChanged: (val){
                          setState(() {
                             word = val;
                          });
                        },
                        validator: (val)=> val.isEmpty? "Write Something": null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Center(
                        child: InkWell(
                            onTap: (){
                              if(_formKey.currentState.validate()){
                                search(word);
                              }
                            },
                          child: Container(
                              width: 60.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Center(child: Text("Search", style:TextStyle( color:  Colors.white)))
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 20.0, thickness: 1.5, endIndent: 20, indent: 20,
                    ),
                    if(data.isNotEmpty) ...List.generate(data.length, (index) => _buildList(data[index]))
                    else if(message == " ") Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article, size: 50, color: Colors.grey[500],),
                          Text("Search for an article", style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[500]
                          ))
                        ],
                      )),
                    )
                    else if( message != null && message != " ") Center(child: Text("$message", style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[500]
                      )))

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
