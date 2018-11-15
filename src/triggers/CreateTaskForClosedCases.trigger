// #5
// If a case is closed, create a task for the related account owner telling them to follow up with 
// the account. If there was a contact related to the case, include the name and contact information 
// in the task.

trigger CreateTaskForClosedCases on Case (before update) {

	List<Task> taskToInsert = new List<Task>();

	for(Case myCase : Trigger.new){
		if(myCase.Status.equalsIgnoreCase('Closed')){
			// Creates a new task, immediately setting the owner, related account, and subject  
			Task newTask = new Task(OwnerId     = myCase.OwnerId, 
				                    WhatId      = myCase.Id,
				                    Subject = 'Follow up with the Account related to the case');

			// If the case had a related contact, then add that same contact to the new task.
			if(myCase.ContactId != null){
				newTask.WhoId = myCase.ContactId;
			}
			// Adds the new task to the list to be bulk updated. 
			taskToInsert.add(newTask);
		}
	}
	insert taskToInsert;
}