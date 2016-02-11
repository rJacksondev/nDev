@isTest
public class AmortizationScheduleControllerTest {
	
	static testMethod void PrincipalAndInterestTest() {
		LLC_BI__Loan__c l1 = new LLC_BI__Loan__c(
         Name = LOAN_NAME, 
         LLC_BI__Payment_Type__c = PRINCIPAL_AND_INTEREST,
         LLC_BI__Amount__c = AMOUNT,
         LLC_BI__InterestRate__c = INTEREST_RATE,
         LLC_BI__Amortized_Term_Months__c = AMORTIZED_TERM);
      insert l1;

      Payment_Option__c p1 = new Payment_Option__c(
      	Loan__c = l1.Id,
      	Original_Amount__c = l1.LLC_BI__Amount__c,
      	Interest_Rate__c = l1.LLC_BI__InterestRate__c,
         Amortized_Term__c = l1.LLC_BI__Amortized_Term_Months__c, 
         Payment_Type__c = l1.LLC_BI__Payment_Type__c,
         Payment_Amount__c = l1.LLC_BI__Amount__c,
         Interest_Rate_Basis__c = INTEREST_RATE_BASIS,
         Starting_Date__c = System.Today());
      insert p1;

      ApexPages.StandardController stdController = new ApexPages.StandardController(p1);    
      ApexPages.currentPage().getParameters().put('id', p1.Id);
      AmortizationScheduleController ctrl = new AmortizationScheduleController(stdController);

      System.assertNotEquals(null, l1.Id);  
      System.assertEquals(LOAN_NAME, l1.Name);
      System.assertEquals(PRINCIPAL_AND_INTEREST, l1.LLC_BI__Payment_Type__c);
      System.assertEquals(AMOUNT, l1.LLC_BI__Amount__c);
      System.assertEquals(INTEREST_RATE, l1.LLC_BI__InterestRate__c);
      System.assertEquals(AMORTIZED_TERM, l1.LLC_BI__Amortized_Term_Months__c);

      System.assertNotEquals(null, p1.Id);
		System.assertEquals(l1.Id, p1.Loan__c);
      System.assertEquals(l1.LLC_BI__Amount__c, p1.Original_Amount__c);
      System.assertEquals(l1.LLC_BI__InterestRate__c, p1.Interest_Rate__c);
      System.assertEquals(l1.LLC_BI__Amortized_Term_Months__c, p1.Amortized_Term__c);
      System.assertEquals(l1.LLC_BI__Payment_Type__c, p1.Payment_Type__c);   
      System.assertEquals(l1.LLC_BI__Amount__c, p1.Payment_Amount__c);
      System.assertEquals(INTEREST_RATE_BASIS, p1.Interest_Rate_Basis__c);
      System.assertEquals(System.Today(), p1.Starting_Date__c); 
	}
	
	static testMethod void PrincipalPlusInterestTest() {
		LLC_BI__Loan__c l2 = new LLC_BI__Loan__c(
         Name = LOAN_NAME, 
         LLC_BI__Payment_Type__c = PRINCIPAL_PLUS_INTEREST,
         LLC_BI__Amount__c = AMOUNT,
         LLC_BI__InterestRate__c = INTEREST_RATE,
         LLC_BI__Amortized_Term_Months__c = AMORTIZED_TERM);
      insert l2;

      Payment_Option__c p2 = new Payment_Option__c(
      	Loan__c = l2.Id,
      	Original_Amount__c = l2.LLC_BI__Amount__c,
      	Interest_Rate__c = l2.LLC_BI__InterestRate__c,
         Amortized_Term__c = l2.LLC_BI__Amortized_Term_Months__c, 
         Payment_Type__c = l2.LLC_BI__Payment_Type__c,
         Payment_Amount__c = l2.LLC_BI__Amount__c,
         Interest_Rate_Basis__c = INTEREST_RATE_BASIS,
         Starting_Date__c = System.Today());
      insert p2;

      ApexPages.StandardController stdController = new ApexPages.StandardController(p2);    
      ApexPages.currentPage().getParameters().put('id', p2.Id);
      AmortizationScheduleController ctrl = new AmortizationScheduleController(stdController);

      System.assertNotEquals(null, l2.Id);  
      System.assertEquals(LOAN_NAME, l2.Name);
      System.assertEquals(PRINCIPAL_PLUS_INTEREST, l2.LLC_BI__Payment_Type__c);
      System.assertEquals(AMOUNT, l2.LLC_BI__Amount__c);
      System.assertEquals(INTEREST_RATE, l2.LLC_BI__InterestRate__c);
      System.assertEquals(AMORTIZED_TERM, l2.LLC_BI__Amortized_Term_Months__c);

      System.assertNotEquals(null, p2.Id);
		System.assertEquals(l2.Id, p2.Loan__c);
      System.assertEquals(l2.LLC_BI__Amount__c, p2.Original_Amount__c);
      System.assertEquals(l2.LLC_BI__InterestRate__c, p2.Interest_Rate__c);
      System.assertEquals(l2.LLC_BI__Amortized_Term_Months__c, p2.Amortized_Term__c);
      System.assertEquals(l2.LLC_BI__Payment_Type__c, p2.Payment_Type__c);   
      System.assertEquals(l2.LLC_BI__Amount__c, p2.Payment_Amount__c);
      System.assertEquals(INTEREST_RATE_BASIS, p2.Interest_Rate_Basis__c);
      System.assertEquals(System.Today(), p2.Starting_Date__c);
	}

