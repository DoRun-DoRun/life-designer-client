import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineReviewScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routinReviewScreen';
  final int id;
  final RoutineHistory routineHistory;
  const RoutineReviewScreen(
      {super.key, required this.id, required this.routineHistory});

  @override
  ConsumerState<RoutineReviewScreen> createState() =>
      _RoutineReviewScreenState();
}

class _RoutineReviewScreenState extends ConsumerState<RoutineReviewScreen> {
  String selectedText = '';

  void handleEmojiToggle(String text) {
    setState(() {
      selectedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: PaddingContainer(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    'asset/images/character.png',
                    width: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('루틴은 어떠셨나요?', style: AppTextStyles.BOLD_20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: GapRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReviewEmoji(
                          emoji: '😩',
                          text: '힘들어요',
                          selectedText: selectedText,
                          onToggle: handleEmojiToggle,
                        ),
                        ReviewEmoji(
                          emoji: '😕',
                          text: '아쉬워요',
                          selectedText: selectedText,
                          onToggle: handleEmojiToggle,
                        ),
                        ReviewEmoji(
                          emoji: '😊',
                          text: '만족해요',
                          selectedText: selectedText,
                          onToggle: handleEmojiToggle,
                        ),
                        ReviewEmoji(
                          emoji: '😃',
                          text: '뿌듯해요',
                          selectedText: selectedText,
                          onToggle: handleEmojiToggle,
                        ),
                      ],
                    ),
                  ),
                  if (selectedText != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: GapColumn(
                        gap: 16,
                        children: [
                          const Text('루틴 중 느끼신 내용을 적어보세요',
                              style: AppTextStyles.BOLD_20),
                          TextField(
                            controller: textController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              filled: true,
                              fillColor: AppColors.BACKGROUND_SUB,
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.ROUNDED_8,
                                borderSide: BorderSide.none, // No border
                              ),
                              hintText: '오늘 루틴은 어땠나요?',
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          if (selectedText != '')
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: textController,
              builder: (context, value, child) {
                return PaddingContainer(
                  child: CustomButton(
                    onPressed: () async {
                      final routineRepository =
                          ref.read(routineRepositoryProvider);
                      try {
                        await routineRepository.createRoutineReview(
                          RoutineReviewModel(
                            routineId: widget.id,
                            overallRating: mapTextToOverallRating(selectedText),
                            comments: textController.text,
                            subRoutineReviews: convertToSubRoutineReviews(
                              widget.routineHistory,
                            ),
                          ),
                        );

                        ref.invalidate(routineListProvider);
                        context.go('/');
                      } catch (e) {
                        print('Failed to create routine: $e');
                      }
                    },
                    title: value.text.isEmpty ? '건너뛰기' : '확인',
                    backgroundColor: value.text.isEmpty
                        ? AppColors.BACKGROUND_SUB
                        : AppColors.BRAND,
                    foregroundColor:
                        value.text.isEmpty ? AppColors.TEXT_SUB : Colors.white,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ReviewEmoji extends StatelessWidget {
  final String emoji, text, selectedText;
  final ValueChanged<String> onToggle;

  const ReviewEmoji({
    super.key,
    required this.emoji,
    required this.text,
    required this.selectedText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(text),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: AppRadius.FULL,
              color: selectedText == text
                  ? AppColors.BRAND_SUB
                  : AppColors.BACKGROUND_SUB,
            ),
            child: Center(
                child: Text(emoji,
                    style: AppTextStyles.EMOJI.copyWith(fontSize: 30))),
          ),
          const SizedBox(height: 8),
          Text(text, style: AppTextStyles.MEDIUM_16)
        ],
      ),
    );
  }
}
