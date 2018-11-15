//  #2
//	When the address of a contact changes, create a task for the account owner that provides 
//	the new address and reminds them to send wine.

trigger TaskWineSendingToContactsNewAddress on Contact (before update) {
	
	// Variable used to compair records in trigger.new vs trigger.old
	Integer i = 0; 
	// List to hold all of the tasks created below to be bulk inserted later
	List<Task> wineSendingTasks = new List<Task>();
	
	for (Contact con : Trigger.new){
		// If statement to check if any field related to the contact's address changed.
		if(   con.MailingCity != Trigger.old[i].MailingCity 
		   || con.MailingCountry != Trigger.old[i].MailingCountry
		   || con.MailingPostalCode != Trigger.old[i].MailingPostalCode
		   || con.MailingState != Trigger.old[i].MailingState
		   || con.MailingStreet != Trigger.old[i].MailingStreet
		   )
		{
			Task sendWineTask = new Task();

			// Assigns the task to the contacts owner
			sendWineTask.OwnerId 	  = con.OwnerId; 	
			// Sets the status of the task
			sendWineTask.Status 	  = 'Not Started';
			// Sets the tasks subject
			sendWineTask.Subject 	  = 'Send Wine to ' + con.FirstName + ' ' + con.LastName; 
			// Sets the name on the task to the contact with the new address
			sendWineTask.WhoId 		  = con.Id;		
			// Sets the due date to two weeks from the task create date
			sendWineTask.ActivityDate = Date.today().addDays(14); 
			// Sets the description of the new task to the contacts name and their new address
			sendWineTask.Description  = con.FirstName + ' ' + con.LastName + ' has moved. '
										+ 'Send wine to their new address at:\n\n'
										+ con.MailingStreet + '\n' 
										+ con.MailingCity + ' ' 
										+ con.MailingState + ' '
										+ con.MailingPostalCode + '\n'
										+ con.MailingCountry;
			// Adds the task to the list to later be bulk inserted
			wineSendingTasks.add(sendWineTask);
		}

		// Increments the counter variable 'i' to keep record compairisons consistant
		i++;				 
	}
	// Inserts the new tasks
	insert wineSendingTasks; 
}