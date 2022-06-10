import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heeeun/act/FaqAct.dart';
import 'package:heeeun/act/LoginAct.dart';

import '../util/BaseAppBar.dart';

enum MenuType {
  faq, noPage, loginAndSignUp
}

class SettingAct extends StatelessWidget {
  const SettingAct({Key? key}) : super(key: key);

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

    // 제목
    Widget titleContainer(String text) {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Text(text, textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      );
    }

    // 내용
    Widget menuContainer(String text, MenuType menuType) {
      return Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(left: 3, right: 3),
            decoration: const BoxDecoration(
                color: Colors.black45
            ),
            child: TextButton(
              onPressed: () {
                if(menuType == MenuType.faq) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqAct()));
                } else if (menuType == MenuType.loginAndSignUp) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginAct()));
                } else {
                  buttonDialog();
                }
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(text, textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    child: const Icon(
                      CupertinoIcons.chevron_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          )
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BaseAppBar(appBar: AppBar(), title: "Setting", isBack: false),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account
              titleContainer("Account"),
              menuContainer("Personal Information", MenuType.noPage),
              menuContainer("Artist Information", MenuType.noPage),
              menuContainer("Language", MenuType.noPage),
              menuContainer("Login & Sign up", MenuType.loginAndSignUp),
              // Preferences
              titleContainer("Preferences"),
              menuContainer("Notification", MenuType.noPage),
              menuContainer("FAQ", MenuType.faq),
              // Security
              titleContainer("Security"),
              menuContainer("Reset Password", MenuType.noPage),
              menuContainer("Reset Wallet Password", MenuType.noPage),
              menuContainer("Back up Secret Recovery Phase", MenuType.noPage),
              // About SRP
              titleContainer("About SRP"),
              menuContainer("Introduce SRP", MenuType.noPage),
            ],
          ),
        ),
      ),
    );
  }
}