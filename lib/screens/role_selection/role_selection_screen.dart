// lib/screens/role_selection/role_selection_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/buttons/custom_button.dart';
import '../professor_dashboard/professor_dashboard.dart';
import '../student_dashboard/student_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildTitle(context),
                const SizedBox(height: 60),
                _buildRoleButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "https://www.finki.ukim.mk/sites/default/files/styles/large/public/default_images/finki_52_1_2_1_62_0.png?itok=miZDgQ_6",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Систем за консултации',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF000066),
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRoleButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Професор',
          isPrimary: true,
          onPressed: () => _navigateToProfessorDashboard(context),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Студент',
          isPrimary: false,
          onPressed: () => _navigateToStudentDashboard(context),
        ),
      ],
    );
  }

  void _navigateToProfessorDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfessorDashboard(),
      ),
    );
  }

  void _navigateToStudentDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentDashboard(),
      ),
    );
  }
}