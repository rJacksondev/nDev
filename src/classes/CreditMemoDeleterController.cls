public with sharing class CreditMemoDeleterController {

   public static void deleteCreditMemos() {

      Set<Id> loanIds = new Set<Id>();
      List<LLC_BI__Loan__c> loanList = [SELECT
            Id,
            LLC_BI__Credit_Memo__c
         FROM
            LLC_BI__Loan__c
         WHERE
            LLC_BI__Credit_Memo__c != null];

      for (LLC_BI__Loan__c l : loanList) {
         loanIds.add(l.LLC_BI__Credit_Memo__c);
      }

      Set<Id> packageIds = new Set<Id>();
      List<LLC_BI__Product_Package__c> packageList = [SELECT
            Id,
            LLC_BI__Credit_Memo__c
         FROM
            LLC_BI__Product_Package__c
         WHERE
            LLC_BI__Credit_Memo__c != null];
      for (LLC_BI__Product_Package__c p : packageList) {
         packageIds.add(p.LLC_BI__Credit_Memo__c);
      }

      Set<Id> screenIds = new Set<Id>();
      List<LLC_BI__Credit_Memo__c> memoList = [SELECT
            Id,
            LLC_BI__Screen__c
         FROM
            LLC_BI__Credit_Memo__c
         WHERE
            LLC_BI__Is_Template__c = false
         AND
            ((Id NOT IN : loanIds) AND (Id NOT IN : packageIds))];

      for (LLC_BI__Credit_Memo__c c : memoList) {
         screenIds.add(c.LLC_BI__Screen__c);
      }

      List<nDESIGN__Screen__c> screenList = [SELECT
            Id
         FROM
            nDESIGN__Screen__c
         WHERE
            Id IN : screenIds];

      Set<Id> viewIds = new Set<Id>();
      Set<Id> widgetIds = new Set<Id>();
      Set<Id> sectionLayoutIds = new Set<Id>();
      List<nDESIGN__Screen_Section__c> sectionList = [SELECT
            Id,
            nDESIGN__Screen_View__c,
            nDESIGN__Widget__c,
            nDESIGN__Layout__c
         FROM
            nDESIGN__Screen_Section__c
         WHERE
            nDESIGN__Screen__c IN : screenList];
      for (nDESIGN__Screen_Section__c s : sectionList) {
         viewIds.add(s.nDESIGN__Screen_View__c);
         widgetIds.add(s.nDESIGN__Widget__c);
         sectionLayoutIds.add(s.nDESIGN__Layout__c);
         s.nDESIGN__Widget__c = null;
         s.nDESIGN__Screen_View__c = null;
      }

      Set<Id> sectionConfigLayoutIds = new Set<Id>();
      List<nDESIGN__Section_Configuration__c> sectionConfigList = [SELECT
            Id,
            nDESIGN__Layout__c
         FROM
            nDESIGN__Section_Configuration__c
         WHERE
            nDESIGN__Screen_Section__c IN : sectionList];
      for (nDESIGN__Section_Configuration__c sc : sectionConfigList) {
         sectionConfigLayoutIds.add(sc.nDESIGN__Layout__c);
      }

      List<Attachment> attachmentList = [SELECT
            Id
         FROM
            Attachment
         WHERE
            ParentId IN : sectionList];

      List<nDESIGN__View__c> viewList = [SELECT
            Id
         FROM
            nDESIGN__View__c
         WHERE
            Id IN : viewIds];

      List<nDESIGN__Widget__c> widgetList = [SELECT
            Id
         FROM
            nDESIGN__Widget__c
         WHERE
            Id IN : widgetIds];

      List<nDESIGN__Layout__c> sectionLayoutList = [SELECT
            Id
         FROM
            nDESIGN__Layout__c
         WHERE
            Id IN : sectionLayoutIds];

      List<nDESIGN__Layout__c> sectionConfigLayoutList = [SELECT
            Id
         FROM
            nDESIGN__Layout__c
         WHERE
            Id IN : sectionConfigLayoutIds];
    
      if (memoList.size() > 0) {
         try {
            update sectionList;
            delete sectionConfigLayoutList;
            delete sectionLayoutList;
            delete widgetList;
            delete viewList;
            delete attachmentList;
            delete sectionConfigList;
            delete sectionList;
            delete memoList;
            delete screenList;
         } catch (DmlException e) {
            System.debug('Something broke: ' + e.getMessage());
         }
      }
   }
}