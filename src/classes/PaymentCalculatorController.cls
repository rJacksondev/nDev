public class PaymentCalculatorController {
   
   public Boolean prinAndInt  { get; set; }
   public Boolean prinPlusInt { get; set; } 
   public Boolean intOnly     { get; set; }
   public Boolean loanAMT     { get; set; }
   public Boolean intRate     { get; set; } 
   public Boolean amTerm      { get; set; }
   public Boolean elseFlag    { get; set; }
   public Id objId = ApexPages.currentPage().getParameters().get('id');
   public Decimal showFinalCalculatedAmount { get; set; }
   public String saveLink                   { get; set; }
 
   public PaymentCalculatorController(ApexPages.StandardController controller) {
 
      Decimal loanAmount = 0;
      Decimal interestRateBefore = 0;
      Decimal interestRateAfter = 0;
      Integer numberOfPayments = 0;
      String paymentType = null;
 
      LLC_BI__Loan__c l = [SELECT
            Id,
            LLC_BI__Amount__c,
            LLC_BI__InterestRate__c,
            LLC_BI__Amortized_Term_Months__c,
            LLC_BI__Payment_Type__c
         FROM
            LLC_BI__Loan__c
         WHERE
            Id =: objId];
 
      if (l.LLC_BI__Payment_Type__c == 'Principal+Interest') {

         prinPlusInt = true;
         if (l.LLC_BI__Amount__c != null) {
            loanAMT = true;
            loanAmount = l.LLC_BI__Amount__c;
         }

         if (l.LLC_BI__InterestRate__c != null) {
            intRate = true;
            interestRateBefore = l.LLC_BI__InterestRate__c;
         }

         if (l.LLC_BI__Amortized_Term_Months__c != null) {
            amTerm = true;
            numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         }
          
         if (l.LLC_BI__Amount__c != null && l.LLC_BI__InterestRate__c != null && l.LLC_BI__Amortized_Term_Months__c != null) { 
            Decimal principal = loanAmount / numberOfPayments;
            Decimal interest = loanAmount * ((interestRateBefore / 12) / 100);
            Decimal calculatedAmount = principal + interest;
            showFinalCalculatedAmount = calculatedAmount.setScale(2);
         }
 
      } else if (l.LLC_BI__Payment_Type__c == 'Interest Only' || l.LLC_BI__Payment_Type__c == 'Single Pay') {

         intOnly = true;
         if (l.LLC_BI__Amount__c != null) {
            loanAMT = true;
            loanAmount = l.LLC_BI__Amount__c;
         }

         if (l.LLC_BI__InterestRate__c != null) {
            intRate = true;
            interestRateBefore = l.LLC_BI__InterestRate__c;
         }

         if (l.LLC_BI__Amortized_Term_Months__c != null) {
            amTerm = true;
            numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         }

         if (l.LLC_BI__Amount__c != null && l.LLC_BI__InterestRate__c != null && l.LLC_BI__Amortized_Term_Months__c != null) { 
            Decimal numeratorFirst = interestRateBefore / 100;
            Decimal numeratorFinal = loanAmount * numeratorFirst;
            Decimal denominatorFinal = 12;
            Decimal calculatedAmount = numeratorFinal / denominatorFinal;
            showFinalCalculatedAmount = calculatedAmount.setScale(2);
         }
 
      } else if (l.LLC_BI__Payment_Type__c == 'Installment') {

         prinAndInt = true; 
         if (l.LLC_BI__Amount__c != null) {
            loanAMT = true;
            loanAmount = l.LLC_BI__Amount__c;
         }

         if (l.LLC_BI__InterestRate__c != null) {
            intRate = true;
            interestRateBefore = l.LLC_BI__InterestRate__c;
         }

         if (l.LLC_BI__Amortized_Term_Months__c != null) {
            amTerm = true;
            numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         }

         if (l.LLC_BI__Amount__c != null && l.LLC_BI__InterestRate__c != null && l.LLC_BI__Amortized_Term_Months__c != null) { 
            interestRateAfter = (interestRateBefore / 12) / 100;

            Decimal numeratorFirst = 1 + interestRateAfter;
            Decimal numeratorSecond = numeratorFirst.pow(numberOfPayments);
            Decimal numeratorFinal = interestRateAfter * numeratorSecond;
    
            Decimal denominatorFirst = 1 + interestRateAfter;
            Decimal denominatorSecond = denominatorFirst.pow(numberOfPayments);
            Decimal denominatorFinal = denominatorSecond - 1;
    
            Decimal calculatedAmount = loanAmount * (numeratorFinal / denominatorFinal);
            showFinalCalculatedAmount = calculatedAmount.setScale(2);
         }
      }
   }
   
   public PageReference Calculate() {
 
      Decimal loanAmount = 0;
      Decimal interestRateBefore = 0;
      Decimal interestRateAfter = 0;
      Integer numberOfPayments = 0;
      String paymentType = null;
      Integer interestRateBasis = 365;
      Date todaysDate = Date.today();
      Date todaysMonth = todaysDate.toStartOfMonth();
      Date startingDate = todaysMonth.addMonths(1);
 
 
      LLC_BI__Loan__c l =
         [
            SELECT
               Id,
               LLC_BI__Amount__c,
               LLC_BI__InterestRate__c,
               LLC_BI__Amortized_Term_Months__c,
               LLC_BI__Payment_Type__c
            FROM
               LLC_BI__Loan__c
            WHERE
               Id =: objId
         ];
 
      this.saveLink = '/' + objId;
 
      if (l.LLC_BI__Payment_Type__c == 'Principal+Interest') {
 
         loanAmount = l.LLC_BI__Amount__c;
         numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         interestRateBefore = l.LLC_BI__InterestRate__c;
         paymentType = l.LLC_BI__Payment_Type__c;
           
         Decimal principal = loanAmount / numberOfPayments;
         Decimal interest = loanAmount * ((interestRateBefore / 12) / 100);
         
         Decimal calculatedAmount = principal + interest;
         showFinalCalculatedAmount = calculatedAmount.setScale(2);
 
         Payment_Option__c option = new Payment_Option__c(
            Loan__c = l.Id, 
            Original_Amount__c = loanAmount, 
            Interest_Rate__c = interestRateBefore, 
            Amortized_Term__c = numberOfPayments, 
            Payment_Type__c = paymentType,  
            Payment_Amount__c = showFinalCalculatedAmount);
         insert option;
 
      } else if (l.LLC_BI__Payment_Type__c == 'Interest Only' || l.LLC_BI__Payment_Type__c == 'Single Pay') {
 
         loanAmount = l.LLC_BI__Amount__c;
         numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         interestRateBefore = l.LLC_BI__InterestRate__c;
         paymentType = l.LLC_BI__Payment_Type__c;
 
         Decimal numeratorFirst = interestRateBefore / 100;
         Decimal numeratorFinal = loanAmount * numeratorFirst;
 
         Decimal denominatorFinal = 12;
 
         Decimal calculatedAmount = numeratorFinal / denominatorFinal;
         Decimal finalCalculatedAmount = calculatedAmount.setScale(2);
 
         Payment_Option__c option = new Payment_Option__c(
            Loan__c = l.Id, 
            Original_Amount__c = loanAmount, 
            Interest_Rate__c = interestRateBefore, 
            Amortized_Term__c = numberOfPayments, 
            Payment_Type__c = paymentType, 
            Payment_Amount__c = finalCalculatedAmount);
         insert option;
 
      } else if (l.LLC_BI__Payment_Type__c == 'Installment') {
 
         loanAmount = l.LLC_BI__Amount__c;
         numberOfPayments = Integer.valueOf(l.LLC_BI__Amortized_Term_Months__c);
         interestRateBefore = l.LLC_BI__InterestRate__c;
         interestRateAfter = (interestRateBefore / 12) / 100;
         paymentType = l.LLC_BI__Payment_Type__c;
 
         Decimal numeratorFirst = 1 + interestRateAfter;
         Decimal numeratorSecond = numeratorFirst.pow(numberOfPayments);
         Decimal numeratorFinal = interestRateAfter * numeratorSecond;
 
         Decimal denominatorFirst = 1 + interestRateAfter;
         Decimal denominatorSecond = denominatorFirst.pow(numberOfPayments);
         Decimal denominatorFinal = denominatorSecond - 1;

         Decimal calculatedAmount = loanAmount * (numeratorFinal / denominatorFinal);
         Decimal finalCalculatedAmount = calculatedAmount.setScale(2);
 
         Payment_Option__c option = new Payment_Option__c(
            Loan__c = l.Id, 
            Original_Amount__c = loanAmount, 
            Interest_Rate__c = interestRateBefore, 
            Amortized_Term__c = numberOfPayments, 
            Payment_Type__c = paymentType,  
            Payment_Amount__c = finalCalculatedAmount, 
            Interest_Rate_Basis__c = interestRateBasis);
         insert option;
      }
 
      return new PageReference('/' + objId);
   }
}