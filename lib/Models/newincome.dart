class NewIncomeModel {
  final String title;
  final int cost;

  NewIncomeModel({required this.title, required this.cost});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cost': cost,
    };
  }
}
