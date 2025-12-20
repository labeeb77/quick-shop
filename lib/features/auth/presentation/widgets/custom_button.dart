import 'package:flutter/material.dart';
import 'package:quick_shop/core/theme/app_colors.dart';
import 'package:quick_shop/core/utils/dimensions.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? Dimensions.buttonHeightDefaultSmall;

    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.authPrimary,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.radiusSizeExtraLarge,
                ),
              ),
              elevation: 0,
              disabledBackgroundColor: AppColors.authPrimary.withValues(
                alpha: 0.6,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textWhite,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );

      case ButtonType.secondary:
        return SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.authSecondaryBackground,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.radiusSizeExtraLarge,
                ),
              ),
              elevation: 0,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case ButtonType.text:
        return SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.authBorder, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.radiusSizeExtraLarge,
                ),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
    }
  }
}
