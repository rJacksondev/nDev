trigger updateTaskStatus on LLC_BI__LLC_LoanDocument__c (after update) {
    for (Integer i = 0 ; i < trigger.new.size(); i++) {
        if (trigger.old[i].LLC_BI__reviewStatus__c == 'Exception' && trigger.new[i].LLC_BI__reviewStatus__c == 'In-File') {
            List<LLC_BI__LLC_LoanDocument__c> loanDocuments = Trigger.new;
            for (LLC_BI__LLC_LoanDocument__c document : loanDocuments) {
                UpdateTaskStatusTriggerHandler.updateStatus(document.Id);
            }
        }
    }
}