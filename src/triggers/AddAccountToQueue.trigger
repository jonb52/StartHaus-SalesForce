// #4
// If an account is saved without an address, without a phone number, or without the 
// number of employees, then create a case and assign it to a queue so that someone can follow up to 
// find out the details for the account. 
trigger AddAccountToQueue on Account (after insert) {

	List<QueuesObject> listOfCasesInQueue = new List<QueuesObject>();

	List<Case> listOfCases = new List<Case>();

	// Variable to hold the queue where all cases will get assigned.
	Group inspectAccountQueue =  [SELECT Id
								    FROM Group
								   WHERE Name = 'Inspect Account Info'
								   LIMIT 1
									];

	// Checks to see if the queue exists yet. If not, create it.
	if(inspectAccountQueue == null){
		inspectAccountQueue = new Group(Name='Inspect Account Info', type='Queue');
	}

	for(Account acct : Trigger.new){
		// Checks to see if any of the following fields are blank. If so, then create a case
		if(acct.BillingCity 			== null || acct.ShippingCity 		== null
		   || acct.BillingState			== null || acct.ShippingState 		== null
		   || acct.BillingStreet		== null || acct.ShippingStreet 		== null
		   || acct.BillingPostalCode	== null || acct.ShippingPostalCode 	== null
		   || acct.Phone 				== null || acct.NumberOfEmployees 	== null
		   )
		{
			Case newCase = new Case(AccountId = acct.Id,
				                    Subject = 'Please review this accounts contact information.',
				                    OwnerId = inspectAccountQueue.Id);
			listOfCases.add(newCase);
		}
	}

	insert listOfCases;


}