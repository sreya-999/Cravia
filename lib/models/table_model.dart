// table_model.dart
class TableModel {
  final int id;
  final String? tableCount; // nullable
  final String seater;
  final DateTime? createdAt; // nullable if API can send null
  final DateTime? updatedAt; // nullable
  final String? status; // nullable

  TableModel({
    required this.id,
    this.tableCount,
    required this.seater,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as int,
      tableCount: json['table_name'] as String?, // nullable
      seater: json['seater'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_count': tableCount,
      'seater': seater,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
    };
  }
}


// Optionally, create a response model if you want to parse the whole API response
class TableResponse {
  final List<TableModel> data;
  final int count;
  final String message;

  TableResponse({
    required this.data,
    required this.count,
    required this.message,
  });

  factory TableResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TableModel> tableList =
    list.map((i) => TableModel.fromJson(i)).toList();

    return TableResponse(
      data: tableList,
      count: json['count'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'count': count,
      'message': message,
    };
  }
}
