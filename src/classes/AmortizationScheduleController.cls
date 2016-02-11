public class AmortizationScheduleController {

   public Id objId = ApexPages.currentPage().getParameters().get('id');
   public List<ScheduleRow> scheduleRow { get; set; }

   public AmortizationScheduleController(ApexPages.StandardController controller) {

      Payment_Option__c o = 
         [
            SELECT 
               Id, 
               Amortized_Term__c, 
               Payment_Amount__c, 
               Interest_Rate__c, 
               Original_Amount__c, 
               Starting_Date__c, 
               Interest_Rate_Basis__c, 
               Payment_Type__c 
            FROM 
               Payment_Option__c 
            WHERE 
               Id =: objId
         ];

      if (o.Payment_Type__c == 'Installment') {

         scheduleRow = new List<ScheduleRow>();

         Date newDate;
         Integer numberOfPayments;
         Decimal payment;
         Decimal originalAmount;
            
         Integer testDate;
         Integer previousMonthDays;
         Integer interestRateBasis;

         Decimal interestRate;
         Decimal interestPayment;
         Decimal interestPaymentFinal;
         Decimal principalPayment;
         Decimal beginningBalance;

         Integer finalDays;
         Decimal finalInterest;
         Decimal finalPrincipal;
         Decimal finalBalance;

         numberOfPayments = Integer.valueOf(o.Amortized_Term__c);
         payment = o.Payment_Amount__c;
         originalAmount = o.Original_Amount__c;
         newDate = o.Starting_Date__c;
         interestRateBasis = Integer.ValueOf(o.Interest_Rate_Basis__c);
         interestRate = o.Interest_Rate__c / 100;

         finalDays = Date.daysInMonth(newDate.year(), newDate.month());
         finalInterest = originalAmount * interestRate / interestRateBasis * finalDays;
         finalPrincipal = payment - finalInterest;
         finalBalance = originalAmount - finalPrincipal;

         this.scheduleRow.clear();

         for (Integer i = 0; i < numberOfPayments; i++) {

            ScheduleRow r = new ScheduleRow();

            r.row = i + 1;
            previousMonthDays = Date.daysInMonth(newDate.year(), newDate.month());
            newDate = newDate.addMonths(1).toStartofMonth();

            testDate = testDate;
            testDate = Date.daysInMonth(newDate.year(), newDate.month());

            r.paymentDate = newDate;
            r.paymentAmount = payment;
            r.balanceAmount = finalBalance.setScale(2);
            r.interestAmount = finalInterest.setScale(2);
            r.principalAmount = finalPrincipal.setScale(2);
            r.numberOfDays = testDate;
            r.daysInPriorMonth = previousMonthDays;
                
            this.scheduleRow.add(r);

            Decimal lastRowBalance = finalBalance;
            previousMonthDays = Date.daysInMonth(newDate.year(), newDate.month());
            finalInterest = lastRowBalance * interestRate / interestRateBasis * previousMonthDays;
            finalPrincipal = payment - finalInterest;
            finalBalance -= finalPrincipal;
         }

      } else if (o.Payment_Type__c == 'Principal+Interest') {

         scheduleRow = new List<ScheduleRow>();

         Date newDate;
         Integer numberOfPayments;
         Decimal payment;
         Decimal originalAmount;
            
         Integer testDate;
         Integer previousMonthDays;
         Integer interestRateBasis;

         Decimal interestRate;
         Decimal interestPayment;
         Decimal interestPaymentFinal;
         Decimal principalPayment;
         Decimal beginningBalance;

         Integer finalDays;
         Decimal finalInterest;
         Decimal finalPrincipal;
         Decimal finalBalance;

         numberOfPayments = Integer.valueOf(o.Amortized_Term__c);
         payment = o.Payment_Amount__c;
         originalAmount = o.Original_Amount__c;
         newDate = o.Starting_Date__c;
         interestRateBasis = Integer.ValueOf(o.Interest_Rate_Basis__c);
         interestRate = o.Interest_Rate__c;

         finalDays = Date.daysInMonth(newDate.year(), newDate.month());
         finalInterest = originalAmount * ((interestRate / 12) / 100);
         finalPrincipal = originalAmount / numberOfPayments;
         finalBalance = originalAmount - finalPrincipal;

         this.scheduleRow.clear();

         for (Integer i = 0; i < numberOfPayments; i++) {

            ScheduleRow r = new ScheduleRow();

            r.row = i + 1;
            previousMonthDays = Date.daysInMonth(newDate.year(), newDate.month());
            newDate = newDate.addMonths(1).toStartofMonth();

            testDate = testDate;
            testDate = Date.daysInMonth(newDate.year(), newDate.month());

            r.paymentDate = newDate;
            r.paymentAmount = payment;
            r.balanceAmount = finalBalance.setScale(2);
            r.interestAmount = finalInterest.setScale(2);
            r.principalAmount = finalPrincipal.setScale(2);
            r.numberOfDays = testDate;
            r.daysInPriorMonth = previousMonthDays;
                
            this.scheduleRow.add(r);

            Decimal lastRowBalance = finalBalance;
            previousMonthDays = Date.daysInMonth(newDate.year(), newDate.month());
            finalInterest = lastRowBalance * ((interestRate / 12) / 100);
            finalPrincipal = originalAmount / numberOfPayments;
            finalBalance -= finalPrincipal;
            Decimal finalPayment = finalInterest + finalPrincipal;
            payment = finalPayment.setScale(2);
        }

        } else if (o.Payment_Type__c == 'Interest Only' || o.Payment_Type__c == 'Balloon') {
            //code
      }
   }

   class ScheduleRow {

      public Integer row              { get; set; }
      public Decimal paymentAmount    { get; set; }
      public Decimal balanceAmount    { get; set; }
      public Decimal interestAmount   { get; set; }
      public Decimal principalAmount  { get; set; }
      public Date paymentDate         { get; set; }
      public Integer numberOfDays     { get; set; }
      public Integer daysInPriorMonth { get; set; }
   }
}