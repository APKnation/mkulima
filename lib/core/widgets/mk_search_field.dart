import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Rounded search field used across discovery screens.
class MkSearchField extends StatelessWidget {
  const MkSearchField({
    super.key,
    this.controller,
    this.hint = 'Tafuta mazao, mifugo, bidhaa au huduma',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.onFilter,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onFilter;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: AppText.body.copyWith(color: AppColors.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintMaxLines: 1,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          prefixIconConstraints: const BoxConstraints(minWidth: 46),
          suffixIcon: onFilter != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: onFilter,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                )
              : controller != null
                  ? ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller!,
                      builder: (context, value, _) => value.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: onClear,
                              icon: const Icon(Icons.close_rounded, size: 18),
                            ),
                    )
                  : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 44),
        ),
      ),
    );
  }
}

/// Compact "search or filter" bar used on dashboards, opens search on tap.
class MkSearchLauncher extends StatelessWidget {
  const MkSearchLauncher({
    super.key,
    required this.onTap,
    this.hint = 'Tafuta mazao, mifugo au huduma',
    this.onFilter,
  });

  final VoidCallback onTap;
  final String hint;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.line),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.muted, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(color: AppColors.muted),
                ),
              ),
              if (onFilter != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: AppColors.primaryDark,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
