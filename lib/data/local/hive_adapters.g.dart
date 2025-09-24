// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieEntityAdapter extends TypeAdapter<MovieEntity> {
  @override
  final int typeId = 1;

  @override
  MovieEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieEntity(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String?,
      posterPath: fields[3] as String?,
      backdropPath: fields[4] as String?,
      releaseDate: fields[5] as String?,
      voteAverage: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.voteAverage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieDetailEntityAdapter extends TypeAdapter<MovieDetailEntity> {
  @override
  final int typeId = 2;

  @override
  MovieDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailEntity(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String?,
      posterPath: fields[3] as String?,
      backdropPath: fields[4] as String?,
      releaseDate: fields[5] as String?,
      voteAverage: fields[6] as double?,
      runtime: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.voteAverage)
      ..writeByte(7)
      ..write(obj.runtime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
