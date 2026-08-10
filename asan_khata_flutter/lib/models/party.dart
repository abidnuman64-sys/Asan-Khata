class Party {
  final int id;
  String name;
  String phone;
  String type; // 'customer' or 'supplier'
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'type': type,
    'balance': balance,
    'lastDate': lastDate,
  };

  factory Party.fromJson(Map<String, dynamic> json) => Party(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    type: json['type'],
    balance: (json['balance'] as num).toDouble(),
    lastDate: json['lastDate'],
  );
}
