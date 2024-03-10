// incomeModel.dart
class IncomeModel {
  String? sId;
  String? userIncomeId;
  String? title;
  int? cost;
  String? createdAt;
  String? updatedAt;
  int? iV;

  IncomeModel({
    this.sId,
    this.userIncomeId,
    this.title,
    this.cost,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      sId: json['_id'],
      userIncomeId: json['userIncomeId'],
      title: json['title'],
      cost: json['cost'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    data['userIncomeId'] = this.userIncomeId;
    data['title'] = this.title;
    data['cost'] = this.cost;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
