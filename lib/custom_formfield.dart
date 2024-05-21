import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final bool obscureText;
  final String validator;
  final String placeholder;
  final TextEditingController? textEditingController;
  final String dataType; 

  const CustomFormField({
    Key? key,
    required this.obscureText,
    required this.validator,
    required this.placeholder,
    this.textEditingController,
    required this.dataType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                      controller: textEditingController,
                      decoration:  InputDecoration(
                        hintText: placeholder,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:  BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        focusedBorder:const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      errorBorder:const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedErrorBorder:const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return validator;
                        }
                        switch (dataType) {
                          case 'int':
                            if (int.tryParse(value) == null) {
                              return validator;
                            }
                            break;
                          case 'float':
                            if (double.tryParse(value) == null) {
                              return validator;
                            }
                            break;
                          case 'string':
                            // Add any string-specific validations here
                            break;
                          default:
                            return 'Invalid data type';
                        }
                        return null;
                      },
                      obscureText: obscureText,
                  );
  }
}
