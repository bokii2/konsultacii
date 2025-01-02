class ConsultationAttendanceResponse {
  final int id;
  final String studentIndex;
  final String studentName;
  final String? comment;
  final bool? reportAbsentProfessor;
  final bool? reportAbsentStudent;
  final String? absentProfessorComment;
  final String? absentStudentComment;

  ConsultationAttendanceResponse({
    required this.id,
    required this.studentIndex,
    required this.studentName,
    this.comment,
    this.reportAbsentProfessor,
    this.reportAbsentStudent,
    this.absentProfessorComment,
    this.absentStudentComment,
  });

  factory ConsultationAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return ConsultationAttendanceResponse(
      id: json['id'] as int,
      studentIndex: json['studentIndex'] as String,
      studentName: json['studentName'] as String,
      comment: json['comment'] as String?,
      reportAbsentProfessor: json['reportAbsentProfessor'] as bool?,
      reportAbsentStudent: json['reportAbsentStudent'] as bool?,
      absentProfessorComment: json['absentProfessorComment'] as String?,
      absentStudentComment: json['absentStudentComment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentIndex': studentIndex,
      'studentName': studentName,
      'comment': comment,
      'reportAbsentProfessor': reportAbsentProfessor,
      'reportAbsentStudent': reportAbsentStudent,
      'absentProfessorComment': absentProfessorComment,
      'absentStudentComment': absentStudentComment,
    };
  }

  ConsultationAttendanceResponse copyWith({
    int? id,
    String? studentIndex,
    String? studentName,
    String? comment,
    bool? reportAbsentProfessor,
    bool? reportAbsentStudent,
    String? absentProfessorComment,
    String? absentStudentComment,
  }) {
    return ConsultationAttendanceResponse(
      id: id ?? this.id,
      studentIndex: studentIndex ?? this.studentIndex,
      studentName: studentName ?? this.studentName,
      comment: comment ?? this.comment,
      reportAbsentProfessor: reportAbsentProfessor ?? this.reportAbsentProfessor,
      reportAbsentStudent: reportAbsentStudent ?? this.reportAbsentStudent,
      absentProfessorComment: absentProfessorComment ?? this.absentProfessorComment,
      absentStudentComment: absentStudentComment ?? this.absentStudentComment,
    );
  }
}
