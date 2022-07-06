
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:heeeun/act/LoginAct.dart';
import 'package:heeeun/model/User.dart';
import 'package:extended_image/extended_image.dart';
import 'package:heeeun/model/UserPost.dart';
import 'package:intl/intl.dart';
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
  int pageCnt = 1;
  List<UserPost> userPosts = [];
  int postCnt = 1;

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
    getUserPost();
    pageCnt;
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 유저 조회 api 통신
  getUser() async {
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

  // 유저 Post 조회 통신
  getUserPost() async {
    var dio = Dio(
        BaseOptions(
            baseUrl: "https://pietaserver.azurewebsites.net",
            connectTimeout: 800000,   // 서버로부터 응답받을때까지의 시간을 의미함. 설정 시간을 초과할 경우 connectTimeout Exception 발생
            receiveTimeout: 800000    // 서버로부터 응답을 스트리밍? 으로 받는 중에 연결 지속시간을 의미. 연결 지속시간이 초과될 경우 receiveTimeout Exception 발생. ex) 파일다운로드
        )
    );

    var response = await dio.get("/post/$userId", queryParameters: {"page": pageCnt});

    if(response.statusCode == 200) {
      Map userPostMap = jsonDecode(response.toString());
      postCnt = userPostMap["post_count"];

      if(userPostMap["list"] != null) {
        userPostMap["list"].forEach((element) {
          UserPost userPost = UserPost.fromJson(element);
          userPosts.add(userPost);
        });
      }
    }
    setState(() {});
  }

  TabBar get _tabBar => TabBar(
    tabs: tabs.map((e) =>
      Tab(
        child: Column(
          children: [
            const SizedBox(height: 4),
            Text(e, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
            const SizedBox(height: 6,),
            Text(e == "Post" ? postCnt.toString() : 0.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),)
          ],
        ),
      )
      ).toList(),
    labelColor: Colors.redAccent,
    indicator: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        color: Theme.of(context).canvasColor
    ),
    labelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6, fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6),
    unselectedLabelColor: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    Color canvasColor = Theme.of(context).canvasColor;
    double deviceHeight = MediaQuery.of(context).size.height;
    double expandedHeight = deviceHeight * 0.4;

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
                    title: Text(appBarTitle, style: const TextStyle(letterSpacing: 0.6, fontSize: 23)),
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
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
                            SizedBox(height: expandedHeight * 0.3),
                            UserInfoWidget(height: expandedHeight * 0.28, thumbnail: user.thumbnail, nickName: user.nickName, name: user.name, gender: user.gender, country: user.country),
                            SizedBox(height: expandedHeight * 0.01),
                            UserCountWidget(height: expandedHeight * 0.2, likeCount: user.likeCount, followerCount: user.followerCount, followingCount: user.followingCount),
                            SizedBox(height: expandedHeight * 0.02),
                            FollowButtonWidget(height: expandedHeight * 0.13, isFollowing: user.isFollowing, voidCallback: () {
                              setState(() {
                              user.isFollowing = !user.isFollowing;
                              });
                            }),
                            SizedBox(height: expandedHeight * 0.01),
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
                    return UserPostPage(userId: userId, userPosts: userPosts);
                  } else if (e == "NFT"){
                    return const NftPage();
                  } else {      // Deal
                    return const NftPage();
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
    required this.height,
    required this.thumbnail,
    required this.nickName,
    required this.name,
    required this.gender,
    required this.country
  }) : super(key: key);

  final double height;
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

    return Container(
      height: widget.height,
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: Row(
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: ExtendedImage.network(
              widget.thumbnail,
              fit: BoxFit.fill,
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
              width: 75,
              height: 75,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(widget.nickName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    child: Text(widget.name, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                  SizedBox(
                    child: Text("$genderString | ${widget.country}", style: const TextStyle(fontSize: 13, color: Colors.red)),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

// 앱바의 like, followers, following
class UserCountWidget extends StatefulWidget {
  const UserCountWidget({
    Key? key,
    required this.height,
    required this.likeCount,
    required this.followerCount,
    required this.followingCount
  }) : super(key: key);

  final double height;
  final int likeCount;
  final int followerCount;
  final int followingCount;


  @override
  State<UserCountWidget> createState() => _UserCountWidgetState();
}

class _UserCountWidgetState extends State<UserCountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.likeCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  const Text("Like", style: TextStyle(fontSize: 12, color: Colors.grey),)
                ],
              )
          ),
          Container(height: 45, width: 1, color: Colors.black38,),
          Expanded(
            flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.followerCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5,),
                  const Text("Followers", style: TextStyle(fontSize: 12, color: Colors.grey))
                ],
              )
          ),
          Container(height: 45, width: 1, color: Colors.black38,),
          Expanded(
            flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.followingCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Following", style: TextStyle(fontSize: 12, color: Colors.grey))
                ],
              )
          )
        ],
      ),
    );
  }
}


