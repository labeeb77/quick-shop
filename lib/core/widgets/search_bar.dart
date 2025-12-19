import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onClear,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
    _hasText = widget.controller?.text.isNotEmpty ?? false;
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);
      _hasText = widget.controller?.text.isNotEmpty ?? false;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    widget.controller?.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.authInputBackground,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeExtraLarge),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          setState(() {
            _hasText = value.isNotEmpty;
          });
          widget.onChanged?.call(value);
        },
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        style: const TextStyle(
          fontSize: Dimensions.fontSizeLarge,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: Dimensions.fontSizeLarge,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                  ),
                  onPressed: _handleClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeLarge,
            vertical: Dimensions.paddingSizeDefault,
          ),
        ),
      ),
    );
  }
}
