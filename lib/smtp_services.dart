import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SmtpServices {
  mail(String name, String phone, String city, String address,
      String quantity /*,String note*/, BuildContext context) async {
    String username = 'salvafastfood1@gmail.com';
    String password = 'xylccexozxjsnlax';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Ansaar Bazar')
      ..recipients.add('Support@salvafastfood.com')
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'SFF Support message on  ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          """<table style="border-collapse: collapse; width: 100%; height: 160px;" border="1">
  <tbody>
  <tr style="height: 18px;">
  <td style="width: 19.2008%; height: 18px;"><strong>First Name</strong></td>
  <td style="width: 80.7992%; height: 18px;">&nbsp; &nbsp;$name</td>
  </tr>
  <tr style="height: 18px;">
  <td style="width: 19.2008%; height: 18px;"><strong>Last Name</strong></td>
  <td style="width: 80.7992%; height: 18px;">&nbsp; &nbsp;$phone</td>
  </tr>
  <tr style="height: 18px;">
  <td style="width: 19.2008%; height: 18px;"><strong>Email</strong></td>
  <td style="width: 80.7992%; height: 18px;">&nbsp; &nbsp;$city</td>
  </tr>
  <tr style="height: 18px;">
  <td style="width: 19.2008%; height: 18px;"><strong>Number</strong></td>
  <td style="width: 80.7992%; height: 18px;">&nbsp; &nbsp;$address</td>
  </tr>
  <tr style="height: 88px;">
  <td style="width: 19.2008%; height: 88px;"><strong>Message</strong></td>
  <td style="width: 80.7992%; height: 88px;">&nbsp;$quantity</td>
  </tr>
  </tbody>
  </table>""";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      const snackBar = SnackBar(
        content: Text('Data submitted successfully'),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Message not sent.${e.message}'),
      ));
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
