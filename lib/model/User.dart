// 유저
import '../util/Constants.dart';

class User {
  String seqId = emptyString;
  String name = emptyString;
  String firstName = emptyString;
  String lastName = emptyString;
  String nickName = emptyString;
  String thumbnail = emptyString;
  String email = emptyString;
  String country = emptyString;
  int gender = 0;
  String comment = emptyString;
  int likeCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  int postCount = 0;
  int nftCount = 0;
  int wtbCount = 0;
  int userType = 0;
  bool isFreeFee = false;
  int freeFeeCount = 0;

  User();

  User.fromJson(Map<String, dynamic> map) :
        seqId = map["seq_id"],
        name = map["name"],
        firstName = map["firstname"],
        lastName = map["lastname"],
        nickName = map["nickname"],
        thumbnail = map["thumbnail"],
        email = map["email"],
        country = map["country"],
        gender = map["gender"],
        comment = map["comment"],
        likeCount = map["like_count"],
        followerCount = map["follower_count"],
        followingCount = map["following_count"],
        isFollowing = map["is_following"],
        postCount = map["post_count"],
        nftCount = map["nft_count"],
        wtbCount = map["wtb_count"],
        userType = map["user_type"],
        isFreeFee = map["is_free_fee"],
        freeFeeCount = map["free_fee_count"];


}