@isTest
public class PaymentCalculatorControllerTest {
    static testMethod void PrincipalAndInterestTest() {

        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c(
            Name = LOAN_NAME, 
            LLC_BI__Payment_Type__c = PRINCIPAL_INTEREST,
            LLC_BI__Amount__c = AMOUNT,
            LLC_BI__InterestRate__c = INTEREST_RATE,
            LLC_BI__Amortized_Term_Months__c = AMORTIZED_TERM);
        insert loan1;

        ApexPages.StandardController stdController = new ApexPages.StandardController(loan1);    
        ApexPages.currentPage().getParameters().put('id', loan1.Id);
        PaymentCalculatorController ctrl = new PaymentCalculatorController(stdController);
        PageReference pageRef = ctrl.Calculate();
        
        System.assertEquals(LOAN_NAME, loan1.Name);
        System.assertEquals(PRINCIPAL_INTEREST, loan1.LLC_BI__Payment_Type__c);
        System.assertEquals(AMOUNT, loan1.LLC_BI__Amount__c);
        System.assertEquals(INTEREST_RATE, loan1.LLC_BI__InterestRate__c);
        System.assertEquals(AMORTIZED_TERM, loan1.LLC_BI__Amortized_Term_Months__c);
    }

    static testMethod void InterestOnlyTest() {

        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c(
            Name = LOAN_NAME, 
            LLC_BI__Payment_Type__c = INTEREST_ONLY,
            LLC_BI__Amount__c = AMOUNT,
            LLC_BI__InterestRate__c = INTEREST_RATE,
            LLC_BI__Amortized_Term_Months__c = AMORTIZED_TERM);
        insert loan2;

        ApexPages.StandardController stdController = new ApexPages.StandardController(loan2);    
        ApexPages.currentPage().getParameters().put('id', loan2.Id);
        PaymentCalculatorController ctrl = new PaymentCalculatorController(stdController);
        PageReference pageRef = ctrl.Calculate();

        System.assertEquals(LOAN_NAME, loan2.Name);
        System.assertEquals(INTEREST_ONLY, loan2.LLC_BI__Payment_Type__c);
        System.assertEquals(AMOUNT, loan2.LLC_BI__Amount__c);
        System.assertEquals(INTEREST_RATE, loan2.LLC_BI__InterestRate__c);
        System.assertEquals(AMORTIZED_TERM, loan2.LLC_BI__Amortized_Term_Months__c);
    }

    private static final String LOAN_NAME = 'Test Loan';
    private static final String PRINCIPAL_INTEREST = 'Principal+Interest';
    private static final String INTEREST_ONLY = 'Interest Only';
    private static final Decimal AMOUNT = 1000000;
    private static final Decimal INTEREST_RATE = 4.5;
    private static final Integer AMORTIZED_TERM = 360;
}