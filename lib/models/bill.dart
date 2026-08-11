class BillItem {
  String name;
  double qty;
  double price;

  BillItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  double get total => qty * price;

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      name: json['name'],
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'price': price,
    };
  }
}

class BillTotals {
  final double subtotal;
  final double tax;
  final double discount;
  final double grandTotal;

  BillTotals({
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.grandTotal,
  });

  factory BillTotals.fromJson(Map<String, dynamic> json) {
    return BillTotals(
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'grandTotal': grandTotal,
    };
  }
}

class SavedBill {
  final int id;
  final int partyId;
  final String partyName;
  final String phone;
  final List<BillItem> items;
  final BillTotals totals;
  final String status; // 'Paid', 'Unpaid', 'Partial'
  final String date;

  SavedBill({
    required this.id,
    required this.partyId,
    required this.partyName,
    required this.phone,
    required this.items,
    required this.totals,
    required this.status,
    required this.date,
  });

  factory SavedBill.fromJson(Map<String, dynamic> json) {
    return SavedBill(
      id: json['id'],
      partyId: json['partyId'],
      partyName: json['partyName'],
      phone: json['phone'],
      items: (json['items'] as List).map((i) => BillItem.fromJson(i)).toList(),
      totals: BillTotals.fromJson(json['totals']),
      status: json['status'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partyId': partyId,
      'partyName': partyName,
      'phone': phone,
      'items': items.map((i) => i.toJson()).toList(),
      'totals': totals.toJson(),
      'status': status,
      'date': date,
    };
  }
}
