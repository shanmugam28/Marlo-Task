part of contract_library;

class InvitedPeopleScreen extends StatelessWidget {
  const InvitedPeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context, listen: false);
    List<InvitedContact> contacts = dataManager.sortedInvitedContacts;
    return Scaffold(
      appBar: const MyAppBar(
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invited People',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => _ContactTile.invitedCategory(
                  contacts[index],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
