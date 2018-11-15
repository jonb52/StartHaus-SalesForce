// #1
// Automatically create a Renewal Opp for closed won deals

trigger CreateRenewal on Opportunity (before update, after insert) {

  // Create a list to store all renewal opps for bulk inserting
  List<Opportunity> renewals = new List<Opportunity>();

  for (Opportunity opp : Trigger.new) {
    // Only create renewal opps for closed won deals
    if (opp.StageName.equalsIgnoreCase('Closed Won')) {
       Opportunity renewal = new Opportunity();
       if(opp.AccountId != null){
       	renewal.AccountId  = opp.AccountId;
       }
       renewal.Name        = opp.Name + ' Renewal';
       renewal.CloseDate   = opp.CloseDate.addYears(1); // Add a year
       renewal.StageName   = 'Open';
       renewal.Type  	     = 'Renewal';
       renewal.OwnerId     = opp.OwnerId;
       renewals.add(renewal);
    }
  }

  // Bulk insert all renewals to avoid Governor Limits
  insert renewals;
}
