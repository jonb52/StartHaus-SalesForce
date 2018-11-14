//		When the address of a contact changes, create a task for the account owner that provides 
//		the new address and reminds them to send wine.

trigger TaskWineSendingToContactsNewAddress on Contact (before update) {
	
	Integer i = 0; // Variable used to compair records in trigger.new vs trigger.old
	List<Task> wineSendingTasks = new List<Task>();
	
	for (Contact con : Trigger.new){
		if(   con.MailingCity != Trigger.old[i].MailingCity 
		   || con.MailingCountry != Trigger.old[i].MailingCountry
		   || con.MailingPostalCode != Trigger.old[i].MailingPostalCode
		   || con.MailingState != Trigger.old[i].MailingState
		   || con.MailingStreet != Trigger.old[i].MailingStreet
		   )
		{
			Task sendWineTask = new Task();

			sendWineTask.OwnerId 	  = con.OwnerId; 	// Assigns the task to the contacts owner
			sendWineTask.Status 	  = 'Not Started';	// Sets the status of the task
			sendWineTask.Subject 	  = 'Send Wine to ' + con.FirstName + ' ' + con.LastName; // Sets the tasks subject
			sendWineTask.WhoId 		  = con.Id;			// Sets the name on the task to the contact with the new address
			sendWineTask.ActivityDate = Date.today().addDays(14); // Sets the due date to two weeks from the task create date
			sendWineTask.Description  = con.FirstName + ' ' + con.LastName + ' has moved. '
										+ 'Send wine to their new address at:\n\n'
										+ con.MailingStreet + '\n' 
										+ con.MailingCity + ' ' 
										+ con.MailingState + ' '
										+ con.MailingPostalCode + '\n'
										+ con.MailingCountry;
			wineSendingTasks.add(sendWineTask);
		}

		i++;				// Increments the counter variable 'i' to keep record compairisons consistant 
	}
	insert wineSendingTasks; // Inserts any new tasks
}