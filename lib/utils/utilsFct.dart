import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

String dateTimeToString(DateTime date){
  return DateFormat('dd/MM/yyyy').format(date);
}

DateTime stringToDateTime(String date){
  return DateFormat('dd/MM/yyyy').parse(date);
}

List<Map<String, Object?>> sortByDate(List<Map<String, Object?>> list){
  list.sort((a, b) {
    DateTime dateA = stringToDateTime(a["date"].toString() ) as DateTime;
    DateTime dateB =  stringToDateTime(b["date"].toString() )as DateTime;
    return dateA.compareTo(dateB);
  });

  return list;
}

class MyDateField extends StatefulWidget {
  final String hint;
  MyDateField(this.hint, {super.key});
  TextEditingController searchController = TextEditingController();
  final DateFormat format = DateFormat("dd/MM/yyyy");

  @override
  State<MyDateField> createState() => _MyDateFieldState();

  String getSelectedDate() {
    return searchController.text;
  }

  void resetSelectedDate() {
    searchController.text = "";
  }

  DateFormat getDateFormat() {
    return format;
  }
}

class _MyDateFieldState extends State<MyDateField> {
  @override

  Widget build(BuildContext context) {
    return DateTimeField(
      decoration: InputDecoration(
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
        ),
      ),
      format: widget.format,
      controller: widget.searchController,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2200),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        return date;
      },
    );
  }
}