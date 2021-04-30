import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup_login_template_v1/fetched_data/All_users.dart';


class SpecificArticle extends StatefulWidget {
  @override
  _SpecificArticleState createState() => _SpecificArticleState();
}

class _SpecificArticleState extends State<SpecificArticle> {
  Map<String,dynamic> data = {};
  String message;


  void getUser(int id) async {
    AllUsers user = AllUsers();
    await user.getToken();
    await user.get_specific_user(id);
    Navigator.pushNamed(context, "user", arguments:{
      "user":user.user,
      "message": user.message
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    message = data["message"];
    data = data["article"];

    return Scaffold(
      body: SingleChildScrollView(
        child: message != null?Center(
          child: Text("$message", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,

          ))
        ): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               data["image"] != null? Container(
               height: 250,
               decoration: BoxDecoration(
                  image: DecorationImage(
                  image: NetworkImage(data["image"]),
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
              Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child:
                  Text("${data["header"]}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20.0,
                    fontWeight: FontWeight.bold
                      )),

                ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(": posted on ${data["createdAt"].toString().substring(0,10)}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[600]
                    )),
              ),
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child:InkWell(
                  onTap: (){
                    getUser(data["owner"]);
                  },
                  child: Text("by ${data["username"]}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]
                      )),
                ),),
              Divider(height: 8.0, thickness: 1.0, endIndent: 20, indent: 20,),
              Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child:
                Text("     ${data["textArea"]}", style: TextStyle(
                    fontSize: 17.0,
                )),

              ),
          ],
        ),
      ),
    );
  }
}
