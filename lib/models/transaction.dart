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
    return LedgerTransaction(
      id: json['id'],
      partyId: json['partyId'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      note: json['note'],
      date: json['date'],
      mode: json['mode'],
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
