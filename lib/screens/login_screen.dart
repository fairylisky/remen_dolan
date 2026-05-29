import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remen_dolan/theme/app_colors.dart';
import 'package:remen_dolan/theme/app_text_styles.dart';
import 'package:remen_dolan/widgets/auth_input_field.dart';
import 'package:remen_dolan/widgets/auth_tab_switcher.dart';
import 'package:remen_dolan/widgets/swipe_button.dart';
import 'package:remen_dolan/screens/main_screen.dart';
import 'package:remen_dolan/utils/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  bool _rememberMe = false;
  bool _isLoading = false;

  final _loginEmailCtrl    = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  final _loginFormKey      = GlobalKey<FormState>();

  final _regNameCtrl            = TextEditingController();
  final _regEmailCtrl           = TextEditingController();
  final _regPasswordCtrl        = TextEditingController();
  final _regConfirmPasswordCtrl = TextEditingController();
  final _regFormKey             = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPasswordCtrl.dispose();
    _regConfirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _selectedTab) return;
    _animController.reset();
    setState(() => _selectedTab = index);
    _animController.forward();
  }

  Future<void> _onLoginSwipe() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final success = await context.read<AppState>().login(
        _loginEmailCtrl.text.trim(), _loginPasswordCtrl.text);
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  Future<void> _onRegisterSwipe() async {
    if (!(_regFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final success = await context.read<AppState>().register(
        _regEmailCtrl.text.trim(),
        _regPasswordCtrl.text,
        _regNameCtrl.text.trim());
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                      child: Column(
                        children: [
                          AuthTabSwitcher(selectedIndex: _selectedTab, onTabChanged: _switchTab),
                          const SizedBox(height: 28),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: _selectedTab == 0 ? _buildLoginForm() : _buildRegisterForm(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 44),
      child: Column(
        children: [
          Text('Remen Dolan', style: AppTextStyles.brandTitle),
          const SizedBox(height: 10),
          Text('Welcome Back', style: AppTextStyles.headline, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Temukan harmoni tradisi dan kenyamanan\nmodern di pusat kebudayaan Jawa.',
            style: AppTextStyles.subtitle, textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Enter your Email',
            prefixIcon: Icons.email_outlined,
            controller: _loginEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
              if (!v.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Password', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Enter your Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            controller: _loginPasswordCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
              if (v.length < 6) return 'Password minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 20, height: 20,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: BorderSide(color: AppColors.border, width: 1.5),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Remember me', style: AppTextStyles.bodySmall),
              ]),
              Text('Forgot Password?', style: AppTextStyles.linkText),
            ],
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SwipeButton(label: 'Swipe to Log in', onComplete: _onLoginSwipe),
          const SizedBox(height: 20),
          Center(
            child: RichText(
              text: TextSpan(style: AppTextStyles.bodySmall, children: [
                const TextSpan(text: 'Belum punya akun? '),
                WidgetSpan(child: GestureDetector(
                  onTap: () => _switchTab(1),
                  child: Text('Daftar disini', style: AppTextStyles.linkText),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _regFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Lengkap', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Masukkan nama lengkap',
            prefixIcon: Icons.person_outline_rounded,
            controller: _regNameCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Nama tidak boleh kosong';
              if (v.length < 2) return 'Nama minimal 2 karakter';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Email', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Enter your Email',
            prefixIcon: Icons.email_outlined,
            controller: _regEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
              if (!v.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Password', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Enter your Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            controller: _regPasswordCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
              if (v.length < 6) return 'Password minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Konfirmasi Password', style: AppTextStyles.label),
          const SizedBox(height: 8),
          AuthInputField(
            hint: 'Confirm your Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            controller: _regConfirmPasswordCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Konfirmasi password tidak boleh kosong';
              if (v != _regPasswordCtrl.text) return 'Password tidak cocok';
              return null;
            },
          ),
          const SizedBox(height: 28),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SwipeButton(label: 'Swipe to Sign up', onComplete: _onRegisterSwipe),
          const SizedBox(height: 20),
          Center(
            child: RichText(
              text: TextSpan(style: AppTextStyles.bodySmall, children: [
                const TextSpan(text: 'Sudah punya akun? '),
                WidgetSpan(child: GestureDetector(
                  onTap: () => _switchTab(0),
                  child: Text('Login disini', style: AppTextStyles.linkText),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
