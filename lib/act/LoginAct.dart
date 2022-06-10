import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAct extends StatefulWidget {
  const LoginAct({Key? key}) : super(key: key);

  @override
  State<LoginAct> createState() => _LoginActState();
}

class _LoginActState extends State<LoginAct> {
  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    final List<String> tabs = ["Login", "Sign up"];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: GestureDetector(  // 키보드 영역외에 터치했을 경우 키보드 사라지게 함.
            onTap: () => FocusScope.of(context).unfocus(),
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget> [
                  SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverAppBar(
                          centerTitle: true,
                          backgroundColor: Theme.of(context).canvasColor,
                          title: Container(
                            alignment: Alignment.bottomCenter,
                            child: const Text("", style: TextStyle(letterSpacing: 0.6, fontSize: 25)),
                          ),
                          pinned: true,          // 고정
                          expandedHeight: 150.0, // SliverAppBar 높이
                          floating: true,        // 앱바 없애고 탭바만 남김
                          forceElevated: innerBoxIsScrolled,
                          leading: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Icon(
                                CupertinoIcons.arrow_left,
                                color: Colors.white,
                                size: 30,
                              )
                          ),
                          bottom: TabBar(
                            labelColor: focusColor,
                            // labelStyle: const TextStyle(fontSize: 18, letterSpacing: 0.6),
                            labelStyle: const TextStyle(fontSize: 15, letterSpacing: 0.6),
                            tabs: tabs.map((e) => Tab(text: e)).toList(),
                            indicator: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2, color: focusColor)),
                              color: Theme.of(context).canvasColor
                            ),
                            unselectedLabelColor: Colors.white,
                          )
                      )
                  )
                ];
              },
              body: TabBarView(
                  children: tabs.map((e) {
                    if(e == "Login") {
                      return const LoginPage();
                    } else {
                      return Container(color: Theme.of(context).canvasColor);
                    }
                  }).toList()
              ),
            ),
          )
        )
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      child: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFieldWidget(
                    title: "Email",
                    content: email,
                    hintText: "Please enter your Email",
                    validateMessage: "No email entered.",
                    obscureText: false,
                    textEditingController: _emailController
                ),
                TextFormFieldWidget(
                    title: "Password",
                    content: password,
                    hintText: "Please enter your Password",
                    validateMessage: "No Password entered.",
                    obscureText: true,
                    textEditingController: _passwordController
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(color: focusColor),
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        // _formKey.currentState?.save();
                        email = _emailController.text;
                        password = _passwordController.text;
                        print("email >>>>>>>>>>>>>" + email);
                        print("password >>>>>>>>>>>>>" + password);
                      },
                      child: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.white))
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

class TextFormFieldWidget extends StatefulWidget {
  final String title;
  late String content;
  final String hintText;
  final String validateMessage;
  final bool obscureText;
  final TextEditingController textEditingController;

  TextFormFieldWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.hintText,
    required this.validateMessage,
    required this.obscureText,
    required this.textEditingController
  }) : super(key: key);


  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 30),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: Text(widget.title, style: TextStyle(
              color: isSelected ? focusColor : Colors.white,
              // fontSize: 30,
              fontSize: 14,
              letterSpacing: 0.6
          )
          ),
        ),
        Focus(
            onFocusChange: (has) => setState(() => isSelected = !isSelected),
            child: TextFormField(
              controller: widget.textEditingController,
              autovalidateMode: AutovalidateMode.always,
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black45)),
                  errorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black45)),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: focusColor)),
                  disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black45)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: focusColor)),
                  contentPadding: const EdgeInsets.only(top: 20), // hintText 위치 내려줌.
                  hintText: widget.hintText,
                  // hintStyle: const TextStyle(color: Colors.white54, fontSize: 13, letterSpacing: 0.6),
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 0.6),
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 11, letterSpacing: 0.6),
                  focusColor: Colors.black,
                  suffixIcon: isSelected
                      ? IconButton(
                      onPressed: () => setState(() => widget.textEditingController.text = ""),
                      icon: Icon(CupertinoIcons.clear_thick_circled, color: isSelected ? focusColor : Colors.white))
                      : null
              ),
              cursorHeight: 20,
              textInputAction: TextInputAction.next,  // 키보드에 다음 칸으로 넘어갈수있는 버튼 제공
              cursorColor: Colors.red,
              obscureText: widget.obscureText,
              validator: (value) => value == null || value.isEmpty ? widget.validateMessage : null,
              onSaved: (value) {
                setState(() {
                  widget.content = value!;
                });
              },
            )
        )
      ],
    );
  }
}
