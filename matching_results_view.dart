import 'package:bug_finder/ui/constants/constants.dart';
import 'package:bug_finder/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/view_models/matching_text_view_model.dart';
import '../../widgets/base_widget.dart';

class MatchingResultsView extends StatefulWidget {
  final String type;
  const MatchingResultsView({
    super.key,
    required this.type,
  });

  @override
  State<MatchingResultsView> createState() => _MatchingResultsViewState();
}

class _MatchingResultsViewState extends State<MatchingResultsView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.type == Constants.extractTextVisionApi) {
        await context.read<MatchingTextViewModel>().extractTextVisionApi();
      } else {
        await context.read<MatchingTextViewModel>().extractTextMLKit();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MatchingTextViewModel>.consume(
        model: MatchingTextViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Matching Results",
                style: TextStyles.boldLargeTextStyle,
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      "Extracted words list: ",
                      style: TextStyles.boldMediumTextStyle,
                    ),
                    model.loadingExtractingText
                        ? const CircularProgressIndicator()
                        : model.errorMessage.isNotEmpty
                            ? Text(model.errorMessage)
                            : model.extractedTextList.isEmpty
                                ? const Text("No text found")
                                : Text("${model.extractedTextList}"),
                    const SizedBox(height: 20),
                    const Text(
                      "Matched words list: ",
                      style: TextStyles.boldMediumTextStyle,
                    ),
                    model.loadingMatchingText
                        ? const CircularProgressIndicator()
                        : model.matchWordList.isEmpty
                            ? const Text("No text found")
                            : Text(
                                "${model.matchWordList.map((e) => e.toMap()).toList()}"),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
