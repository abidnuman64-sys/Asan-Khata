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
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? DateTime.now().millisecondsSinceEpoch;
    } else {
      parsedId = DateTime.now().millisecondsSinceEpoch;
    }

    double parsedBalance = 0.0;
    if (json['balance'] is num) {
      parsedBalance = (json['balance'] as num).toDouble();
    } else if (json['balance'] != null) {
      parsedBalance = double.tryParse(json['balance'].toString()) ?? 0.0;
    }

    return Party(
      id: parsedId,
      name: json['name']?.toString() ?? 'نامعلوم گاہک',
      phone: json['phone']?.toString() ?? '',
      type: json['type']?.toString() ?? 'customer',
      balance: parsedBalance,
      lastDate: json['lastDate']?.toString() ?? DateTime.now().toString().substring(0, 10),
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
