trigger loan_insertCreditMemotemplate on LLC_BI__Loan__c (after insert) {

	if(Trigger.isInsert) {
		
		Id memoId = null;
		//the below section needs to be bulkified
		try {
			CreditMemo__c memo = [select Id from CreditMemo__c where Loan__c =: Trigger.new[0].Id];
			memoId = memo.Id;
		} catch(Exception e) {
			//no memo inserted yet, let's add one so we can add our elements in afterwards
			CreditMemo__c newmemo = new CreditMemo__c();
			newmemo.Loan__c = Trigger.new[0].Id;
			
			LLC_BI__Annual_Review__c[] reviews = [SELECT Id FROM LLC_BI__Annual_Review__c WHERE LLC_BI__Loan__c =: newmemo.Loan__c ORDER BY CreatedDate DESC];
			if(reviews.size() > 0){
				newmemo.Risk_Rating_Review__c = reviews[0].Id;
			}
			
			insert newmemo;
			memoId = newmemo.Id;
		}
		
		if(memoId != null) {
			List<CreditMemoConf__c> memoElements = CreditMemoConf__c.getAll().values(); //query all of our values configured from our custom settings
			if(memoElements != null) {
				List<Credit_Memo_Commentary__c> cmcAdd = new List<Credit_Memo_Commentary__c>();
				for(CreditMemoConf__c record : memoElements) {
					Credit_Memo_Commentary__c newElement = new Credit_Memo_Commentary__c();
					newElement.Type__c = record.Name;
					newElement.Credit_Memo__c = memoId;
					newElement.displayType__c = record.displayType__c;
					newElement.Sort_Order__c = record.sortOrder__c;
					newElement.CommentaryOnly__c = record.commentary__c;
					cmcAdd.add(newElement);
				}
				insert cmcAdd;
			}
		}
	}

}