// Following/Follow 버튼
class FollowButtonWidget extends StatefulWidget {
  const FollowButtonWidget({
    Key? key,
    required this.height,
    required this.isFollowing,
    required this.voidCallback
  }) : super(key: key);

  final double height;
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

    return Container(
      height: widget.height,
      width: double.infinity,
      color: buttonColor,
      child: TextButton(
        onPressed: () {
          widget.voidCallback();
        },
        child: Text(buttonText, style: const TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1)),
      ),
    );
  }
}

// Post 페이지
class UserPostPage extends StatefulWidget {
  const UserPostPage({Key? key, required this.userId, required this.userPosts}) : super(key: key);

  final String userId;
  final List userPosts;

  @override
  State<UserPostPage> createState() => _UserPostPageState();
}

class _UserPostPageState extends State<UserPostPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // InkWell, GestureDetector: Gesture 을 감지할 수 없는 widget 에게 Gesture 기능을 부여할 수 있는 위젯
    // Gesture: 사용자의 동작(클릭, 터블 클릭, 오래누르기 등) 을 감지하는 것

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 130),
      width: double.infinity,
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            itemCount: widget.userPosts.length,
            dragStartBehavior: DragStartBehavior.start,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 30, ),
                child: InkWell(
                    onTap: () { print("POST 상세 클릭함");},
                    child: ZoomOverlay(
                        minScale: 0.5,
                        maxScale: 3.0,
                        twoTouchOnly: true,
                        child: Stack(
                          children: [
                            ExtendedImage.network(
                              widget.userPosts[index].artThumbnail,
                              fit: BoxFit.fill,
                              width: deviceWidth - 20,
                              height: deviceHeight - ( deviceHeight * 0.4),
                            ),
                            Container(
                              width: deviceWidth - 20,
                              height: deviceHeight - ( deviceHeight * 0.4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.transparent, Colors.transparent, Theme.of(context).shadowColor],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                left: 5,
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.zero,
                                          alignment: Alignment.bottomLeft,
                                          child: Text(widget.userPosts[index].postTitle, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600)),
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                alignment: Alignment.centerLeft,
                                                minimumSize: const Size(50, 30)
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.favorite_border, color: Colors.white, size: 15,),
                                                  const SizedBox(width: 5,),
                                                  Text(widget.userPosts[index].postLikeCnt.toString(), style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400))
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    alignment: Alignment.centerLeft,
                                                    minimumSize: const Size(50, 30)
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.comment, color: Colors.white, size: 15,),
                                                    const SizedBox(width: 5,),
                                                    Text(widget.userPosts[index].postCommentCnt.toString(), style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400))
                                                  ],
                                                )
                                            ),
                                            const Spacer(),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(DateFormat("MM월 dd일").format(DateTime.parse(widget.userPosts[index].postDate)), style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400)),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 1, width: deviceWidth - 40, color: Colors.white,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(top: 10),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(widget.userPosts[index].postContent, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                    )
                ),
              );
            }
        ),
      ),
    );
  }
}

class NftPage extends StatefulWidget {
  const NftPage({Key? key}) : super(key: key);

  @override
  State<NftPage> createState() => _NftPageState();
}

class _NftPageState extends State<NftPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}