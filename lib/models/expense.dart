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
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? DateTime.now().millisecondsSinceEpoch;
    } else {
      parsedId = DateTime.now().millisecondsSinceEpoch;
    }

    double parsedAmount = 0.0;
    if (json['amount'] is num) {
      parsedAmount = (json['amount'] as num).toDouble();
    } else if (json['amount'] != null) {
      parsedAmount = double.tryParse(json['amount'].toString()) ?? 0.0;
    }

    return Expense(
      id: parsedId,
      category: json['category']?.toString() ?? 'دیگر',
      name: json['name']?.toString() ?? 'خرچہ',
      amount: parsedAmount,
      date: json['date']?.toString() ?? DateTime.now().toString().substring(0, 10),
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
