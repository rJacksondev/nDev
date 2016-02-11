public with sharing class RiskRatingReviewSelectionControllerOld {

    Public String objId = Apexpages.currentPage().getParameters().get('lid');
    public String RiskGrade      { get; set; }
    public String accountId      { get; set; }
    public Id templateId         { get; set; }

    public String getProfileName() {
        //List<User> USER = [SELECT Id, Name FROM User WHERE Id=:userinfo.getUserId() LIMIT 1];
        system.debug('*** Templated Id: ' + templateId);
        User user = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
        String userName = user.Name;
        return userName;
    }

    public List<LLC_BI__Legal_Entities__c> getEntities() {
        List<LLC_BI__Legal_Entities__c> entities = [SELECT Id, LLC_BI__Account__c, LLC_BI__Account__r.Name, LLC_BI__Borrower_Type__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: objId];
        return entities;
    }

    public List<SelectOption> getTemplates() {
        List<LLC_BI__Risk_Grade_Template__c> templates = [SELECT Id, Name FROM LLC_BI__Risk_Grade_Template__c WHERE LLC_BI__Risk_Rating_Review__c = null];
        List<SelectOption> options = new List<SelectOption>();
        for (LLC_BI__Risk_Grade_Template__c temp : templates) {
            options.add(new SelectOption(temp.Id, temp.Name));
        }
        return options;
    }

    public String getCurrentLoanName() {
        //List<LLC_BI__Loan__c> MyLoan = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE Id = :objId LIMIT 1];
        LLC_BI__Loan__c loan = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE Id =: objId LIMIT 1];
        String loanName = loan.Name;
        return loanName;
    }

    Public String getCurrentLoanId() {
        return objId;
    }

    public PageReference Create() {
        LLC_BI__Loan__c loan = [SELECT Id, Name, LLC_BI__Account__c, Risk_Rating_Review_Template__c FROM LLC_BI__Loan__c WHERE Id =: objId LIMIT 1];
        Account account = [SELECT Id, Name FROM Account WHERE Id =: loan.LLC_BI__Account__c];
        LLC_BI__Risk_Grade_Template__c template = [SELECT Id, Name FROM LLC_BI__Risk_Grade_Template__c WHERE Id =: templateId];
        system.debug('*** Template Id Before Assignment: ' + templateId);
        
        LLC_BI__Annual_Review__c annualReview = new LLC_BI__Annual_Review__c(LLC_BI__Account__c = account.Id, LLC_BI__Loan__c = objId, LLC_BI__Risk_Grade_Template__c = template.Id);
        system.debug('*** Template Id After Assignment: ' + templateId);
        insert annualReview;

        return new PageReference('/' + objId);
    }
}