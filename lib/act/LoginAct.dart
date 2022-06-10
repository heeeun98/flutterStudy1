import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAct extends StatefulWidget {
  const LoginAct({Key? key}) : super(key: key);

  @override
  State<LoginAct> createState() => _LoginActState();
}


class _LoginActState extends State<LoginAct> {
  // late TabController _tabController;

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
                       centerTitle: true,
                       backgroundColor: Theme.of(context).backgroundColor,
                       title: Container(
                         alignment: Alignment.center,
                         child: const Text("Login & Sign up", style: TextStyle(letterSpacing: 2, fontSize: 25)),
                       ),
                       pinned: true,          // 고정
                       expandedHeight: 150.0, // SliverAppBar 높이
                       floating: true,        // 앱바 없애고 탭바만 남김
                       forceElevated: innerBoxIsScrolled,
                       leading: TextButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Icon(
                           CupertinoIcons.arrowshape_turn_up_left_fill,
                           color: Colors.grey,
                           size: 20,
                         )
                       ),
                       bottom: TabBar(
                           // controller: _tabController,
                           indicatorColor: Colors.red,
                           indicatorWeight: 3,
                           tabs: tabs.map((e) => Tab(text: e)).toList(),
                           unselectedLabelColor: Colors.grey,
                       )
                     )
                  )
                ];
              },
              body: TabBarView(
                  children: tabs.map((e) {
                    if(e == "Login") {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: const Text("Email", style: TextStyle(color: Colors.red, fontSize: 20)),
                              ),
                              Container(
                                height: 40,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                // decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                                // margin: const EdgeInsets.only(top: 100),
                                child: TextFormField(
                                  // decoration: const InputDecoration(
                                  //     labelText: "Email",
                                  //     labelStyle: TextStyle(color: Colors.white, fontSize: 30),
                                  //     // hintText: "Please enter your Email",
                                  //     focusColor: Colors.red,
                                  //
                                  //
                                  // ),
                                  cursorHeight: 20,
                                  textInputAction: TextInputAction.next,
                                  // cursorColor: Colors.red,
                                  strutStyle: StrutStyle.disabled,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      print( "값 입력 안했어 >>>>>>>>");
                                      return 'Please enter some text';
                                    }
                                    print(value + "값 입력했어 >>>>>>>");
                                    return null;
                                  },
                                )
                                // const Text("Email", style: TextStyle(color: Colors.white)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Password",
                                      // hintText: "Please enter your Password",
                                      labelStyle: TextStyle(color: Colors.white, fontSize: 30),
                                  ),
                                  textInputAction: TextInputAction.next,
                                )
                              )
                            ],
                          ),
                        ),
                      );
                      // return Container(
                      //     color: Colors.blue
                      // );
                    } else {
                      return Container(color: Colors.red);
                    }
                  }).toList()
              ),
          ),
        )
    );
  }
}
