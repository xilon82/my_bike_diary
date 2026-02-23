// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetComponentCollection on Isar {
  IsarCollection<Component> get components => this.collection();
}

const ComponentSchema = CollectionSchema(
  name: r'Component',
  id: -8356918290272001147,
  properties: {
    r'isMounted': PropertySchema(
      id: 0,
      name: r'isMounted',
      type: IsarType.bool,
    ),
    r'lastMaintenanceDate': PropertySchema(
      id: 1,
      name: r'lastMaintenanceDate',
      type: IsarType.dateTime,
    ),
    r'maintenanceIntervalDays': PropertySchema(
      id: 2,
      name: r'maintenanceIntervalDays',
      type: IsarType.long,
    ),
    r'modelDetails': PropertySchema(
      id: 3,
      name: r'modelDetails',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'purchaseDate': PropertySchema(
      id: 5,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
    ),
    r'unmountedDate': PropertySchema(
      id: 7,
      name: r'unmountedDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _componentEstimateSize,
  serialize: _componentSerialize,
  deserialize: _componentDeserialize,
  deserializeProp: _componentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'bike': LinkSchema(
      id: -7383619421262811481,
      name: r'bike',
      target: r'Bike',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _componentGetId,
  getLinks: _componentGetLinks,
  attach: _componentAttach,
  version: '3.1.0+1',
);

int _componentEstimateSize(
  Component object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.modelDetails;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _componentSerialize(
  Component object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isMounted);
  writer.writeDateTime(offsets[1], object.lastMaintenanceDate);
  writer.writeLong(offsets[2], object.maintenanceIntervalDays);
  writer.writeString(offsets[3], object.modelDetails);
  writer.writeString(offsets[4], object.name);
  writer.writeDateTime(offsets[5], object.purchaseDate);
  writer.writeString(offsets[6], object.type);
  writer.writeDateTime(offsets[7], object.unmountedDate);
}

Component _componentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Component();
  object.id = id;
  object.isMounted = reader.readBool(offsets[0]);
  object.lastMaintenanceDate = reader.readDateTimeOrNull(offsets[1]);
  object.maintenanceIntervalDays = reader.readLongOrNull(offsets[2]);
  object.modelDetails = reader.readStringOrNull(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.purchaseDate = reader.readDateTime(offsets[5]);
  object.type = reader.readStringOrNull(offsets[6]);
  object.unmountedDate = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _componentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _componentGetId(Component object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _componentGetLinks(Component object) {
  return [object.bike];
}

void _componentAttach(IsarCollection<dynamic> col, Id id, Component object) {
  object.id = id;
  object.bike.attach(col, col.isar.collection<Bike>(), r'bike', id);
}

extension ComponentQueryWhereSort
    on QueryBuilder<Component, Component, QWhere> {
  QueryBuilder<Component, Component, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ComponentQueryWhere
    on QueryBuilder<Component, Component, QWhereClause> {
  QueryBuilder<Component, Component, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Component, Component, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Component, Component, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Component, Component, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ComponentQueryFilter
    on QueryBuilder<Component, Component, QFilterCondition> {
  QueryBuilder<Component, Component, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> isMountedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMounted',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMaintenanceDate',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMaintenanceDate',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMaintenanceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMaintenanceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMaintenanceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      lastMaintenanceDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMaintenanceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maintenanceIntervalDays',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maintenanceIntervalDays',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maintenanceIntervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maintenanceIntervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maintenanceIntervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      maintenanceIntervalDaysBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maintenanceIntervalDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modelDetails',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modelDetails',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> modelDetailsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> modelDetailsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelDetails',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> modelDetailsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelDetails',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      modelDetailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> purchaseDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      purchaseDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      purchaseDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> purchaseDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unmountedDate',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unmountedDate',
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unmountedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unmountedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unmountedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition>
      unmountedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unmountedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ComponentQueryObject
    on QueryBuilder<Component, Component, QFilterCondition> {}

extension ComponentQueryLinks
    on QueryBuilder<Component, Component, QFilterCondition> {
  QueryBuilder<Component, Component, QAfterFilterCondition> bike(
      FilterQuery<Bike> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bike');
    });
  }

  QueryBuilder<Component, Component, QAfterFilterCondition> bikeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bike', 0, true, 0, true);
    });
  }
}

extension ComponentQuerySortBy on QueryBuilder<Component, Component, QSortBy> {
  QueryBuilder<Component, Component, QAfterSortBy> sortByIsMounted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMounted', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByIsMountedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMounted', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByLastMaintenanceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenanceDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      sortByLastMaintenanceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenanceDate', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      sortByMaintenanceIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maintenanceIntervalDays', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      sortByMaintenanceIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maintenanceIntervalDays', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByModelDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelDetails', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByModelDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelDetails', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByUnmountedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unmountedDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> sortByUnmountedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unmountedDate', Sort.desc);
    });
  }
}

extension ComponentQuerySortThenBy
    on QueryBuilder<Component, Component, QSortThenBy> {
  QueryBuilder<Component, Component, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByIsMounted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMounted', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByIsMountedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMounted', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByLastMaintenanceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenanceDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      thenByLastMaintenanceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenanceDate', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      thenByMaintenanceIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maintenanceIntervalDays', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy>
      thenByMaintenanceIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maintenanceIntervalDays', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByModelDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelDetails', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByModelDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelDetails', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByUnmountedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unmountedDate', Sort.asc);
    });
  }

  QueryBuilder<Component, Component, QAfterSortBy> thenByUnmountedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unmountedDate', Sort.desc);
    });
  }
}

extension ComponentQueryWhereDistinct
    on QueryBuilder<Component, Component, QDistinct> {
  QueryBuilder<Component, Component, QDistinct> distinctByIsMounted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMounted');
    });
  }

  QueryBuilder<Component, Component, QDistinct>
      distinctByLastMaintenanceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMaintenanceDate');
    });
  }

  QueryBuilder<Component, Component, QDistinct>
      distinctByMaintenanceIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maintenanceIntervalDays');
    });
  }

  QueryBuilder<Component, Component, QDistinct> distinctByModelDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelDetails', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Component, Component, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Component, Component, QDistinct> distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<Component, Component, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Component, Component, QDistinct> distinctByUnmountedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unmountedDate');
    });
  }
}

extension ComponentQueryProperty
    on QueryBuilder<Component, Component, QQueryProperty> {
  QueryBuilder<Component, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Component, bool, QQueryOperations> isMountedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMounted');
    });
  }

  QueryBuilder<Component, DateTime?, QQueryOperations>
      lastMaintenanceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMaintenanceDate');
    });
  }

  QueryBuilder<Component, int?, QQueryOperations>
      maintenanceIntervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maintenanceIntervalDays');
    });
  }

  QueryBuilder<Component, String?, QQueryOperations> modelDetailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelDetails');
    });
  }

  QueryBuilder<Component, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Component, DateTime, QQueryOperations> purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<Component, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Component, DateTime?, QQueryOperations> unmountedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unmountedDate');
    });
  }
}
