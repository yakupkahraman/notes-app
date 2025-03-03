import 'package:binote/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:binote/components/my_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    final inversePrimaryColor = theme.colorScheme.inversePrimary;
    final String appInfoUrl = 'https://www.github.com/yakupkahraman/notes-app' ;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MyButton(
            icon: Icon(HugeIcons.strokeRoundedArrowLeft01, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          _buildSwitchListTile(context, scaffoldBackgroundColor, inversePrimaryColor, theme),
          _buildListTile(inversePrimaryColor, theme, scaffoldBackgroundColor, appInfoUrl),
        ],
      ),
    );
  }

  Widget _buildListTile(Color inversePrimaryColor, ThemeData theme, Color scaffoldBackgroundColor, String appInfoUrl) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
            title: const Text('App Info'),
            trailing: Icon(
              HugeIcons.strokeRoundedInformationCircle,
              color: inversePrimaryColor,
            ),
            tileColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () => launchURL(appInfoUrl),
          ),
    );
  }

  Widget _buildSwitchListTile(BuildContext context, Color scaffoldBackgroundColor, Color inversePrimaryColor, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SwitchListTile(
            title: const Text('Dark Mode'),
            value: context.watch<ThemeProvider>().isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme();
            },
            activeTrackColor: scaffoldBackgroundColor,
            inactiveTrackColor: scaffoldBackgroundColor,
            activeColor: inversePrimaryColor,
            inactiveThumbColor: inversePrimaryColor,
            tileColor: theme.colorScheme.primary,
            trackOutlineColor: WidgetStatePropertyAll(scaffoldBackgroundColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
    );
  }
}

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  } else {
    throw 'Could not launch $url';
  }
}
