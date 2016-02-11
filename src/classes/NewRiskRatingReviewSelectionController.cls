public with sharing class NewRiskRatingReviewSelectionController{

    Public NewRiskRatingReviewSelectionController() {
        objId = Apexpages.currentPage().getParameters().get('lid');
        theID = Apexpages.currentPage().getParameters().get(PARAMETERNAMEID );
        type = Apexpages.currentPage().getParameters().get(PARAMETERNAMETYPE );

        if (type != TYPELOAN && type != TYPEREL) {
            NoTypeSet();
        } else if (type == TYPELOAN) {
            if (theID == null) {
                NoIDSet();
            } else {
                type1Loan = [SELECT Id, Name, Risk_Rating_Review_Template__c FROM LLC_BI__Loan__c WHERE Id = :theID LIMIT 1];

                if(type1Loan.size() > 0) {
                    type1 = true;
                    type2 = false;
                    
                    if (type1loan[0].Risk_Rating_Review_Template__c != null) {
                        RiskGrade = type1loan[0].Risk_Rating_Review_Template__c;
                    }
                    
                    singleLoanName = type1Loan[0].Name;

                    currentRelationships = [SELECT Id, LLC_BI__Account__c, LLC_BI__Account__r.Name, LLC_BI__Borrower_Type__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c = :theID];
                } else {
                    InvalidIDSetLoan();
                }
            }
        } else if (type == TYPEREL) {
            if (theID == null) {
                NoIDSet();
            } else {
                type2Relationship = [SELECT Id, Name FROM Account WHERE Id = :theID LIMIT 1];

                if (type2Relationship.size() > 0) {
                    type1 = false;
                    type2 = true;
                    AccountSelection = true;
                    AccountOnly = false;
                    AccountLoan = false;
                                        
                    singleRelationshipName = type2Relationship[0].Name;

                    currentLoans = [SELECT Id, LLC_BI__Loan__c, LLC_BI__Loan__r.Name, LLC_BI__Loan__r.LLC_BI__lookupKey__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Account__c = :theID];

                } else {
                    InvalidIDSetRelationship();
                }
            }
        }
    }

    //ALL BELOW ARE FOR TYPE 1 AKA FROM LOAN CREATION OF RISK RATING REVIEW
    Public PageReference NoTypeSet() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.RRR_Error_NoTypeSet));
        type1 = false;
        type2 = false;
        return null;
    }

    Public PageReference NoIDSet() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.RRR_Error_NoIDSet));
        type1 = false;
        type2 = false;
        return null;
    }

    Public PageReference InvalidIDSetLoan() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.RRR_Error_InvalidIDSetLoan));
        type1 = false;
        type2 = false;
        return null;
    }

    Public PageReference InvalidIDSetRelationship() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.RRR_Error_InvalidIDSetRelationship));
        type1 = false;
        type2 = false;
        return null;
    }

    public List<SelectOption> getRelationships() {
        List<SelectOption> relationshipList = new List<SelectOption>();
        relationshipList.add(new SelectOption(SELECTOPTIONVALUE,SELECTOPTIONLABEL));
        for (LLC_BI__Legal_Entities__c r: currentRelationships) {
            SelectrelationshipLabel(r.LLC_BI__Account__r.Name, r.LLC_BI__Borrower_Type__c);
            relationshipList.add(new SelectOption(r.LLC_BI__Account__c, SELECTLABEL));
        }
        return relationshipList;
    }    

    Public List<Schema.PicklistEntry> getTemplateList() {
        Schema.DescribeFieldResult F = LLC_BI__Loan__c.Risk_Rating_Review_Template__c.getDescribe();
        List<Schema.PicklistEntry> temp = F.getPicklistValues();

        return temp;
    }
    
    Public List<Schema.PicklistEntry> getAccountTemplateList() {
        Schema.DescribeFieldResult F = Account.Risk_Rating_Review_Template__c.getDescribe();
        List<Schema.PicklistEntry> temp = F.getPicklistValues();

        return temp;
    }
    
    public List<SelectOption> getTemplatePicklist() {
        List<SelectOption> templateList= new List<SelectOption>();
        templateList.add(new SelectOption(SELECTOPTIONVALUE,SELECTOPTIONLABEL));
        for (Schema.PicklistEntry r: getTemplateList()) {
            templateList.add(new SelectOption(r.value, r.label));
        }
        return templateList;
    }
    
    public List<SelectOption> getAccountTemplatePicklist() {
        List<SelectOption> templateList= new List<SelectOption>();
        templateList.add(new SelectOption(SELECTOPTIONVALUE,SELECTOPTIONLABEL));
        for (Schema.PicklistEntry r: getAccountTemplateList()) {
            templateList.add(new SelectOption(r.value, r.label));
        }
        return templateList;
    }
    
    public List<SelectOption> getCreateByAccountPicklist() {
        List<SelectOption> createlist= new List<SelectOption>();
        createlist.add(new SelectOption(SELECTOPTIONVALUE,SELECTOPTIONLABEL));
        createlist.add(new SelectOption(ACCOUNTONLYVALUE, ACCOUNTONLYLABEL));
        createlist.add(new SelectOption(ACCOUNTLOANVALUE, ACCOUNTLOANLABEL));
        return createlist;
    }
    
    Public PageReference AccountSelection() {
        if(CreateBy == ACCOUNTONLYVALUE) {
            AccountOnly = true;
            AccountLoan = false;
            AccountSelection = false;
            
            List<Account> a = [SELECT Risk_Rating_Review_Template__c FROM Account WHERE Id = :theID LIMIT 1];
            
            if (a.size() > 0) {
                if (a[0].Risk_Rating_Review_Template__c != null) {
                    RiskGrade = a[0].Risk_Rating_Review_Template__c;
                } else {
                    RiskGrade = SELECTOPTIONVALUE;
                }
            }
        } else if(CreateBy == ACCOUNTLOANVALUE) {
            AccountOnly = false;
            AccountLoan = true;
            AccountSelection = false;
        } else {
            AccountOnly = false;
            AccountLoan = false;
            AccountSelection = true;
        }
        return null;
    }
    
    Public PageReference Reset() {
        AccountOnly = false;
        AccountLoan = false;
        AccountSelection = true;
        CreateBy = SELECTOPTIONVALUE;
        return null;
    }
    
    Public PageReference LoanSelection() {
        List<LLC_BI__Loan__c> theselectedloan = [SELECT Id, Risk_Rating_Review_Template__c FROM LLC_BI__Loan__c WHERE Id = :LoanID];
        
        if (theselectedloan.size() > 0) {
            if (theselectedloan[0].Risk_Rating_Review_Template__c != null) {
                RiskGrade = theselectedloan[0].Risk_Rating_Review_Template__c;
            } else {
                RiskGrade = SELECTOPTIONVALUE;
            }
        }
        return null;
    }

    Public PageReference Create() {
        LLC_BI__Loan__c MyUpdateLoan = [SELECT Id, Risk_Rating_Review_Template__c FROM LLC_BI__Loan__c WHERE Id = :theID LIMIT 1];
        MyUpdateLoan.Risk_Rating_Review_Template__c = RiskGrade;
        update MyUpdateLoan;

        LLC_BI__Annual_Review__c NewRRR = new LLC_BI__Annual_Review__c(LLC_BI__Account__c = RelationshipID, LLC_BI__Loan__c = theID);
        insert NewRRR;
        

        PageReference pageRef = new PageReference('/' + NewRRR.Id);
        system.debug('*** Page Ref : ' + pageRef);
        pageRef.setRedirect(true);

        return pageRef;
 
    }

    public List<SelectOption> getLoans() {
        List<SelectOption> loanList = new List<SelectOption>();
        loanList.add(new SelectOption(SELECTOPTIONVALUE,SELECTOPTIONLABEL));
        for (LLC_BI__Legal_Entities__c r: currentLoans) {
            SelectloanLabel(r.LLC_BI__Loan__r.Name, r.LLC_BI__Loan__r.LLC_BI__lookupKey__c);
            loanList.add(new SelectOption(r.LLC_BI__Loan__c, SELECTLABEL));
        }
        return loanList;
    }

    Public PageReference CreateFromRelationship() {
        LLC_BI__Loan__c MyUpdateLoan = [SELECT Id, Risk_Rating_Review_Template__c FROM LLC_BI__Loan__c WHERE Id = :LoanID LIMIT 1];
        MyUpdateLoan.Risk_Rating_Review_Template__c = RiskGrade;
        update MyUpdateLoan;

        LLC_BI__Annual_Review__c NewRRR = new LLC_BI__Annual_Review__c(LLC_BI__Account__c = theID, LLC_BI__Loan__c = LoanID);
        insert NewRRR;

        PageReference pageRef = new PageReference('/' + NewRRR.Id);
        pageRef.setRedirect(true);

        return pageRef;
    }
    
    Public PageReference CreateFromRelationshipOnly() {
        Account MyUpdateAccount = [SELECT Id, Risk_Rating_Review_Template__c FROM Account WHERE Id = :theID LIMIT 1];
        MyUpdateAccount.Risk_Rating_Review_Template__c = RiskGrade;
        update MyUpdateAccount;

        LLC_BI__Annual_Review__c NewRRR = new LLC_BI__Annual_Review__c(LLC_BI__Account__c = theID);
        insert NewRRR;

        PageReference pageRef = new PageReference('/' + NewRRR.Id);
        pageRef.setRedirect(true);

        return pageRef;
    }

    //STATIC FUNCTIONS AND VARIABLES LOCATED BELOW

    Public void SelectrelationshipLabel(String relname, String type) {
        SELECTLABEL = relname + ' - (' + type + ')';
    }

    Public void SelectloanLabel(String loanname, String loannumber) {
        SELECTLABEL = loanname + ' - (#' + loannumber + ')';
    }
    
    Public Id objId {get;set;}
    Public String theID {get;set;}
    Public String type {get;set;}
    Public String RiskGrade {get;set;}
    public String RelationshipID {get;set;}
    Public String LoanID {get;set;}
    Public List<LLC_BI__Loan__c> type1Loan {get;set;}
    Public String singleLoanName {get;set;}
    Public List<Account> type2Relationship {get;set;}
    Public String singleRelationshipName {get;set;}
    Public List<LLC_BI__Legal_Entities__c> currentRelationships {get;set;}
    Public List<LLC_BI__Legal_Entities__c> currentLoans {get;set;}
    Public Boolean type1 {get;set;}
    Public Boolean type2 {get;set;}
    Public String CreateBy {get;set;}
    Public Boolean AccountOnly {get;set;}
    Public Boolean AccountLoan {get;set;}
    Public Boolean AccountSelection {get;set;}

    Public String SELECTLABEL;
    Private Static Final String SELECTOPTIONVALUE = 'None';
    Private Static Final String SELECTOPTIONLABEL = '-- None Selected --';
    Private Static Final String TYPELOAN = 'loan';
    Private Static Final String TYPEREL = 'rel';
    Private Static Final String PARAMETERNAMETYPE = 'type';
    Private Static Final String PARAMETERNAMEID = 'id';
    Private Static Final String ACCOUNTONLYLABEL = 'Create For Account Only';
    Private Static Final String ACCOUNTONLYVALUE = 'Account';
    Private Static Final String ACCOUNTLOANLABEL = 'Create For Account And Loan';
    Private Static Final String ACCOUNTLOANVALUE = 'AccountLoan';
}