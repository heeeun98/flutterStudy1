
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heeeun/act/LoginAct.dart';
import 'package:heeeun/model/User.dart';
import 'package:extended_image/extended_image.dart';

class ProfileAct extends StatefulWidget {
  const ProfileAct({Key? key}) : super(key: key);

  @override
  State<ProfileAct> createState() => _ProfileActState();
}

class _ProfileActState extends State<ProfileAct> {

  User user = User();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // 유저 조회 api 통신
  void getUser() async {
    var dio = Dio(
        BaseOptions(
            baseUrl: "https://pietaserver.azurewebsites.net",
            connectTimeout: 800000,   // 서버로부터 응답받을때까지의 시간을 의미함. 설정 시간을 초과할 경우 connectTimeout Exception 발생
            receiveTimeout: 800000    // 서버로부터 응답을 스트리밍? 으로 받는 중에 연결 지속시간을 의미. 연결 지속시간이 초과될 경우 receiveTimeout Exception 발생. ex) 파일다운로드
        )
    );

    var response = await dio.get("/user/e8d192ca-bf02-45ff-b0ea-961b4d84a671");

    if(response.statusCode == 200) {
      Map responseMap = jsonDecode(response.toString());
      if(responseMap["list"] != null) {
        user = User.fromJson(responseMap["list"]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // precacheImage() 를 통해 홈화면을 빌드할 때 캐시에 미리 이미지를 넣어둠 (빠르다고함)
    precacheImage(ExtendedImage.network(user.thumbnail).image, context);

    Color focusColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double expandedHeight = deviceHeight * 0.35;
    final List<String> tabs = ["Post", "NFT", "Deal"];

    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget> [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    centerTitle: true,
                    backgroundColor: canvasColor,
                    pinned: true,   // 고정
                    expandedHeight: expandedHeight, // SliverAppBar 높이
                    floating: false, // 앱바 없애고 탭바만 남김
                    forceElevated: innerBoxIsScrolled,
                    leading: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.white,
                          size: 30,
                        )
                    ),
                    title: Container(
                      alignment: Alignment.bottomCenter,
                      child: const Text("Profile", style: TextStyle(letterSpacing: 0.6, fontSize: 25)),
                    ),
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle
                      ],
                      centerTitle: true,
                      // title: const Text("ddd"),
                      background: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            SizedBox(height: expandedHeight * 0.25),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 70,
                                              child: ExtendedImage.network(
                                                user.thumbnail,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.fill,
                                                cache: true,
                                                border: Border.all(color: Colors.white),
                                                shape: BoxShape.circle,
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Text(user.nickName, style: TextStyle(fontSize: 16)),
                                              ),
                                              SizedBox(
                                                child: Text(user.name, style: TextStyle(fontSize: 15)),
                                              ),
                                              SizedBox(
                                                child: Text("${user.gender} | ${user.country}", style: TextStyle(fontSize: 13, color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(top: 20, bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Spacer(),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Spacer(),
                                          Text(user.likeCount.toString()),
                                          Text("Like")
                                        ],
                                      ),
                                    ),
                                    Container(height: 10, width: 2, color: Colors.black38,),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(user.followerCount.toString()),
                                          const Text("Followers")
                                        ],
                                      ),
                                    ),
                                    Container(height: 10, width: 2, color: Colors.black38,),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(user.followingCount.toString()),
                                          Text("Following")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(   // Following/Follow 버튼
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: TextButton(
                                    // onPressed: () => Navigator.of(context).pop(),
                                    onPressed: () {
                                      print("seqId >>>>>>>>>>>> ${user.seqId}");
                                      print("name >>>>>>>>>>>> ${user.name}");
                                      print("thumbnail >>>>>>>>>>>> ${user.thumbnail}");
                                      print("country >>>>>>>>>>>> ${user.country}");
                                      print("gender >>>>>>>>>>>> ${user.gender}");
                                      print("followerCount >>>>>>>>>>>> ${user.followerCount}");
                                      print("postCount >>>>>>>>>>>> ${user.postCount}");
                                    },
                                    child: const Text("Following", style: TextStyle(fontSize: 20, color: Colors.white)),
                                  ),
                                )
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("자기소개같은거 들어가는 칸", style: TextStyle(fontSize: 15, color: Colors.white)),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      labelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6),
                      tabs: tabs.map((e) => Tab(text: e)).toList(),
                      indicator: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: focusColor)),
                          color: Theme.of(context).canvasColor
                      ),
                      unselectedLabelColor: Colors.white,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
                children: tabs.map((e) {
                  if(e == "Post") {
                    return const LoginPage();
                  } else if (e == "NFT"){
                    return const SignUpPage();
                  } else {      // Deal
                    return const SignUpPage();
                  }
                }).toList()
            ),
          )
        )
    );

  }
}
