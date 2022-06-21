
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heeeun/model/User.dart';
import 'package:extended_image/extended_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class ProfileAct extends StatefulWidget {
  const ProfileAct({Key? key}) : super(key: key);

  @override
  State<ProfileAct> createState() => _ProfileActState();
}

class _ProfileActState extends State<ProfileAct> {

  User user = User();
  final List<String> tabs = ["Post", "NFT", "Deal"];
  final ScrollController _scrollController = ScrollController();
  String appBarTitle = "Profile";
  final String userId = "e8d192ca-bf02-45ff-b0ea-961b4d84a671";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 스크롤 범위에 따라 앱바 title 변경
      setState(() {
        appBarTitle = _scrollController.offset > 150 ? user.nickName : "Profile";
      });
    });
    getUser();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

    var response = await dio.get("/user/$userId");

    if(response.statusCode == 200) {
      Map responseMap = jsonDecode(response.toString());
      if(responseMap["list"] != null) {
        user = User.fromJson(responseMap["list"]);
      }
    }
    setState(() {});
  }

  TabBar get _tabBar => TabBar(
    tabs: tabs.map((e) =>
          Tab(text: e)
      ).toList(),
    indicator: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        color: Theme.of(context).canvasColor
    ),
    labelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6, fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6),
  );

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double expandedHeight = deviceHeight * 0.35;

    // String appBarText = _scrollController.offset > 250 ? user.name : "Profile";




    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget> [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    // toolbarHeight: 30,
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
                      child: Text(appBarTitle, style: TextStyle(letterSpacing: 0.6, fontSize: 25)),
                    ),
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      // titlePadding: EdgeInsetsDirectional.only(start: 32, end: 16),
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle
                      ],
                      centerTitle: true,
                      background: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            SizedBox(height: expandedHeight * 0.25),
                            UserInfoWidget(thumbnail: user.thumbnail, nickName: user.nickName, name: user.name, gender: user.gender, country: user.country),
                            UserCountWidget(likeCount: user.likeCount, followerCount: user.followerCount, followingCount: user.followingCount),
                            FollowButtonWidget(isFollowing: user.isFollowing, voidCallback: () {
                              setState(() {
                              user.isFollowing = !user.isFollowing;
                              });
                            }),
                            const SizedBox(height: 40,)
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                        preferredSize: _tabBar.preferredSize,
                        child: Material(
                          color: canvasColor,
                          child: _tabBar,
                        )
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
                children: tabs.map((e) {
                  if(e == "Post") {
                    return UserPostPage(userId: userId);
                  } else if (e == "NFT"){
                    return UserPostPage(userId: userId);
                  } else {      // Deal
                    return UserPostPage(userId: userId);
                  }
                }).toList()
            ),
          )
        )
    );
  }
}

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({
    Key? key,
    required this.thumbnail,
    required this.nickName,
    required this.name,
    required this.gender,
    required this.country
  }) : super(key: key);

  final String thumbnail;
  final String nickName;
  final String name;
  final int gender;
  final String country;


  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

// 앱바에 맨위 상단 유저정보
class _UserInfoWidgetState extends State<UserInfoWidget> {

  @override
  Widget build(BuildContext context) {

    String genderString;

    if (widget.gender == 0) {
      genderString = "여성";
    } else if (widget.gender == 1) {
      genderString = "남성";
    } else {
      genderString = "그 외";
    }

    return Expanded(
        flex: 5,
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 80,
                        width: 80,
                        child: ExtendedImage.network(
                          widget.thumbnail,
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                          // cache: true,
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
                        child: Text(widget.nickName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        child: Text(widget.name, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                      ),
                      SizedBox(
                        child: Text("$genderString | ${widget.country}", style: const TextStyle(fontSize: 13, color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

// 앱바의 like, followers, following
class UserCountWidget extends StatefulWidget {
  const UserCountWidget({
    Key? key,
    required this.likeCount,
    required this.followerCount,
    required this.followingCount
  }) : super(key: key);

  final int likeCount;
  final int followerCount;
  final int followingCount;


  @override
  State<UserCountWidget> createState() => _UserCountWidgetState();
}

class _UserCountWidgetState extends State<UserCountWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        // color: Colors.blue,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.likeCount.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                const Text("Like", style: TextStyle(fontSize: 12, color: Colors.grey),)
              ],
            ),
            Container(height: 10, width: 2, color: Colors.black38,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.followerCount.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                const Text("Followers", style: TextStyle(fontSize: 13, color: Colors.grey))
              ],
            ),
            Container(height: 10, width: 2, color: Colors.black38,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.followingCount.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text("Following", style: TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Following/Follow 버튼
class FollowButtonWidget extends StatefulWidget {
  const FollowButtonWidget({
    Key? key,
    required this.isFollowing,
    required this.voidCallback
  }) : super(key: key);

  final bool isFollowing;
  final VoidCallback voidCallback;


  @override
  State<FollowButtonWidget> createState() => _FollowButtonWidgetState();
}

class _FollowButtonWidgetState extends State<FollowButtonWidget> {
  @override
  Widget build(BuildContext context) {

    String buttonText = widget.isFollowing ? "Following" : "Follow";
    Color buttonColor = widget.isFollowing ? Colors.white12 : Theme.of(context).primaryColor;

    return Expanded(   // Following/Follow 버튼
        flex: 4,
        child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 25),
          width: double.infinity,
          color: buttonColor,
          child: TextButton(
            onPressed: () {
              widget.voidCallback();
            },
            child: Text(buttonText, style: const TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 1)),
          ),
        )
    );
  }
}

class UserPostPage extends StatefulWidget {
  UserPostPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<UserPostPage> createState() => _UserPostPageState();
}

class _UserPostPageState extends State<UserPostPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  int pageCnt = 1;

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  getUserPost() async {
    var dio = Dio(
        BaseOptions(
            baseUrl: "https://pietaserver.azurewebsites.net",
            connectTimeout: 800000,   // 서버로부터 응답받을때까지의 시간을 의미함. 설정 시간을 초과할 경우 connectTimeout Exception 발생
            receiveTimeout: 800000    // 서버로부터 응답을 스트리밍? 으로 받는 중에 연결 지속시간을 의미. 연결 지속시간이 초과될 경우 receiveTimeout Exception 발생. ex) 파일다운로드
        )
    );
    
    var response = await dio.get("/post/${widget.userId}/page/$pageCnt");


  }

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;

    // InkWell, GestureDetector: Gesture 을 감지할 수 없는 widget 에게 Gesture 기능을 부여할 수 있는 위젯
    // Gesture: 사용자의 동작(클릭, 터블 클릭, 오래누르기 등) 을 감지하는 것

    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      // color: canvasColor,
      width: double.infinity,
      child: SmartRefresher(
        controller:
            _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () { print("POST 상세 클릭함");},
                child: ZoomOverlay(
                    minScale: 0.5,
                    maxScale: 3.0,
                    twoTouchOnly: true,
                    child: ExtendedImage.network(
                      "https://sqlva6ss7nz5uarf2w.blob.core.windows.net/e8d192ca-bf02-45ff-b0ea-961b4d84a671/Thumbnail20220421_075223236.jpg",
                      // width: 100,
                      // height: 100,
                    )
                )
              );
            }
        ),
      ),
    );
  }
}

