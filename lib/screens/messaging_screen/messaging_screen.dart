// lib/screens/messaging/messaging_screen.dart
import 'package:flutter/material.dart';
import 'package:konsultacii/main.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/services/consultation_service.dart';
import '../../models/message.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  final bool isProfessor;
  final ConsultationResponse consultation;
  final int attendanceId;

  const MessagingScreen(
      {Key? key,
      required this.isProfessor,
      required this.consultation,
      required this.attendanceId})
      : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ConsultationService _consultationService = ConsultationService();
  bool _isLoading = true;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final comments = await _consultationService
          .getCommentsForConulstationTerm(widget.consultation.id);
      setState(() {
        _messages = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0099FF),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Коментари',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMyMessage = (message.isProfessor && widget.isProfessor) ||
            (!message.isProfessor && !widget.isProfessor);

        return Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: _buildMessageBubble(message, isMyMessage),
        );
      },
    );
  }

  Widget _buildMessageBubble(Message message, bool isMyMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isMyMessage ? const Color(0xFF0099FF) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16).copyWith(
          bottomRight: isMyMessage ? const Radius.circular(4) : null,
          bottomLeft: !isMyMessage ? const Radius.circular(4) : null,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.comment,
            style: TextStyle(
              color: isMyMessage ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('HH:mm').format(message.timestamp),
            style: TextStyle(
              color:
                  isMyMessage ? Colors.white.withOpacity(0.7) : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Напишете порака...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0099FF),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send_rounded),
        color: Colors.white,
        onPressed: _sendMessage,
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await _consultationService.addCommentForConulstationTerm(
          widget.attendanceId, _messageController.text);
      _loadComments();
    } catch (e) {
      SnackBarService.showSnackBar("Грешка при додавање на коментарот", isError: true);
    }

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
