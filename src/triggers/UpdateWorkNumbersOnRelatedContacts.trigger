// #3
// When the phone number of an account changes, update the “work” 
// phone number field on all of the related contacts.
trigger UpdateWorkNumbersOnRelatedContacts on Account (before update) {
	
	// Creates a list to hold all of the contacts needing to be updated
	List<Contact> contacts = new List<Contact>();		

	// For loop to loop over each account in the trigger
	for(Account acct : Trigger.new){
		// List to hold all of the contacts that are related to the account					
		List<Contact> contactsToUpdate = [SELECT Phone	
						       FROM Contact
						      WHERE AccountId = :acct.Id];

		// For loop to loop over the list holding each of the related contacts
		for (Contact contact : contactsToUpdate){	
			// Sets the contact phone number equal to the accounts new phone numebr
			contact.Phone = acct.Phone;		
			// Adds the contact to the list will batch update each of the updates later			
			contacts.add(contact);						
		}
	}
	// Updates each of the related contacts
	update contacts; 
}