import 'package:url_launcher/url_launcher.dart';

class Command {
  static const all = [email, browser1, browser2];

  static const email = 'write email';
  static const browser1 = 'open';
  static const browser2 = 'go to';
}

class Utils {
  static void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains(Command.email)) {
      final body = _getTextAfterCommand(text: text, command: Command.email);
      if (body != null) {
        openEmail(body: body);
      }
    } else if (text.contains(Command.browser1)) {
      final url = _getTextAfterCommand(text: text, command: Command.browser1);
      if (url != null) {
        openLink(url: url);
      }
    } else if (text.contains(Command.browser2)) {
      final url = _getTextAfterCommand(text: text, command: Command.browser2);
      if (url != null) {
        openLink(url: url);
      }
    }
  }

  static String? _getTextAfterCommand({
    required String text,
    required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null;
    }
    return text.substring(indexAfter).trim();
  }

  static Future openLink({
    required String url,
  }) async {
    if (url.trim().isEmpty) {
      await _launchUrl(Uri(scheme: 'https://google.com'));
    } else {
      await _launchUrl(Uri(scheme: 'https://$url'));
    }
  }

  static Future openEmail({required String body}) async {
    final url = Uri(scheme: 'mailto: ?body=${Uri.encodeFull(body)}');
    await _launchUrl(url);
  }

  static Future _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
