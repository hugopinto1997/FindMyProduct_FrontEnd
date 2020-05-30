// To parse this JSON data, do
//
//     final listModelCable = listModelCableFromJson(jsonString);

import 'dart:convert';

ListModelCable listModelCableFromJson(String str) => ListModelCable.fromJson(json.decode(str));

String listModelCableToJson(ListModelCable data) => json.encode(data.toJson());

class ListModelCable {
    List<Message> message;

    ListModelCable({
        this.message,
    });

    factory ListModelCable.fromJson(Map<String, dynamic> json) => ListModelCable(
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
    };
}

class Message {
    int id;
    String name;
    int quantity;
    List<Product> products;

    Message({
        this.id,
        this.name,
        this.quantity,
        this.products,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    int id;
    String name;
    String category;
    int quantity;
    String photo;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic listId;

    Product({
        this.id,
        this.name,
        this.category,
        this.quantity,
        this.photo,
        this.createdAt,
        this.updatedAt,
        this.listId,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        quantity: json["quantity"],
        photo: json["photo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        listId: json["list_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "quantity": quantity,
        "photo": photo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "list_id": listId,
    };
}
