import 'package:flutter/material.dart';
import 'package:edu_mate/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String? initialName;
  
  const ProfilePage({Key? key, this.initialName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile data
  String studentName = '';
  int grade = 9;
  String className = '';
  String studentID = '';
  String schoolName = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String parentName = '';
  String parentPhone = '';
  File? profileImage;
  
  // Settings
  String selectedLanguage = 'English';
  bool notificationsEnabled = true;
  String selectedTheme = 'Light';
  
  // Academic stats (these would normally come from API)
  final double attendanceRate = 0.95;
  final double assignmentCompletion = 0.85;
  final double testScores = 0.78;
  final double overallProgress = 0.82;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      studentName = widget.initialName ?? prefs.getString('student_name') ?? '';
      grade = prefs.getInt('grade') ?? 9;
      className = prefs.getString('class_name') ?? '';
      studentID = prefs.getString('student_id') ?? '';
      schoolName = prefs.getString('school_name') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phone_number') ?? '';
      address = prefs.getString('address') ?? '';
      parentName = prefs.getString('parent_name') ?? '';
      parentPhone = prefs.getString('parent_phone') ?? '';
      selectedLanguage = prefs.getString('language') ?? 'English';
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      selectedTheme = prefs.getString('theme') ?? 'Light';
      
      String? imagePath = prefs.getString('profile_image');
      if (imagePath != null && imagePath.isNotEmpty) {
        profileImage = File(imagePath);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', studentName);
    await prefs.setInt('grade', grade);
    await prefs.setString('class_name', className);
    await prefs.setString('student_id', studentID);
    await prefs.setString('school_name', schoolName);
    await prefs.setString('email', email);
    await prefs.setString('phone_number', phoneNumber);
    await prefs.setString('address', address);
    await prefs.setString('parent_name', parentName);
    await prefs.setString('parent_phone', parentPhone);
    await prefs.setString('language', selectedLanguage);
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setString('theme', selectedTheme);
    
    if (profileImage != null) {
      await prefs.setString('profile_image', profileImage!.path);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
        await _saveProfileData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildProfileCard(),
              _buildAcademicProgress(),
              _buildSettingsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppTheme.white),
                onPressed: () => _showEditProfileDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppTheme.white),
                onPressed: () => _showNotificationsDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryBlue,
                  backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: AppTheme.white,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            studentName.isEmpty ? 'Tap to edit profile' : studentName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            className.isEmpty ? 'Grade $grade' : 'Grade $grade - Class $className',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Student ID', studentID.isEmpty ? 'Not set' : studentID),
          _buildInfoItem('School', schoolName.isEmpty ? 'Not set' : schoolName),
          _buildInfoItem('Email', email.isEmpty ? 'Not set' : email),
          _buildInfoItem('Phone', phoneNumber.isEmpty ? 'Not set' : phoneNumber),
          _buildInfoItem('Address', address.isEmpty ? 'Not set' : address),
          const Divider(height: 32),
          _buildInfoItem('Parent/Guardian', parentName.isEmpty ? 'Not set' : parentName),
          _buildInfoItem('Parent Phone', parentPhone.isEmpty ? 'Not set' : parentPhone),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: value == 'Not set' ? AppTheme.grey : AppTheme.darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: value == 'Not set' ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressIndicator('Attendance', attendanceRate, Colors.green),
              _buildProgressIndicator('Assignments', assignmentCompletion, Colors.blue),
              _buildProgressIndicator('Test Scores', testScores, Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: overallProgress,
                backgroundColor: AppTheme.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${(overallProgress * 100).toInt()}% Complete',
                style: const TextStyle(
                  color: AppTheme.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double value, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35.0,
          lineWidth: 8.0,
          percent: value,
          center: Text(
            '${(value * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          progressColor: color,
          backgroundColor: AppTheme.lightGrey,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(Icons.language, 'Language', selectedLanguage, () => _showLanguageDialog()),
          _buildSettingsItem(Icons.notifications, 'Notifications', notificationsEnabled ? 'Enabled' : 'Disabled', () => _toggleNotifications()),
          _buildSettingsItem(Icons.dark_mode, 'Theme', selectedTheme, () => _showThemeDialog()),
          _buildSettingsItem(Icons.lock, 'Privacy', '', () => _showPrivacyDialog()),
          _buildSettingsItem(Icons.help_outline, 'Help & Support', '', () => _showHelpDialog()),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
              ),
              onPressed: () => _showLogoutDialog(),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.grey,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkBlue,
                ),
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for editing profile
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: studentName);
    final gradeController = TextEditingController(text: grade.toString());
    final classController = TextEditingController(text: className);
    final idController = TextEditingController(text: studentID);
    final schoolController = TextEditingController(text: schoolName);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phoneNumber);
    final addressController = TextEditingController(text: address);
    final parentNameController = TextEditingController(text: parentName);
    final parentPhoneController = TextEditingController(text: parentPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Grade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: classController,
                  decoration: const InputDecoration(labelText: 'Class'),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                ),
                TextField(
                  controller: schoolController,
                  decoration: const InputDecoration(labelText: 'School Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                ),
                TextField(
                  controller: parentNameController,
                  decoration: const InputDecoration(labelText: 'Parent/Guardian Name'),
                ),
                TextField(
                  controller: parentPhoneController,
                  decoration: const InputDecoration(labelText: 'Parent Phone'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                studentName = nameController.text;
                grade = int.tryParse(gradeController.text) ?? grade;
                className = classController.text;
                studentID = idController.text;
                schoolName = schoolController.text;
                email = emailController.text;
                phoneNumber = phoneController.text;
                address = addressController.text;
                parentName = parentNameController.text;
                parentPhone = parentPhoneController.text;
              });
              _saveProfileData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Indonesian', 'Arabic'].map((lang) => 
            RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                _saveProfileData();
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _toggleNotifications() {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
    _saveProfileData();
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Light', 'Dark', 'System'].map((theme) => 
            RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: selectedTheme,
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                });
                _saveProfileData();
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Here you can manage your notification preferences.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text('Manage your privacy and data settings here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Contact support or browse FAQ for help.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Clear saved data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              // Navigate to login page
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', 
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}