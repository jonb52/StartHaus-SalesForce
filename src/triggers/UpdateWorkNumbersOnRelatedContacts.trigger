trigger UpdateWorkNumbersOnRelatedContacts on Account (before update) {
	
	List<Contact> contacts = new List<Contact>();		// Creates a list to hold all of the contacts needing to be updated

	for(Account acct : Trigger.new){					// For loop to loop over each account in the trigger
		List<Contact> contactsToUpdate = [SELECT Phone	// List to hold all of the contacts that are related to the account
						       FROM Contact
						      WHERE AccountId = :acct.Id];

		for (Contact contact : contactsToUpdate){		// For loop to loop over the list holding each of the related contacts
			contact.Phone = acct.Phone;					// Sets the contact phone number equal to the accounts new phone numebr
			contacts.add(contact);						// Adds the contact to the list will batch update each of the updates later
		}
	}
	update contacts; // Updates each of the related contacts
}