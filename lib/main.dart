import 'package:flutter/material.dart';

import "package:bloc/bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:signup_login_template_v1/fetched_data/Search.dart';
import 'package:signup_login_template_v1/home/addArticle.dart';
import 'package:signup_login_template_v1/home/allArticles.dart';
import 'package:signup_login_template_v1/home/personal.dart';
import 'package:signup_login_template_v1/home/personalInfo.dart';
import 'package:signup_login_template_v1/home/searchPage.dart';
import 'package:signup_login_template_v1/home/specificArticle.dart';
import 'package:signup_login_template_v1/home/user_profile.dart';
import 'package:signup_login_template_v1/models/user_model.dart';
import "package:signup_login_template_v1/repository/user_repository.dart";

import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import "package:signup_login_template_v1/splash/splash.dart";
import "package:signup_login_template_v1/wrapper.dart";
import "package:signup_login_template_v1/home/home_page.dart";
import "package:signup_login_template_v1/shared/common.dart";


class SimpleBlocObserver extends BlocObserver{

  @override
  void onEvent(Bloc bloc, Object event){
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition){
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace){
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticateBloc>(
        create:(context){
          return AuthenticateBloc(userRepository: userRepository)..add(AppStarted());
        },
       child: MyApp(userRepository: userRepository)
    )
  );
}

class MyApp extends StatelessWidget {

  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings){
        var routes = <String, WidgetBuilder>{
          "addArticle": (ctx)=> AddArticle(settings.arguments),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx)=> builder(ctx));
      },
      routes: {
        "article": (context)=> SpecificArticle(),
        "home": (context) => HomePage(),
        "personalinfo": (context) => personalInfo(),
        "user": (context) => UserProfile(),
        "search": (context) => SearchItem()
      },
      home: BlocBuilder<AuthenticateBloc, AuthenticateState>(
        builder: (context, state){
          if(state is AuthenticateUninitialized){
            return SplashPage();
          }
          if(state is AuthenticateAuthenticated){
            return HomePage();
          }
          if(state is AuthenticateUnauthenticated) {
            return Wrapper(userRepository: userRepository);
          }
          if(state is AuthenticateLoading){
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

