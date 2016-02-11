public class PaymentOptionsController {

   public Id optionId { get; set; }
   private Id objId = ApexPages.currentPage().getParameters().get('id');

   public PaymentOptionsController(ApexPages.StandardController stdController) {}

   public List<Payment_Option__c> getPaymentOptions() {
      List<Payment_Option__c> options = [SELECT
            Id,
            Name,
            Payment_Type__c,
            Original_Amount__c,
            Interest_Rate__c,
            Amortized_Term__c,
            Payment_Amount__c
         FROM
            Payment_Option__c
         WHERE
            Loan__c =: objId];
      return options;
   }

   public PageReference selectPayment() {
   
      Payment_Option__c p = [SELECT
            Id,
            Name,
            Loan__c,
            Payment_Type__c,
            Original_Amount__c,
            Interest_Rate__c,
            Amortized_Term__c,
            Payment_Amount__c
         FROM
            Payment_Option__c
         WHERE
            Id =: optionId];

      LLC_BI__Loan__c loan = [SELECT
            Id,
            LLC_BI__Amount__c,
            LLC_BI__InterestRate__c,
            LLC_BI__Amortized_Term_Months__c,
            LLC_BI__Payment_Type__c
         FROM
            LLC_BI__Loan__c
         WHERE
            Id =: objId];

      loan.LLC_BI__Amount__c = p.Original_Amount__c;
      loan.LLC_BI__InterestRate__c = p.Interest_Rate__c;
      loan.LLC_BI__Amortized_Term_Months__c = p.Amortized_Term__c;
      loan.LLC_BI__Payment_Type__c = p.Payment_Type__c;
      Database.update(loan);

      return new PageReference ('/' + objId);
   }
   
   public PageReference viewPayment() {
      return new PageReference ('/' + optionId);
   }
}