part of contract_library;

class AllPeopleScreen extends StatelessWidget {
  const AllPeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context, listen: false);
    List<Contact> contacts = dataManager.sortedContacts;
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
              'All People',
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
                itemBuilder: (context, index) => _ContactTile.allContactCategory(
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
