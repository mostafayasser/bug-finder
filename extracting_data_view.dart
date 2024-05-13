import 'package:bug_finder/ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../core/view_models/matching_text_view_model.dart';
import '../../styles/text_styles.dart';
import '../../widgets/base_widget.dart';
import '../../widgets/buttons/filled_button.dart';
import '../../widgets/sheets/image_picker_sheet.dart';
import '../matching_results/matching_results_view.dart';

class ExtractingDataView extends StatelessWidget {
  const ExtractingDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MatchingTextViewModel>.consume(
        model: MatchingTextViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Extracting Data",
                style: TextStyles.boldLargeTextStyle,
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    model.selectedImageBytes.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => ImagePickerSheet(
                                  onPressCamera: () async {
                                    model.selectImage(ImageSource.camera).then(
                                        (value) => Navigator.pop(context));
                                  },
                                  onPressGallery: () async {
                                    model.selectImage(ImageSource.gallery).then(
                                        (value) => Navigator.pop(context));
                                  },
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 100,
                            ),
                          )
                        : Image.memory(
                            model.selectedImageBytes,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.5,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 50),
                    model.loadingExtractingText
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomFilledButton(
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () async {
                                  if (model.selectedImageBytes.isNotEmpty) {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const MatchingResultsView(
                                        type: Constants.extractTextVisionApi,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please select an image first'),
                                      ),
                                    );
                                  }
                                },
                                text: 'Vision API',
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              CustomFilledButton(
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () async {
                                  if (model.selectedImageBytes.isNotEmpty) {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const MatchingResultsView(
                                        type: Constants.extractTextMlKit,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please select an image first'),
                                      ),
                                    );
                                  }
                                },
                                text: 'ML Kit',
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    CustomFilledButton(
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () async {
                        model.clearData();
                      },
                      text: 'Clear Data',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
