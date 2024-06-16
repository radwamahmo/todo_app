import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../my_theme.dart';
import '../providers/app_config_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeBottomSheet extends StatefulWidget {
  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      padding: EdgeInsets.all(20),
      color: provider.isDarkMode()?
          MyTheme.appColor
          :MyTheme.whiteColor,
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

      InkWell(
        onTap: (){
         provider.changeTheme(ThemeMode.dark);
        },
        child: provider.isDarkMode() ?
            getSelectedItemWidget(AppLocalizations.of(context)!.dark)
          :
            getUnSelectedItemWidget(AppLocalizations.of(context)!.dark)
      ),
              SizedBox(height: 15,),
             InkWell(
               onTap: (){
                 provider.changeTheme(ThemeMode.light);
               },
              child: provider.appTheme == ThemeMode.light ?
                  getSelectedItemWidget(AppLocalizations.of(context)!.light)
                  :
                  getUnSelectedItemWidget(AppLocalizations.of(context)!.light
                  )
              )
            ],
          ),



    );
  }

  Widget getSelectedItemWidget(String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold
            )),
        Icon(Icons.check, size: 30,color: Theme.of(context).primaryColor),
      ],
    );
  }
  Widget getUnSelectedItemWidget(String text){
    return Text(text,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
