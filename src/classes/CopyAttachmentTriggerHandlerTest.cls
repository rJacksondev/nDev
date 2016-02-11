@isTest
private class CopyAttachmentTriggerHandlerTest {

    private static void loanCreditMemo() {

        nDESIGN__Screen__c screen = new nDESIGN__Screen__c(
            Name = NAME);
        insert screen;
        System.assertNotEquals(null, screen.Id);
        System.assertEquals('Test', screen.Name);

        LLC_BI__Credit_Memo__c memo = new LLC_BI__Credit_Memo__c(
            Name = NAME,
            LLC_BI__Screen__c = screen.Id,
            LLC_BI__Is_Template__c = false);
        insert memo;
        System.assertNotEquals(null, memo.Id);
        System.assertEquals('Test', memo.Name);
        System.assertEquals(screen.Id, memo.LLC_BI__Screen__c);

        nDESIGN__Screen_Section__c section = new nDESIGN__Screen_Section__c(
            Name = NAME,
            nDESIGN__Screen__c = screen.Id,
            nDESIGN__Section_Resource__c = RESOURCE);
        insert section;
        System.assertNotEquals(null, section.Id);
        System.assertEquals('Test', section.Name);
        System.assertEquals(screen.Id, section.nDESIGN__Screen__c);
        System.assertEquals('MappedSObjectHierarchyScreenResource', section.nDESIGN__Section_Resource__c);

        Account account = new Account(
            Name = NAME);
        insert account;
        System.assertNotEquals(null, account.Id);
        System.assertEquals('Test', account.Name);

        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Name = NAME,
            LLC_BI__Account__c = account.Id,
            LLC_BI__Credit_Memo__c = memo.Id);
        insert loan;
        System.assertNotEquals(null, loan.Id);
        System.assertEquals('Test', loan.Name);
        System.assertEquals(account.Id, loan.LLC_BI__Account__c);
        System.assertEquals(memo.Id, loan.LLC_BI__Credit_Memo__c);

        List<Attachment> attachList = [SELECT
                Id,
                Body
            FROM
                Attachment LIMIT 1];

        Attachment attachment = new Attachment(
            Name = HTML,
            Body = attachList[0].Body,
            ParentId = section.Id);
        insert attachment;
        System.assertNotEquals(null, attachment.Id);
        System.assertEquals('Rendered_View.html', attachment.Name);
        System.assertEquals(section.Id, attachment.ParentId);

        Test.startTest();
            CopyAttachmentTriggerHandler.updateFields(attachment.Id);
        Test.stopTest();
    }

    private static final String NAME = 'Test';
    private static final String HTML = 'Rendered_View.html';
    private static final String RESOURCE = 'MappedSObjectHierarchyScreenResource';
    private static final Blob BODY_BLOB;
}