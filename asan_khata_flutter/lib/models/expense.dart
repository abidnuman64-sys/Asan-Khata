class Expense {
  final int id;
  final String category; // 'Stock', 'Rent', 'Utilities', 'Salaries', 'Other'
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'name': name,
    'amount': amount,
    'date': date,
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    category: json['category'],
    name: json['name'],
    amount: (json['amount'] as num).toDouble(),
    date: json['date'],
  );
}
