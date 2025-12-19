import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome back heading
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: Dimensions.fontSizeMaxLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge * 2),

              // Username/Email field
              CustomTextField(
                controller: _emailController,
                hintText: 'Username',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                enabled: !isLoading,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Password field
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                enabled: !isLoading,
                onFieldSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textHint,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge * 4),

              // Sign In button
              CustomButton(
                text: 'Sign In',
                onPressed: _submit,
                type: ButtonType.primary,
                isLoading: isLoading,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Forgot Password button
              CustomButton(
                text: 'Forgot Password',
                onPressed: isLoading
                    ? null
                    : () {
                        // TODO: Implement forgot password functionality
                      },
                type: ButtonType.secondary,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Create Account button
              CustomButton(
                text: 'Create Account',
                onPressed: isLoading
                    ? null
                    : () {
                        context.push('/register');
                      },
                type: ButtonType.text,
              ),
            ],
          ),
        );
      },
    );
  }
}
