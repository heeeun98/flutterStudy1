import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAct extends StatefulWidget {
  const LoginAct({Key? key}) : super(key: key);

  @override
  State<LoginAct> createState() => _LoginActState();
}


class _LoginActState extends State<LoginAct> {
  final String login = "Login";
  final String signUp = "Sign up";
  // final Map<dynamic, String> tabs = {login: "Login", "Sign up": "Sign up"};

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["Login", "Sign up"];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget> [
                  SliverOverlapAbsorber(
                     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                     sliver: SliverAppBar(
                       title: const Text("Login & Sign up"),
                       pinned: true,  // 고정
                       expandedHeight: 150.0,
                       forceElevated: innerBoxIsScrolled,
                       bottom: TabBar(tabs: tabs.map((e) => Tab(text: e)).toList())
                       // bottom: const TabBar(tabs: [Tab(text: "Login"), Tab(text: "Sign up")]),
                     )
                  )
                ];
              },
              body: TabBarView(
                  children:
              )
          ),
        )
    );
  }
}
