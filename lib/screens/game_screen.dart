import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game_practice/game_bloc.dart';
import '../blocs/game_practice/game_state.dart';

import 'package:new_words/l10n/app_localizations.dart';

class GameScreen extends StatelessWidget {
  final List words;
  final int dayIndex;
  final bool isFavMode;

  const GameScreen({
    super.key,
    required this.words,
    required this.dayIndex,
    this.isFavMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()..add(InitGame(words, isFavMode)),
      child: GameScreenView(dayIndex: dayIndex),
    );
  }
}

class GameScreenView extends StatelessWidget {
  final int dayIndex;

  const GameScreenView({super.key, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: GestureDetector(
              onTap: () {
                context.read<GameBloc>().add(ToggleDeToRu());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        state.isDeToRu
                            ? AppLocalizations.of(context)!.word
                            : AppLocalizations.of(context)!.translation,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.sync_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        state.isDeToRu
                            ? AppLocalizations.of(context)!.translation
                            : AppLocalizations.of(context)!.word,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Center(
                  child: Text(
                    "★ ${state.favCount}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: state.currentWords.isEmpty
              ? Center(
                  child: Text(
                    state.isFavMode
                        ? AppLocalizations.of(context)!.favorites
                        : AppLocalizations.of(context)!.empty_word,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: state.currentWords.length,
                  itemBuilder: (context, index) {
                    var word = state.currentWords[index];
                    bool isFlipped = state.flippedStatus[index];

                    String frontText = state.isDeToRu
                        ? (word['wd'] ?? "")
                        : (word['tr'] ?? "");
                    String backText = state.isDeToRu
                        ? (word['tr'] ?? "")
                        : (word['wd'] ?? "");

                    return GestureDetector(
                      onTap: () {
                        context.read<GameBloc>().add(ToggleFlip(index));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color:
                              ((state.isDeToRu && !isFlipped) ||
                                  (!state.isDeToRu && isFlipped))
                              ? Colors.blueAccent
                              : const Color(0xFF009688),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: Icon(
                                  word['isFav'] == true
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  context.read<GameBloc>().add(
                                    ToggleFavoriteInGame(index),
                                  );
                                },
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  isFlipped ? backText : frontText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