	static testMethod void InterestOnlyTest() {
		LLC_BI__Loan__c l3 = new LLC_BI__Loan__c(
         Name = LOAN_NAME, 
         LLC_BI__Payment_Type__c = INTEREST_ONLY,
         LLC_BI__Amount__c = AMOUNT,
         LLC_BI__InterestRate__c = INTEREST_RATE,
         LLC_BI__Amortized_Term_Months__c = AMORTIZED_TERM);
      insert l3;

      Payment_Option__c p3 = new Payment_Option__c(
      	Loan__c = l3.Id,
      	Original_Amount__c = l3.LLC_BI__Amount__c,
      	Interest_Rate__c = l3.LLC_BI__InterestRate__c,
         Amortized_Term__c = l3.LLC_BI__Amortized_Term_Months__c, 
         Payment_Type__c = l3.LLC_BI__Payment_Type__c,
         Payment_Amount__c = l3.LLC_BI__Amount__c,
         Interest_Rate_Basis__c = INTEREST_RATE_BASIS,
         Starting_Date__c = System.Today());
      insert p3;

      ApexPages.StandardController stdController = new ApexPages.StandardController(p3);    
      ApexPages.currentPage().getParameters().put('id', p3.Id);
      AmortizationScheduleController ctrl = new AmortizationScheduleController(stdController);

      System.assertNotEquals(null, l3.Id);  
      System.assertEquals(LOAN_NAME, l3.Name);
      System.assertEquals(INTEREST_ONLY, l3.LLC_BI__Payment_Type__c);
      System.assertEquals(AMOUNT, l3.LLC_BI__Amount__c);
      System.assertEquals(INTEREST_RATE, l3.LLC_BI__InterestRate__c);
      System.assertEquals(AMORTIZED_TERM, l3.LLC_BI__Amortized_Term_Months__c);

      System.assertNotEquals(null, p3.Id);
		System.assertEquals(l3.Id, p3.Loan__c);
      System.assertEquals(l3.LLC_BI__Amount__c, p3.Original_Amount__c);
      System.assertEquals(l3.LLC_BI__InterestRate__c, p3.Interest_Rate__c);
      System.assertEquals(l3.LLC_BI__Amortized_Term_Months__c, p3.Amortized_Term__c);
      System.assertEquals(l3.LLC_BI__Payment_Type__c, p3.Payment_Type__c);   
      System.assertEquals(l3.LLC_BI__Amount__c, p3.Payment_Amount__c);   
      System.assertEquals(INTEREST_RATE_BASIS, p3.Interest_Rate_Basis__c);
      System.assertEquals(System.Today(), p3.Starting_Date__c);
	}

	private static final String LOAN_NAME = 'Test Loan';
   private static final String PRINCIPAL_AND_INTEREST = 'Principal+Interest';
   private static final String PRINCIPAL_PLUS_INTEREST = 'Principal&Interest';
   private static final String INTEREST_ONLY = 'Interest Only';
   private static final Decimal AMOUNT = 1000000;
   private static final Decimal INTEREST_RATE = 4.5;
   private static final Integer INTEREST_RATE_BASIS = 365;
   private static final Integer AMORTIZED_TERM = 360;
}