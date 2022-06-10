import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:heeeun/util/BaseAppBar.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import '../model/Faq.dart';

// StatelessWidget 과 StatefulWidget 의 차이점
// StatelessWidget 은 build 메서드에서 생성한 객체를 바로 반환하지만
// StatefulWidget 은 이 createState() 메서드에서 생성한 객체를 반환한다.
class FaqAct extends StatefulWidget {
  const FaqAct({Key? key}) : super(key: key);

  // createState() 메서드는 반드시 State 타입의 객체를 리턴해야함.
  // createState() 메서드는 StateFulWidget 위젯이 생성될때마다 호출됨.
  @override
  State<StatefulWidget> createState() {
    return _FaqActState();
  }
}

class _FaqActState extends State<FaqAct> {
  @override
  void initState() {
    super.initState();
  }

  // 위로 슬라이드 하면 refresh 가 된다. (새로고침)
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      dummyDataList.forEach((f) => f.isSelected = false);
    });

    _refreshController.refreshCompleted();
  }

  // 무한스크롤
  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  // 더미데이터
  List<Faq> dummyDataList = [
    Faq.fromMap({
      "isSelected": false,
      "id": 1,
      "title": "What is Lorem Ipsum?",
      "contents": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 2,
      "title": "Why do we use it?",
      "contents": "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy."
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 3,
      "title": "Where does it come from?",
      "contents": "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from 'de Finibus Bonorum et Malorum' by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 4,
      "title": "Where can I get some?",
      "contents": "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 5,
      "title": "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur,",
      "contents": "Aenean elementum viverra vestibulum. Praesent sed erat elementum, venenatis ex vehicula, tempor nulla. Ut commodo nunc ut lobortis porta. Cras augue dolor, dictum vitae hendrerit facilisis, varius ac lectus. Sed aliquam dictum purus, elementum vestibulum ligula maximus nec. Sed venenatis hendrerit erat, nec imperdiet lacus ultricies ac. Donec placerat dolor id turpis ultrices, vel dignissim dolor ullamcorper. Vestibulum ac erat quis leo tempus dictum id ut neque."
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 6,
      "title": "What is Lorem Ipsum?",
      "contents": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    }),
    Faq.fromMap({
      "isSelected": false,
      "id": 7,
      "title": "Why do we use it?",
      "contents": "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy."
    })
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BaseAppBar(appBar: AppBar(), title: "FAQ", isBack: true),
      body: Container(
        padding: const EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 20),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,   // 아래로 당겨서 새로고침 할 수 있게 할건지의 유무를 결정
          enablePullUp: true,    // 위로 당겨서 새로운 데이터를 불러올수 있게 할건지의 유무를 결정
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
              itemCount: dummyDataList.length,
              itemBuilder: (context, index) {
                return FaqItem(
                    index: index,
                    faq: dummyDataList[index],
                    listCallback: () {
                      setState(() {
                        dummyDataList[index].isSelected = !dummyDataList[index].isSelected;
                      });
                    }
                );
              }
          ),
        ),
      ),
    );
  }
}


class FaqItem extends StatelessWidget {
  const FaqItem({Key? key, required this.index, required this.faq, required this.listCallback}) : super(key: key);

  final Faq faq;
  final VoidCallback listCallback;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center
              ),
              onPressed: () => listCallback(),
              child: Container(
                color: Colors.black45,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Container(
                                child: const Text("Q", style: TextStyle(fontSize: 18, color: Colors.white)),
                              )
                          ),
                          Flexible(
                              flex: 12,
                              child: Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: faq.isSelected
                                    ? Text(faq.title, textAlign: TextAlign.left, style: const TextStyle(fontSize: 15, color: Colors.white))
                                    : Text(faq.title, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.left, style: const TextStyle(fontSize: 15, color: Colors.white)),
                              ),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text("A", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey)),
                          ),
                          Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 15, right: 15),
                                child: faq.isSelected
                                    ? Text(faq.contents, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.w400, height: 1.3, fontSize: 13, color: Colors.grey))
                                    : Text(faq.contents, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w400, height: 1.3, fontSize: 13, color: Colors.grey)),
                              )
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: faq.isSelected
                                ? const Icon(CupertinoIcons.chevron_up, color: Colors.redAccent, size: 15)
                                : const Icon(CupertinoIcons.chevron_down, color: Colors.redAccent, size: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}