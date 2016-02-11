public class PaymentOptionsController {

   public Id optionId                     { get; set; }
   public List<Payment_Option__c> options { get; set; }
   public Id objId = ApexPages.currentPage().getParameters().get('id');

   public PaymentOptionsController() {
      options = [SELECT
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
      system.debug('Options Size: ' + options.size());
   }

   public void selectPayment() {
   
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
   }
   
   public PageReference viewPayment() {
      return new PageReference ('/' + optionId);
   }

   public Boolean getShowOptions() {
      Boolean flag = false;
      if (options.size() > 0) {
         flag = true;
      }

      return flag;
   }

   public Boolean getShowMessage() {
      Boolean flag = false;
      if (options.size() == 0) {
         flag = true;
      }

      return flag;
   }
}