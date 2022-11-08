class Combo {
  List<Packages>? packages;
  Shop? shop;
  double? time;
  double? distance;
  double? comboPrice;

  Combo(
      {this.packages, this.shop, this.time, this.distance, this.comboPrice});

  Combo.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    time = json['time'];
    distance = json['distance'];
    comboPrice = json['comboPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    data['time'] = this.time;
    data['distance'] = this.distance;
    data['comboPrice'] = this.comboPrice;
    return data;
  }
}

class Packages {
  String? id;
  String? startAddress;
  double? startLongitude;
  double? startLatitude;
  String? destinationAddress;
  double? destinationLongitude;
  double? destinationLatitude;
  String? receiverName;
  String? receiverPhone;
  double? distance;
  double? volume;
  double? weight;
  String? status;
  double? priceShip;
  String? photoUrl;
  String? note;
  String? createdAt;
  String? modifiedAt;
  String? shopId;
  Null? shipperId;
  List<Products>? products;

  Packages(
      {this.id,
        this.startAddress,
        this.startLongitude,
        this.startLatitude,
        this.destinationAddress,
        this.destinationLongitude,
        this.destinationLatitude,
        this.receiverName,
        this.receiverPhone,
        this.distance,
        this.volume,
        this.weight,
        this.status,
        this.priceShip,
        this.photoUrl,
        this.note,
        this.createdAt,
        this.modifiedAt,
        this.shopId,
        this.shipperId,
        this.products});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startAddress = json['startAddress'];
    startLongitude = json['startLongitude'];
    startLatitude = json['startLatitude'];
    destinationAddress = json['destinationAddress'];
    destinationLongitude = json['destinationLongitude'];
    destinationLatitude = json['destinationLatitude'];
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    distance = json['distance'];
    volume = json['volume'];
    weight = json['weight'];
    status = json['status'];
    priceShip = json['priceShip'];
    photoUrl = json['photoUrl'];
    note = json['note'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
    shopId = json['shopId'];
    shipperId = json['shipperId'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startAddress'] = this.startAddress;
    data['startLongitude'] = this.startLongitude;
    data['startLatitude'] = this.startLatitude;
    data['destinationAddress'] = this.destinationAddress;
    data['destinationLongitude'] = this.destinationLongitude;
    data['destinationLatitude'] = this.destinationLatitude;
    data['receiverName'] = this.receiverName;
    data['receiverPhone'] = this.receiverPhone;
    data['distance'] = this.distance;
    data['volume'] = this.volume;
    data['weight'] = this.weight;
    data['status'] = this.status;
    data['priceShip'] = this.priceShip;
    data['photoUrl'] = this.photoUrl;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['shopId'] = this.shopId;
    data['shipperId'] = this.shipperId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  double? price;
  String? name;
  String? description;
  String? packageId;

  Products({this.price, this.name, this.description, this.packageId});

  Products.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    name = json['name'];
    description = json['description'];
    packageId = json['packageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['name'] = this.name;
    data['description'] = this.description;
    data['packageId'] = this.packageId;
    return data;
  }
}

class Shop {
  String? id;
  String? userName;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  String? status;
  String? address;
  double? longitude;
  double? latitude;
  String? createdAt;
  String? modifiedAt;

  Shop(
      {this.id,
        this.userName,
        this.email,
        this.displayName,
        this.phoneNumber,
        this.photoUrl,
        this.status,
        this.address,
        this.longitude,
        this.latitude,
        this.createdAt,
        this.modifiedAt});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    displayName = json['displayName'];
    phoneNumber = json['phoneNumber'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['phoneNumber'] = this.phoneNumber;
    data['photoUrl'] = this.photoUrl;
    data['status'] = this.status;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    return data;
  }
}