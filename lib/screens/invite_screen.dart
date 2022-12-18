// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:marlo_task/api_manager.dart';
import 'package:marlo_task/contact_atributes/invite_contact.dart';
import 'package:marlo_task/providers/data_manager.dart';
import 'package:marlo_task/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../contact_atributes/role.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  Role selectedRole = Role.admin;
  TextEditingController emailTextController = TextEditingController();
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invite',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
            const SizedBox(height: 30.0),
            _EmailTextField(
              controller: emailTextController,
              errorMessage: emailError,
            ),
            const SizedBox(height: 10.0),
            _RoleSelector(
              role: selectedRole,
              onRoleChanged: (role) {
                selectedRole = role;
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            _ContinueButton(
              emailTextController: emailTextController,
              role: () => selectedRole,
              emailError: (error) {
                setState(() => emailError = error);
              },
            ),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  final TextEditingController emailTextController;
  final Function role;
  final Function(String error)? emailError;

  const _ContinueButton({
    Key? key,
    required this.emailTextController,
    required this.role,
    this.emailError,
  }) : super(key: key);

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  _onTap() async {
    String email = widget.emailTextController.text.trim();
    if (email.isEmpty) {
      widget.emailError?.call('email is empty');
      return;
    } else if (!isValidMail(email)) {
      widget.emailError?.call('Email Id badly formatted');
      return;
    } else if (DataManager().invitedContacts.map((e) => e.email).contains(email)) {
      widget.emailError?.call('Email already exist');
      return;
    }
    setState(() => isLoading = true);
    try {
      if (!await isNetworkAvailable()) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('No internet'),
            ),
          );
      }
      InvitedContact contact = InvitedContact(
        id: const Uuid().v1(),
        email: email,
        role: widget.role.call(),
      );
      ApiManager? apiManager = await ApiManager.getInstance();
      ApiResponse<InvitedContact?>? response = await apiManager?.inviteContact(contact);

      if (response?.status ?? false) {
        DataManager().addInvitedContacts([response!.data!]);
        DataManager.notify();
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Invited $email'),
              ),
            );
          Navigator.pop(context);
        }
      } else {
        if (response?.error == 'EMAIL_EXISTS') {
          widget.emailError?.call('Email already exist');
        } else if (response?.error == 'INVALID_EMAIL') {
          widget.emailError?.call('Enter a valid email');
        }
      }
    } catch (e, s) {
      debugPrint("_ContinueButtonState _onTap: error in inviting contact $e\n$s");
    }
    setState(() => isLoading = false);
  }

  bool isValidMail(String email) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;

  const _EmailTextField({
    Key? key,
    required this.controller,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: TextField(
        controller: controller,
        cursorColor: Theme.of(context).disabledColor,
        decoration: InputDecoration(
          errorText: errorMessage,
          border: InputBorder.none,
          labelText: 'Business email',
          labelStyle: TextStyle(
            color: Theme.of(context).disabledColor,
            fontSize: 14.0,
          ),
          fillColor: dataManager.isDarkTheme ? const Color(0xFF232323) : const Color(0xFFE9EEF0),
          filled: true,
        ),
      ),
    );
  }
}

class _RoleSelector extends StatefulWidget {
  final Role role;
  final Function(Role role)? onRoleChanged;

  const _RoleSelector({
    Key? key,
    required this.role,
    this.onRoleChanged,
  }) : super(key: key);

  @override
  State<_RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<_RoleSelector> {
  Role? selectedRole;
  List<Role> roles = List.from(Role.values)..removeAt(0);

  late DataManager dataManager;

  @override
  Widget build(BuildContext context) {
    dataManager = Provider.of<DataManager>(context, listen: false);
    return InkWell(
      onTap: _showBottomSheet,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 60.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: dataManager.isDarkTheme ? const Color(0xFF232323) : const Color(0xFFE9EEF0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                (selectedRole ?? widget.role).getDisplayName(),
                style: TextStyle(color: Theme.of(context).disabledColor),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).accentColor,
            )
          ],
        ),
      ),
    );
  }

  _showBottomSheet() async {
    Role innerRole = selectedRole ?? widget.role;
    await showModalBottomSheet(
      context: context,
      backgroundColor: dataManager.isDarkTheme ? const Color(0xFF161618) : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Container(
                height: 5.0,
                width: 50.0,
                color: dataManager.isDarkTheme ? const Color(0xFF032935) : const Color(0xFFDFEFF5),
              ),
              Row(
                children: const [
                  Text(
                    'Team roles',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
              const SizedBox(height: 30.0),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (innerRole == roles[index]) {
                        Navigator.pop(context);
                        return;
                      }
                      innerRole = roles[index];
                      widget.onRoleChanged?.call(innerRole);
                      Navigator.pop(context);
                      selectedRole = innerRole;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: innerRole == roles[index]
                            ? (dataManager.isDarkTheme ? const Color(0xFF032935) : const Color(0xFFDFEFF5))
                            : dataManager.isDarkTheme
                                ? const Color(0xFF232323)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.all(5.0),
                      child: Text(
                        roles[index].getDisplayName(),
                        style: TextStyle(
                          color: innerRole == roles[index]
                              ? Theme.of(context).accentColor
                              : Theme.of(context).disabledColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
