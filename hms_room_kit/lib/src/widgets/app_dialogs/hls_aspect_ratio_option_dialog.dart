//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

//Project imports

class AspectRatioOptionDialog extends StatefulWidget {
  final List<String> availableAspectRatios;
  final MeetingStore meetingStore;
  const AspectRatioOptionDialog({
    super.key,
    required this.availableAspectRatios,
    required this.meetingStore,
  });

  @override
  AspectRatioOptionDialogState createState() => AspectRatioOptionDialogState();
}

class AspectRatioOptionDialogState extends State<AspectRatioOptionDialog> {
  String? valueChoose;

  void _updateDropDownValue(dynamic newValue) {
    valueChoose = newValue;
  }

  @override
  void initState() {
    valueChoose = widget.availableAspectRatios[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String message = "Select aspect ratio of HLS player";
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HMSTitleText(
            text: "Change Aspect Ratio",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          const SizedBox(
            height: 8,
          ),
          HMSSubtitleText(text: message, textColor: themeSubHeadingColor),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: themeSurfaceColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: borderColor, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: <DropdownMenuItem>[
                  ...widget.availableAspectRatios
                      .map((aspectRatio) => DropdownMenuItem(
                            value: aspectRatio,
                            child: HMSTitleText(
                              text: aspectRatio,
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ))
                      .toList(),
                ],
                    iconStyleData: IconStyleData(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: themeDefaultColor,
                    ),
                    selectedValue: valueChoose,
                    updateSelectedValue: _updateDropDownValue)),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    shadowColor: WidgetStateProperty.all(themeSurfaceColor),
                    backgroundColor:
                        WidgetStateProperty.all(themeBottomSheetColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: Color.fromRGBO(107, 125, 153, 1)),
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: () => Navigator.pop(context, false),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text('Cancel',
                      style: HMSTextStyle.setTextStyle(
                          color: themeDefaultColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50)),
                )),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: WidgetStateProperty.all(themeSurfaceColor),
                  backgroundColor: WidgetStateProperty.all(hmsdefaultColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: hmsdefaultColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              onPressed: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(
                  'Change',
                  style: HMSTextStyle.setTextStyle(
                      color: themeDefaultColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
