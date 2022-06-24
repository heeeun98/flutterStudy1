
import 'package:heeeun/util/Constants.dart';

class UserPost {
  int postCnt = 0;
  String artType = emptyString;
  String artUrl = emptyString;
  String artThumbnail = emptyString;
  String postTitle = emptyString;
  String postContent = emptyString;
  int postLikeCnt = 0;
  int postCommentCnt = 0;
  String postDate = emptyString;
  bool isLike = false;

  UserPost.fromJson(Map<String, dynamic> map) {
    postLikeCnt = map["post_like_count"];
    postCommentCnt = map["post_comment_count"];
    postDate = map["post_regdt"];
    isLike = map["isLike"];
    postTitle = map["post_title"];
    postContent = map["post_contents"];

    if(map["post_artlist"] != null) {
      map["post_artlist"].forEach((detail) {
        artType = detail["art_type"];
        artUrl = detail["art_url"];
        artThumbnail = detail["art_thumbnail"];
      });
    }
  }
}