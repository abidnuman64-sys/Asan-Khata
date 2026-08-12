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
    double parsedQty = 1.0;
    if (json['qty'] is num) {
      parsedQty = (json['qty'] as num).toDouble();
    } else if (json['qty'] != null) {
      parsedQty = double.tryParse(json['qty'].toString()) ?? 1.0;
    }

    double parsedPrice = 0.0;
    if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toDouble();
    } else if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    return BillItem(
      name: json['name']?.toString() ?? 'آئٹم',
      qty: parsedQty,
      price: parsedPrice,
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
    double parseNum(dynamic val) {
      if (val is num) return val.toDouble();
      if (val != null) return double.tryParse(val.toString()) ?? 0.0;
      return 0.0;
    }

    return BillTotals(
      subtotal: parseNum(json['subtotal']),
      tax: parseNum(json['tax']),
      discount: parseNum(json['discount']),
      grandTotal: parseNum(json['grandTotal']),
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
  final dynamic id;
  final String billNumber;
  final String date;
  final String customerName;
  final String customerPhone;
  final dynamic partyId;
  final String partyName;
  final String phone;
  final String status;
  final List<BillItem> items;
  final BillTotals totals;
  final String paymentMode;

  SavedBill({
    required this.id,
    this.billNumber = '',
    required this.date,
    this.customerName = '',
    this.customerPhone = '',
    this.partyId,
    this.partyName = '',
    this.phone = '',
    this.status = 'paid',
    required this.items,
    required this.totals,
    this.paymentMode = 'نقد',
  });

  factory SavedBill.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<BillItem> parsedItems = rawItems.map((i) => BillItem.fromJson(Map<String, dynamic>.from(i))).toList();

    var rawTotals = json['totals'] is Map ? Map<String, dynamic>.from(json['totals']) : <String, dynamic>{};

    return SavedBill(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      billNumber: json['billNumber']?.toString() ?? 'INV-001',
      date: json['date']?.toString() ?? DateTime.now().toString().substring(0, 10),
      customerName: json['customerName']?.toString() ?? json['partyName']?.toString() ?? 'عام گاہک',
      customerPhone: json['customerPhone']?.toString() ?? json['phone']?.toString() ?? '',
      partyId: json['partyId'],
      partyName: json['partyName']?.toString() ?? json['customerName']?.toString() ?? 'عام گاہک',
      phone: json['phone']?.toString() ?? json['customerPhone']?.toString() ?? '',
      status: json['status']?.toString() ?? 'paid',
      items: parsedItems,
      totals: BillTotals.fromJson(rawTotals),
      paymentMode: json['paymentMode']?.toString() ?? 'نقد',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billNumber': billNumber,
      'date': date,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'partyId': partyId,
      'partyName': partyName,
      'phone': phone,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'totals': totals.toJson(),
      'paymentMode': paymentMode,
    };
  }
}
