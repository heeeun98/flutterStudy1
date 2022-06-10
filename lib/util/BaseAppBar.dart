import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key? key, required this.appBar, required this.title, required this.isBack}) : super(key: key);

  final AppBar appBar;
  final String title;
  final bool isBack;

  @override
  Widget build(BuildContext context) {

    // 버튼 눌렀을때 창뜨는거
    void buttonDialog() {
      showDialog(
          context: context,
          barrierDismissible: false, // Dialog 를 제외한 다른 화면 터치 X
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: const Text("이동할 곳이 없습니다."),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("닫기")
                )
              ],
            );
          }
      );
    }

    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white, letterSpacing: 2)),
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: true,
      toolbarHeight: 70,
      elevation: 0,
      leading: TextButton(
          onPressed: () {
            isBack ? Navigator.pop(context) : buttonDialog();
          },
          child: const Icon(
            CupertinoIcons.arrowshape_turn_up_left_fill,
            color: Colors.grey,
            size: 20,
          )
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}