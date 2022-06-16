import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heeeun/model/Country.dart';
import 'dart:convert';
import 'package:country_codes/country_codes.dart';

import '../main.dart';

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
                      return const SignUpPage();
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
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      child: Container(
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
                  // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Forgot your password", style: TextStyle(fontSize: 11, color: focusColor),)
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  decoration: BoxDecoration(color: focusColor),
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        // _formKey.currentState?.save();
                        email = _emailController.text;
                        password = _passwordController.text;
                        print("email >>>>>>>>>>>>>$email");
                        print("password >>>>>>>>>>>>>$password");
                      },
                      child: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.white))
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                        child: Container(
                          height: 1.0, width: 500, color: Colors.black45,
                        )
                    ),
                    Flexible(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                            child: const Text("or Login with", style: TextStyle(fontSize: 10, color: Colors.white))
                        )
                    ),
                    Flexible(
                      flex: 5,
                        child: Container(
                          height: 1.0, width: 500, color: Colors.black45,
                        )
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Image.asset("assets/images/facebook.png", width: 50, height: 50)
                        ),
                        const Text("Facebook", style: TextStyle(fontSize: 9),)
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Image.asset("assets/images/google.png", width: 50, height: 50)
                        ),
                        const Text("Google", style: TextStyle(fontSize: 9),)
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Image.asset("assets/images/apple.png", width: 50, height: 50)
                        ),
                        const Text("Apple", style: TextStyle(fontSize: 9),)
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}

// 회원가입
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String username = "";
  String email = "";
  String nickname = "";
  String password = "";
  String country = "";
  String gender = "";
  bool isCheckedYear = false;
  bool isCheckedAccept = false;
  List<Country> countries = [];
  Country firstSelectCountry = Country();
  int firstSelectIndex = 0;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    _genderController.dispose();
  }

  // 국가정보 api 통신
  void getCountries() async {
    // 기기설정된 국가정보 조회
    await CountryCodes.init();
    final Locale deviceLocal = CountryCodes.getDeviceLocale()!;
    String localeCountryCode = deviceLocal.countryCode.toString();
    print("localCountryCode >>>>>>>>>> $localeCountryCode");

    var dio = Dio(
      BaseOptions(
        baseUrl: "https://pietaserver.azurewebsites.net",
        connectTimeout: 800000,   // 서버로부터 응답받을때까지의 시간을 의미함. 설정 시간을 초과할 경우 connectTimeout Exception 발생
        receiveTimeout: 800000    // 서버로부터 응답을 스트리밍? 으로 받는 중에 연결 지속시간을 의미. 연결 지속시간이 초과될 경우 receiveTimeout Exception 발생. ex) 파일다운로드
      )
    );

    var response = await dio.get("/user/countries");

    if(response.statusCode == 200) {
      Map countryMap = jsonDecode(response.toString());

      if(countryMap["list"] != null) {
        countryMap["list"].asMap().forEach((key, value) {
          Country country = Country.fromJson(value);
          countries.add(country);

          if(country.code == localeCountryCode) {
            firstSelectIndex = key;
            firstSelectCountry = country;
          }
        });
      }
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormFieldWidget(
                  title: "Username",
                  content: username,
                  hintText: "Please enter your username",
                  validateMessage: "No username entered.",
                  obscureText: false,
                  textEditingController: _usernameController
              ),
              TextFormFieldWidget(
                  title: "Email",
                  content: email,
                  hintText: "Please enter your email",
                  validateMessage: "No email entered.",
                  obscureText: false,
                  textEditingController: _emailController
              ),
              TextFormFieldWidget(
                  title: "Nickname",
                  content: nickname,
                  hintText: "Please enter your nickname",
                  validateMessage: "No nickname entered.",
                  obscureText: false,
                  textEditingController: _nicknameController
              ),
              TextFormFieldWidget(
                  title: "Password",
                  content: password,
                  hintText: "Please enter your password",
                  validateMessage: "No password entered.",
                  obscureText: true,
                  textEditingController: _passwordController
              ),
              TextFormButtonWidget(
                title: "Country",
                textEditingController: _countryController,
                firstSelectedCountry: firstSelectCountry.korCommon,
                voidCallback: () {
                 List<Country> list = [];
                 for (var country in countries) {list.add(country);}
                 ShowCupertinoModalPopupWidget()._showActionSheet(context, "Country", list, firstSelectIndex, (index) {
                   setState(() {
                     firstSelectCountry = countries[index];
                     firstSelectIndex = index;
                   });
                 });
                },
              ),
              TextFormFieldWidget(
                  title: "Gender",
                  content: gender,
                  hintText: "Please enter your gender",
                  validateMessage: "No gender entered.",
                  obscureText: false,
                  textEditingController: _genderController
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30, bottom: 50),
                child: const Text("Please take a few minutes to read and understand.", style: TextStyle(fontSize: 17, color: Colors.white),),
              ),
              CheckBoxWidget(
                  title: "I am at least 13 years old.",
                  isChecked: isCheckedYear,
                  voidCallback: (bool check) {
                    setState(() {
                      isCheckedYear = check;
                    });
                  },
              ),
              const SizedBox(height: 10),
              CheckBoxWidget(
                title: "I accept the Pieta Terms of Service.",
                isChecked: isCheckedAccept,
                voidCallback: (bool check) {
                  setState(() {
                    isCheckedAccept = check;
                  });
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 30),
                decoration: BoxDecoration(color: focusColor),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      username = _usernameController.text;
                      email = _emailController.text;
                      nickname = _nicknameController.text;
                      password = _nicknameController.text;
                      country = _countryController.text;
                      gender = _genderController.text;
                      print("username >>>>>>>>>>>>>$username");
                      print("email >>>>>>>>>>>>>$email");
                      print("nickname >>>>>>>>>>>>>$nickname");
                      print("password >>>>>>>>>>>>>$password");
                      print("country >>>>>>>>>>>>>$country");
                      print("gender >>>>>>>>>>>>>$gender");
                      print("isCheckedYear >>>>>>>>>>>>>$isCheckedYear");
                      print("isCheckedAccept >>>>>>>>>>>>>$isCheckedAccept");
                      getCountries();
                    },
                    child: const Text("Sign up", style: TextStyle(fontSize: 18, color: Colors.white))
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}

