

class Address {
  final String? addressLine1, addressLine2, city, countryId;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.countryId,
  });

  factory Address.fromJson(Map json) => Address(
        addressLine1: json['contact_address_line_1'],
        addressLine2: json['contact_address_line_2'],
        city: json['city'],
        countryId: json['country_id'],
      );

  bool get hasAddress => addressLine1 != null || addressLine2 != null || city != null || countryId != null;
}
