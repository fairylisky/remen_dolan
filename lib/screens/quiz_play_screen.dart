import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../models/models.dart';

class QuizPlayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String title;
  final String categoryId;
  final int level;

  const QuizPlayScreen({
    super.key,
    required this.questions,
    required this.title,
    required this.categoryId,
    this.level = 1,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _current = 0;
  int _selected = -1;
  bool _answered = false;
  int _score = 0;
  int _correct = 0;

  QuizQuestion get _q => widget.questions[_current];

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == _q.correctIndex) {
        _score += 10;
        _correct++;
      }
    });
  }

  void _next() {
    if (_current < widget.questions.length - 1) {
      setState(() {
        _current++;
        _selected = -1;
        _answered = false;
      });
    } else {
      _finish();
    }
  }

  void _finish() {
    final accuracy = ((_correct / widget.questions.length) * 100).round();
    context.read<AppState>().updateLastQuizSession(QuizSession(
      placeName: widget.title,
      categoryId: widget.categoryId,
      questionsAnswered: _correct,
      totalQuestions: widget.questions.length,
      score: _score,
      date: DateTime.now(),
    ));
    context.read<AppState>().updateQuizProgress(widget.categoryId, widget.level, _score, accuracy);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ResultScreen(
          title: widget.title,
          score: _score,
          correct: _correct,
          total: widget.questions.length,
          accuracy: accuracy,
        ),
      ),
    );
  }

  void _showHint() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💡', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text('Bantuan',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 12),
              Text(_q.hint,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Mengerti!', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.questions.length;
    final progress = (_current + 1) / total;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
        actions: [
          TextButton.icon(
            onPressed: _showHint,
            icon: const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 18),
            label: Text('Bantuan',
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Soal ${_current + 1} dari $total',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                    Text('$_score poin',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Question image - hanya tampil jika imageUrl tidak kosong
                  if (_q.imageUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AppImage(
                        _q.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Question text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Text(
                      _q.question,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryDark, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options
                  ...List.generate(_q.options.length, (i) {
                    Color bg = Colors.white;
                    Color border = AppColors.divider;
                    Color textColor = AppColors.textPrimary;

                    if (_answered) {
                      if (i == _q.correctIndex) {
                        bg = AppColors.success.withOpacity(0.15);
                        border = AppColors.success;
                        textColor = AppColors.success;
                      } else if (i == _selected && i != _q.correctIndex) {
                        bg = AppColors.error.withOpacity(0.1);
                        border = AppColors.error;
                        textColor = AppColors.error;
                      }
                    } else if (_selected == i) {
                      bg = AppColors.primary.withOpacity(0.1);
                      border = AppColors.primary;
                      textColor = AppColors.primary;
                    }

                    return GestureDetector(
                      onTap: () => _select(i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bg,
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: border.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                ['A', 'B', 'C', 'D'][i],
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: border),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_q.options[i],
                                style: GoogleFonts.poppins(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
                          ),
                          if (_answered && i == _q.correctIndex)
                            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                          if (_answered && i == _selected && i != _q.correctIndex)
                            const Icon(Icons.cancel, color: AppColors.error, size: 20),
                        ]),
                      ),
                    );
                  }),

                  // Explanation after answer
                  if (_answered) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📖', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_q.explanation,
                                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, height: 1.5)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Next button
          if (_answered)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _current < widget.questions.length - 1 ? 'Soal Berikutnya →' : 'Selesai Quiz ✓',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final String title;
  final int score;
  final int correct;
  final int total;
  final int accuracy;

  const _ResultScreen({
    required this.title,
    required this.score,
    required this.correct,
    required this.total,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final isPass = accuracy >= 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isPass ? '🎉' : '💪', style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                isPass ? 'Luar Biasa!' : 'Terus Belajar!',
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('$score', 'Poin', AppColors.primary),
                    _divider(),
                    _stat('$correct/$total', 'Benar', AppColors.success),
                    _divider(),
                    _stat('$accuracy%', 'Akurasi', AppColors.accent),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Kembali ke Beranda',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Coba Lagi',
                    style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String val, String label, Color color) {
    return Column(children: [
      Text(val, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.divider);
}