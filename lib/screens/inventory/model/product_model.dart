

class TotalProductQuantityModel {
  String? productName;
  String? totalQuantity;
  String? totalPrice;
  String? date;
  String? time;

  TotalProductQuantityModel(
      {
        this.productName, this.totalPrice, this.totalQuantity, this.date, this.time});

  TotalProductQuantityModel.fromMap(Map<dynamic, dynamic> map) {

    productName = map['name'];
    totalQuantity = map['quantity'];
    totalPrice = map['cost'];
    date = map['date'];
    time = map['time'];

  }

  Map<dynamic, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = productName;
    data['quantity'] = totalQuantity;
    data['cost'] = totalPrice;
    data['date'] = date;
    data['time'] = time;

    return data;
  }
}