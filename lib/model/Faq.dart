
class Faq {
  bool isSelected = false;
  int id = 0;
  String title = "";
  String contents = "";

  Faq.fromJson(Map<String, dynamic> map) :
        isSelected = map["isSelected"],
        id = map["id"],
        title = map["title"],
        contents = map["contents"];

  Map<String, dynamic> toJson() =>
      {
        "isSelected": isSelected,
        "id": id,
        "title": title,
        "contents": contents
      };
}