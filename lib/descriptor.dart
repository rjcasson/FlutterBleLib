part of flutter_ble_lib;

abstract class _DescriptorMetadata {
  static const String uuid = "descriptorUuid";
  static const String id = "descriptorId";
  static const String value = "value";
}

class Descriptor extends InternalDescriptor {
  ManagerForDescriptor _manager;
  Characteristic characteristic;
  String uuid;

  Descriptor.fromJson(
    Map<String, dynamic> jsonObject,
    Characteristic characteristic,
    ManagerForDescriptor manager,
  ) : super(jsonObject[_DescriptorMetadata.id]) {
    _manager = manager;
    this.characteristic = characteristic;
    uuid = jsonObject[_DescriptorMetadata.uuid];
  }

  Future<Uint8List> read({String transactionId}) =>
      _manager.readDescriptorForIdentifier(
        this,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  Future<void> write(Uint8List value, {String transactionId}) =>
      _manager.writeDescriptorForIdentifier(
        this,
        value,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Descriptor &&
              runtimeType == other.runtimeType &&
              _manager == other._manager &&
              characteristic == other.characteristic &&
              uuid == other.uuid;

  @override
  int get hashCode =>
      _manager.hashCode ^
      characteristic.hashCode ^
      uuid.hashCode;

  /// Returns a string representation of this Descriptor
  @override
  String toString() {
    return 'Descriptor{characteristic: ${characteristic.uuid},'
        ' uuid: $uuid}';
  }
}

class DescriptorWithValue extends Descriptor with WithValue {
  DescriptorWithValue.fromJson(
    Map<String, dynamic> jsonObject,
    Characteristic characteristic,
    ManagerForDescriptor manager,
  ) : super.fromJson(jsonObject, characteristic, manager) {
    value = base64Decode(jsonObject[_DescriptorMetadata.value]);
  }

  @override
  String toString() {
    return super.toString() +
        ' DescriptorWithValue{value = ${value.toString()}';
  }
}
