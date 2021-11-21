class Item{
  int id;
  int idList;
  String name;
  int quantity;
  String note;

  Item(this.id, this.idList, this.name, this.quantity, this.note);

  Map<String, dynamic> toMap() {
    return {
      'idList': idList,
      'name': name,
      'quantity': quantity,
      'note': note,
    };
  }
}