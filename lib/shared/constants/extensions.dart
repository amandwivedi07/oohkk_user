import 'package:intl/intl.dart';

import '../../modules/auth/models/user.dart';

extension Currency on String {
  String toCurrency() {
    return '₹ $this';
  }
}

extension NumCurrency on num {
  String toCurrency() {
    return '₹ $this';
  }
}

extension Format on DateTime {
  String dateToHumanReadable() {
    return DateFormat('EEEE,  d MMM, yyyy').format(toLocal());
  }

  String dateToHumanReadableNoDay() {
    return DateFormat('d MMM, yyyy').format(toLocal());
  }

  String dateTimeToHumanReadable() {
    return DateFormat('d MMM, h:mm a').format(toLocal());
  }

  String timeToHumanReadable() {
    return DateFormat().add_jm().format(toLocal());
  }
}
