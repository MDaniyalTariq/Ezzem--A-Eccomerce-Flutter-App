import 'package:ezzem/components/settings/Change_password.dart';
import 'package:ezzem/components/settings/Language_setting.dart';
import 'package:ezzem/components/settings/Notification_setting.dart';
import 'package:ezzem/components/settings/profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'theme_settings_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings & Preferences'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account'),
            tiles: [
              SettingsTile(
                title: Text('Profile Settings'),
                leading: Icon(Icons.person),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileSettingsPage()),
                  );
                },
              ),
              SettingsTile(
                title: Text('Notification Settings'),
                leading: Icon(Icons.notifications),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationSettingsPage()),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Preferences'),
            tiles: [
              SettingsTile(
                title: Text('Theme Settings'),
                leading: Icon(Icons.color_lens),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThemeSettingsPage()),
                  );
                },
              ),
              SettingsTile(
                title: Text('Language Settings'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageSettingsPage()),
                  );
                },
              ),
              SettingsTile(
                title: Text('Font Size'),
                leading: Icon(Icons.text_fields),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FontSizeSettingsPage()),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Security'),
            tiles: [
              SettingsTile(
                title: Text('Change Password'),
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
              SettingsTile.switchTile(
                title: Text('Enable Fingerprint'),
                leading: Icon(Icons.fingerprint),
                onToggle: (bool value) {},
                initialValue: false,
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              SettingsTile(
                title: Text('Terms of Service'),
                leading: Icon(Icons.description),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsOfServicePage()),
                  );
                },
              ),
              SettingsTile(
                title: Text('Privacy Policy'),
                leading: Icon(Icons.privacy_tip),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Miscellaneous'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Enable Analytics'),
                leading: Icon(Icons.analytics),
                onToggle: (bool value) {},
                initialValue: true,
              ),
              SettingsTile(
                title: Text('Version'),
                leading: Icon(Icons.info),
                trailing: Text('1.0.0'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FontSizeSettingsPage extends StatefulWidget {
  @override
  _FontSizeSettingsPageState createState() => _FontSizeSettingsPageState();
}

class _FontSizeSettingsPageState extends State<FontSizeSettingsPage> {
  double _textScaleFactor = 1.0;

  void _increaseFontSize() {
    setState(() {
      _textScaleFactor += 0.1;
      if (_textScaleFactor > 2.0) {
        _textScaleFactor = 2.0;
      }
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _textScaleFactor -= 0.1;
      if (_textScaleFactor < 0.5) {
        _textScaleFactor = 0.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Font Size Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Adjust Text Scale Factor',
              style: TextStyle(fontSize: 20.0 * _textScaleFactor),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decreaseFontSize,
                  child: Icon(Icons.zoom_out),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _increaseFontSize,
                  child: Icon(Icons.zoom_in),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            Text(
              'Welcome to our application. By using our services, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('1. Introduction'),
            _buildSectionContent(
                'This document outlines the terms of service ("Terms") for using our mobile application ("App"). Please read these Terms carefully before using the App.'),
            SizedBox(height: 16),
            _buildSectionTitle('2. Use of the App'),
            _buildSectionContent(
                'You agree to use the App only for lawful purposes and in accordance with these Terms. You must not use the App in any way that breaches any applicable local, national, or international law or regulation.'),
            SizedBox(height: 16),
            _buildSectionTitle('3. Account Registration'),
            _buildSectionContent(
                'To access certain features of the App, you may be required to register for an account. You agree to provide accurate and complete information when registering for an account and to keep your account information up to date.'),
            SizedBox(height: 16),
            _buildSectionTitle('4. User Responsibilities'),
            _buildSectionContent(
                'You are responsible for maintaining the confidentiality of your account information, including your password, and for any activities that occur under your account.'),
            SizedBox(height: 16),
            _buildSectionTitle('5. Termination'),
            _buildSectionContent(
                'We reserve the right to terminate or suspend your access to the App at any time, without notice, for conduct that we believe violates these Terms or is harmful to other users of the App, us, or third parties, or for any other reason.'),
            SizedBox(height: 16),
            _buildSectionTitle('6. Changes to Terms'),
            _buildSectionContent(
                'We may revise these Terms from time to time. The most current version will always be posted on our App. By continuing to access or use the App after revisions become effective, you agree to be bound by the revised Terms.'),
            SizedBox(height: 16),
            _buildSectionTitle('7. Contact Us'),
            _buildSectionContent(
                'If you have any questions about these Terms, please contact us at support@example.com.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            Text(
              'Your privacy is important to us. This privacy policy explains the types of information we collect, how we use it, and the measures we take to protect it.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('1. Information Collection'),
            _buildSectionContent(
                'We collect various types of information in connection with the services we provide, including information you provide directly to us and information we collect automatically.'),
            SizedBox(height: 16),
            _buildSectionTitle('2. Use of Information'),
            _buildSectionContent(
                'The information we collect is used to improve our services, personalize your experience, and communicate with you. We may also use the information for research and analysis.'),
            SizedBox(height: 16),
            _buildSectionTitle('3. Sharing of Information'),
            _buildSectionContent(
                'We do not share your personal information with third parties except as necessary to provide our services, comply with the law, or protect our rights.'),
            SizedBox(height: 16),
            _buildSectionTitle('4. Data Security'),
            _buildSectionContent(
                'We implement a variety of security measures to ensure the safety of your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure.'),
            SizedBox(height: 16),
            _buildSectionTitle('5. Your Rights'),
            _buildSectionContent(
                'You have the right to access, update, or delete your personal information. You can also object to certain processing of your information or request that we restrict processing.'),
            SizedBox(height: 16),
            _buildSectionTitle('6. Changes to This Policy'),
            _buildSectionContent(
                'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on our app.'),
            SizedBox(height: 16),
            _buildSectionTitle('7. Contact Us'),
            _buildSectionContent(
                'If you have any questions about this privacy policy, please contact us at support@example.com.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
    );
  }
}
