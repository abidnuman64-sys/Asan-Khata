class LedgerTransaction {
  final int id;
  final int partyId;
  final String type; // 'gave' or 'got'
  final double amount;
  final String note;
  final String date;
  final String mode; // 'Cash', 'EasyPaisa', 'JazzCash', 'Bank'

  LedgerTransaction({
    required this.id,
    required this.partyId,
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'partyId': partyId,
    'type': type,
    'amount': amount,
    'note': note,
    'date': date,
    'mode': mode,
  };

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) => LedgerTransaction(
    id: json['id'],
    partyId: json['partyId'],
    type: json['type'],
    amount: (json['amount'] as num).toDouble(),
    note: json['note'] ?? '',
    date: json['date'],
    mode: json['mode'] ?? 'Cash',
  );
}
