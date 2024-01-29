import 'package:flutter/material.dart';

class ContactUsState {
  bool isSubmit;
  TextEditingController? nameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? subjectController = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();

  ContactUsState({
    required this.isSubmit,
    this.nameController,
    this.emailController,
    this.subjectController,
    this.descriptionController,
  });

  ContactUsState.initialState()
      : nameController = TextEditingController(text: ''),
        isSubmit = false,
        emailController = TextEditingController(text: ''),
        subjectController = TextEditingController(text: ''),
        descriptionController = TextEditingController(text: '');
}