// 체크박스
class CheckBoxWidget extends StatelessWidget {
  CheckBoxWidget({Key? key, required this.title, required this.isChecked, required this.voidCallback}) : super(key: key);

  String title = "";
  bool isChecked = false;
  final VoidCallbackCheckBox voidCallback;


  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;
    return Row(
      children: [
        Container(
          // margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerLeft,
          height: 30,
          width: 40,
          child: Checkbox(
              activeColor: focusColor,      // 박스색깔
              checkColor: Colors.black,   // 체크모양
              value: isChecked,
              onChanged: (value) {
                voidCallback(value!);
              }
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.white))
      ],
    );
  }
}

// 입력하는 폼
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
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
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
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 0.6),
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

// 밑에서 올라오는 위젯
class TextFormButtonWidget extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final String firstSelectedCountry;
  final VoidCallback voidCallback;

  const TextFormButtonWidget({
    Key? key,
    required this.title,
    required this.firstSelectedCountry,
    required this.textEditingController,
    required this.voidCallback
  }) : super(key: key);

  @override
  State<TextFormButtonWidget> createState() => _TextFormButtonWidgetState();
}

class _TextFormButtonWidgetState extends State<TextFormButtonWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color focusColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: Text(widget.title, style: TextStyle(
              color: isSelected ? focusColor : Colors.white,
              fontSize: 14,
              letterSpacing: 0.6
          )
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? focusColor : Colors.black45, width: 1.2))),
              child: TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0), alignment: Alignment.centerLeft),
                onPressed: () {
                  setState(() => isSelected = !isSelected);
                  widget.voidCallback();
                },
                child: Text(widget.firstSelectedCountry, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ShowCupertinoModalPopupWidget {
  void _showActionSheet(BuildContext context, String title, List contents, int firstCountryIndex, ListCallback listCallback) {
    Color focusColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    Color greyColor = Colors.grey;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Material(
              child: Container(
                color: canvasColor,
                height: 400,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(    // 맨 위 짧은 바
                      color: canvasColor,
                      width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: Container(   // 짧은거
                        margin: const EdgeInsets.only(top: 10),
                        width: 80,
                        height: 4,
                        color: greyColor,
                      ),
                    ),
                    Expanded(     // 제목
                      flex: 1,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(title, style: const TextStyle(fontSize: 30, color: Colors.white, letterSpacing: 1.2)),
                      ),
                    ),
                    Expanded(     // 내용
                      flex: 2,
                      child: SizedBox(
                        height: 200,
                        child: CupertinoPicker(
                          useMagnifier: true,
                          scrollController: FixedExtentScrollController(initialItem: firstCountryIndex),
                          itemExtent: 50,
                          onSelectedItemChanged: (i) {
                            listCallback(i);
                          },
                          children: contents.map((l) =>
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(l.korCommon, style: const TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 1.2))
                              )
                          ).toList(),
                        ),
                      ),
                    ),
                    Expanded(     // 취소 확인 버튼
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: greyColor,
                                  child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Back", style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 1.2),)
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: focusColor,
                                  child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Confirm", style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 1.2),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}
