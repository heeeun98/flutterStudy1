
// 국가정보
class Country {
  int seqId = 0;
  String code = "";
  String engCommon = "";
  String korCommon = "";

  // Country(this.seqId, this.code, this.engCommon, this.korCommon);
  Country();

  // map 구조에서 새로운 User 객체를 생성하기 위한 생성자인 User.fromJson() 생성자
  Country.fromJson(Map<String, dynamic> map) :
        seqId = map["seq_id"],
        code = map["code"],
        engCommon = map["eng_common"],
        korCommon = map["kor_common"];

  // User 객체를 map 구조로 변환하기 위한 메서드인 toJson() 메서드
  Map<String, dynamic> toJson() =>
      {
        "seq_id": seqId,
        "code": code,
        "eng_common": engCommon,
        "kor_common": korCommon
      };
}