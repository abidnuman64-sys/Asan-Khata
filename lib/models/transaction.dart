class LedgerTransaction {
  final int id;
  final int partyId;
  final String type; // 'gave' or 'got'
  final double amount;
  final String note;
  final String date;
  final String mode;

  LedgerTransaction({
    required this.id,
    required this.partyId,
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
    required this.mode,
  });

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? DateTime.now().millisecondsSinceEpoch;
    } else {
      parsedId = DateTime.now().millisecondsSinceEpoch;
    }

    int parsedPartyId = 0;
    if (json['partyId'] is int) {
      parsedPartyId = json['partyId'];
    } else if (json['partyId'] != null) {
      parsedPartyId = int.tryParse(json['partyId'].toString()) ?? 0;
    }

    double parsedAmount = 0.0;
    if (json['amount'] is num) {
      parsedAmount = (json['amount'] as num).toDouble();
    } else if (json['amount'] != null) {
      parsedAmount = double.tryParse(json['amount'].toString()) ?? 0.0;
    }

    return LedgerTransaction(
      id: parsedId,
      partyId: parsedPartyId,
      type: json['type']?.toString() ?? 'gave',
      amount: parsedAmount,
      note: json['note']?.toString() ?? '',
      date: json['date']?.toString() ?? DateTime.now().toString().substring(0, 10),
      mode: json['mode']?.toString() ?? 'نقد',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partyId': partyId,
      'type': type,
      'amount': amount,
      'note': note,
      'date': date,
      'mode': mode,
    };
  }
}
