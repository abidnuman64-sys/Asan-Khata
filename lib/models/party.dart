class Party {
  final int id;
  final String name;
  final String phone;
  final String type; // 'customer' or 'supplier'
  double balance;
  String lastDate;

  Party({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.balance,
    required this.lastDate,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      balance: (json['balance'] as num).toDouble(),
      lastDate: json['lastDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'type': type,
      'balance': balance,
      'lastDate': lastDate,
    };
  }
}
