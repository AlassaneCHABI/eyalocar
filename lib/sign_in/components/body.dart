import 'package:flutter/material.dart';
import 'package:eyav2/components/no_account_text.dart';
import 'package:eyav2/components/socal_card.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Material(
                 // borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  //elevation: 10,
                  child: Padding(padding: EdgeInsets.all(8.0),
                    child:  Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 5, color: Colors.white),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                          ],
                        ),
                        child: Image.asset("assets/logo_bleu.jpg",height: 80,)
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: getProportionateScreenHeight(40)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
