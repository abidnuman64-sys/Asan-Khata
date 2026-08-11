class Expense {
  final int id;
  final String category;
  final String name;
  final double amount;
  final String date;

  Expense({
    required this.id,
    required this.category,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'amount': amount,
      'date': date,
    };
  }
}
