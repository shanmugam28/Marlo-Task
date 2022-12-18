import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marlo_task/contact_atributes/contact.dart';
import 'package:marlo_task/contact_atributes/invite_contact.dart';
import 'package:marlo_task/providers/data_manager.dart';
import 'package:provider/provider.dart';

import '../contact_atributes/Role.dart';

class ContractScreen extends StatelessWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: Column(
          children: [
            _Header(
              headerText: 'All people',
              count: dataManager.contacts.length,
              showSeeAllOption: dataManager.contacts.length > 3,
            ),
            const SizedBox(height: 10.0),
            if (dataManager.contacts.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(3, dataManager.contacts.length),
                shrinkWrap: true,
                itemBuilder: (context, index) => _ContactTile.allContactCategory(dataManager.contacts[index]),
              ),
            if (dataManager.contacts.isEmpty)
              _getEmptyContent(
                context,
                text: 'No contacts available',
                isDarkTheme: dataManager.isDarkTheme,
              ),
            const SizedBox(height: 20.0),
            _Header(
              headerText: 'Invited people',
              count: dataManager.invitedContacts.length,
              showSeeAllOption: dataManager.invitedContacts.length > 2,
            ),
            const SizedBox(height: 10.0),
            if (dataManager.invitedContacts.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(2, dataManager.invitedContacts.length),
                shrinkWrap: true,
                itemBuilder: (context, index) => _ContactTile.invitedCategory(dataManager.invitedContacts[index]),
              ),
            if (dataManager.invitedContacts.isEmpty)
              _getEmptyContent(
                context,
                text: 'No invites available',
                isDarkTheme: dataManager.isDarkTheme,
              )
          ],
        ),
      ),
    );
  }

  _getEmptyContent(context, {required String text, required bool isDarkTheme}) => Container(
        height: 70.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkTheme ? const Color(0xFF161618) : const Color(0xFFE9EEF0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
      );
}

class _ContactTile extends StatelessWidget {
  final Contact? contact;
  final InvitedContact? invitedContact;
  final Widget avatar;
  final Role role;
  final String displayName;

  factory _ContactTile.allContactCategory(Contact contact) => _ContactTile._(contact: contact);

  factory _ContactTile.invitedCategory(InvitedContact contact) => _ContactTile._(invitedContact: contact);

  _ContactTile._({
    Key? key,
    this.contact,
    this.invitedContact,
  })  : avatar = contact?.getAvatar() ?? invitedContact!.getAvatar(),
        displayName = contact?.name.displayName ?? invitedContact!.email,
        role = contact?.role ?? invitedContact!.role,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: dataManager.isDarkTheme ? const Color(0xFF161618) : Colors.white,
        ),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    isInvitedContactTile
                        ? role.getDisplayName()
                        : contact!.isActive
                            ? 'Active'
                            : 'Inactive',
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            if (!isInvitedContactTile)
              Text(
                role.getDisplayName(),
              )
          ],
        ),
      ),
    );
  }

  bool get isInvitedContactTile => invitedContact != null;
}

class _Header extends StatelessWidget {
  final String headerText;
  final int count;
  final bool showSeeAllOption;
  final Function()? onSeeAllTapped;

  const _Header({
    Key? key,
    required this.headerText,
    required this.count,
    this.showSeeAllOption = true,
    this.onSeeAllTapped,
  })  : assert((showSeeAllOption || onSeeAllTapped == null),
            'if [showSeeAllOption] is false, then [onSeeAllTapped] should be null'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          headerText,
          style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          width: 3,
          height: 3,
          color: Theme.of(context).disabledColor,
        ),
        const SizedBox(width: 10.0),
        Text(
          count.toString(),
          style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        if (showSeeAllOption)
          InkWell(
            onTap: () => onSeeAllTapped?.call(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'See all',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ),
          )
      ],
    );
  }
}
