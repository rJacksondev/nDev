@isTest
public with sharing class CreditMemoDeleterControllerTest {

   static testMethod void testDeleter() {

      nDESIGN__Screen__c screen = new nDESIGN__Screen__c();
      insert screen;

      System.assertNotEquals(screen.Id, null);

      LLC_BI__Credit_Memo__c memo = new LLC_BI__Credit_Memo__c(
              LLC_BI__Screen__c = screen.Id);
      insert memo;

      System.assertNotEquals(memo.Id, null);
      System.assertEquals(memo.LLC_BI__Screen__c, screen.Id);

      nDESIGN__View__c view = new nDESIGN__View__c();
      insert view;

      System.assertNotEquals(view.Id, null);

      nDESIGN__Screen_Section__c section = new nDESIGN__Screen_Section__c(
              nDESIGN__Screen__c = screen.Id,
              nDESIGN__Screen_View__c = view.Id,
              nDESIGN__Section_Resource__c = RESOURCE);
      insert section;

      System.assertNotEquals(section.Id, null);
      System.assertEquals(section.nDESIGN__Screen__c, screen.Id);
      System.assertEquals(section.nDESIGN__Screen_View__c, view.Id);
      System.assertEquals(section.nDESIGN__Section_Resource__c, 'MappedSObjectHierarchyScreenResource');

      nDESIGN__Section_Configuration__c sectionConfig = new nDESIGN__Section_Configuration__c(
              nDESIGN__Screen_Section__c = section.Id,
              nDESIGN__lookupKey__c = KEY,
              nDESIGN__sObject_Type__c = TYPE);
      insert sectionConfig;

      System.assertNotEquals(sectionConfig.Id, null);
      System.assertEquals(sectionConfig.nDESIGN__Screen_Section__c, section.Id);
      System.assertEquals(sectionConfig.nDESIGN__lookupKey__c, '43982012318901');
      System.assertEquals(sectionConfig.nDESIGN__sObject_Type__c, 'LLC_BI__Loan__c');

      Test.startTest();

      CreditMemoDeleterController cntrl = new CreditMemoDeleterController();

      Test.stopTest();
   }

   private static final String RESOURCE = 'MappedSObjectHierarchyScreenResource';
   private static final String KEY = '43982012318901';
   private static final String TYPE = 'LLC_BI__Loan__c';
}