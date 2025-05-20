import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../providers/friends_provider.dart';
import '../providers/settings_provider.dart';

Future<void> sendMailsToDebtors(SettingsProvider settingsProvider, Map<String, Map<String, double>> debts, FriendsProvider friendsProvider) async {
    final smtpServer = gmail(settingsProvider.email, settingsProvider.password);

    for (final debtorId in debts.keys) {
        final debtor = friendsProvider.getFriendById(debtorId);
        final debtorName = debtor?.name ?? 'Someone';
        final debtorEmail = debtor?.email;

        if (debtorEmail == null || debtorEmail.isEmpty) continue;

        final buffer = StringBuffer();
        buffer.writeln('Hello $debtorName,\n');
        buffer.writeln('Here is what you owe to your friends:\n');

        debts[debtorId]?.forEach((creditorId, amount) {
                final creditorName = friendsProvider.getFriendById(creditorId)?.name ?? creditorId;
                buffer.writeln('- ${settingsProvider.currency}${amount.toStringAsFixed(2)} to $creditorName');
            });

        buffer.writeln('\nSent by ${settingsProvider.username}');
        buffer.writeln('Have a nice day!');

        final message = Message()
            ..from = Address(settingsProvider.email, settingsProvider.username)
            ..recipients.add(debtorEmail)
            ..subject = 'Your Group Debt Summary'
            ..text = buffer.toString();

        try {
            final sendReport = await send(message, smtpServer);
            print('✅ Email sent to $debtorEmail: ${sendReport.toString()}');
        } catch (e) {
            print('❌ Failed to send to $debtorEmail: $e');
        }
    }
}