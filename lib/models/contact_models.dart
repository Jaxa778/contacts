// ignore_for_file: public_member_api_docs, sort_constructors_first
class ContactModels {
  int? id;
  final String fullName;
  final String phoneNumber;

  ContactModels({this.id, required this.fullName, required this.phoneNumber});

  factory ContactModels.fromJson(Map<String, dynamic> json) {
    return ContactModels(
      id: json["id"],
      fullName: json["full_name"],
      phoneNumber: json["phone_number"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "full_name": fullName, "phone_number": phoneNumber};
  }
}
