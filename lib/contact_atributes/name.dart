class Name {
  final String? firstName, lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map json) => Name(
        firstName: json['firstname'],
        lastName: json['lastname'],
      );

  String get displayName => (firstName != null || lastName != null) ? '$firstName $lastName'.trim() : 'Unknown';

  bool get isUnknownName => firstName == null && lastName == null;
}
