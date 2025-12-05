// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'fault_code.dart';

class FaultCodeAdapter extends TypeAdapter<FaultCode> {
  @override
  final int typeId = 0;

  @override
  FaultCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FaultCode(
      id: fields[0] as String,
      code: fields[1] as String,
      truckModel: fields[2] as String,
      descAr: fields[3] as String,
      descFr: fields[4] as String,
      descEn: fields[5] as String,
      possibleCauses: (fields[6] as List).cast<String>(),
      imagePath: fields[7] as String?,
      severity: fields[8] as String? ?? 'Low',
    );
  }

  @override
  void write(BinaryWriter writer, FaultCode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.truckModel)
      ..writeByte(3)
      ..write(obj.descAr)
      ..writeByte(4)
      ..write(obj.descFr)
      ..writeByte(5)
      ..write(obj.descEn)
      ..writeByte(6)
      ..write(obj.possibleCauses)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.severity);
  }
}
