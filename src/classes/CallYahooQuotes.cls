global class CallYahooQuotes {

   webservice static void getQuotes(Id collateral) {
      
      List<Holding__c> holdingsList = [SELECT 
            Id, 
            Ticker_Symbol__c, 
            Stock_Price__c 
         FROM 
            Holding__c 
         WHERE 
            Collateral__c =: collateral];

      for (Holding__c hold : holdingsList) {

         String url = 'http://download.finance.yahoo.com/d/quotes.csv?s='+hold.Ticker_Symbol__c+'&f=l1&e=.csv';

         Http h = new Http();  
         HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setMethod('GET');
         HttpResponse res = h.send(req);

         hold.Stock_Price__c = decimal.valueOf(res.getBody().trim());

         if (hold.Yahoo_Finance_Link__c == null) {
            hold.Yahoo_Finance_Link__c = 'http://finance.yahoo.com/q?s='+hold.Ticker_Symbol__c;
         }
      }

      update holdingsList;

      LLC_BI__Collateral__c col = [SELECT
            Id,
            LLC_BI__Value__c,
            Total_Holdings_Value__c
         FROM
            LLC_BI__Collateral__c
         WHERE
             Id =: collateral];

      col.LLC_BI__Value__c = col.Total_Holdings_Value__c;
      update col;

      List<LLC_BI__Loan_Collateral2__c> collateralList = [SELECT 
            Id,
            LLC_BI__Collateral__c,
            LLC_BI__Collateral_Value__c 
         FROM 
            LLC_BI__Loan_Collateral2__c 
         WHERE 
            LLC_BI__Collateral__c =: col.Id];

      for (LLC_BI__Loan_Collateral2__c c : collateralList) {
         c.LLC_BI__Collateral_Value__c = col.Total_Holdings_Value__c;
      }

      update collateralList;
   }
}