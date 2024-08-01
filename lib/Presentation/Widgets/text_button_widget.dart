import 'package:flutter/material.dart';
import 'package:flutter_weather_app_clone/AppUtils/app_text_style.dart';



class TextButtonWidget extends StatelessWidget {
  final Function onButtonTap;
  final String btnTxt;
  final Color btnBackColor;
  final Color txtColor;
  const TextButtonWidget({
    required this.onButtonTap,
    required this.btnTxt,
    required this.btnBackColor,
    required this.txtColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 55,
        width: 214,
        decoration: BoxDecoration(
          color: btnBackColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: () {
            onButtonTap();
          },
          child: Text(
            btnTxt,
            style: AppTextStyle.gilroys18Regular().copyWith(
              color: txtColor,
              fontWeight:FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
