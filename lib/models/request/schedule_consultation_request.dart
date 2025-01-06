class ScheduleConsultationRequest {
  final int? termId;
  final String? comment;

  ScheduleConsultationRequest({this.termId, this.comment});

  factory ScheduleConsultationRequest.fromJson(Map<String, dynamic> json) {
    return ScheduleConsultationRequest(
      termId: json['termId'] as int?,
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'termId': termId,
      'comment': comment,
    };
  }
}
