public with sharing class CallYahooQuotesImageController {

    public String imageURL {get;set;}

    public CallYahooQuotesImageController(ApexPages.StandardController controller) {
    
        Id objId = ApexPages.currentPage().getParameters().get('id');
        system.debug('*** objId: ' + objId);
        
        Holding__c h = [SELECT Id, Ticker_Symbol__c FROM Holding__c WHERE Id =: objId];
        system.debug('*** h: ' + h.Id);
        imageURL = 'http://chart.finance.yahoo.com/z?s='+h.Ticker_Symbol__c+'&t=6m&p=m50,m200';
        system.debug('*** imageURL: ' + imageURL);

    }
}