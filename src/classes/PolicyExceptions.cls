public class PolicyExceptions {

    public String loanName       { get; set; }
    public String entityId       { get; set; }
    public String newEntity      { get; set; }
    public String factors        { get; set; }
    public Id objId = ApexPages.currentPage().getParameters().get('id');
    List<policyWrapper> peList = new List<policyWrapper>();
    List<policyWrapper> selectedExceptions = new List<policyWrapper>();

    public class policyWrapper {
        public String mFactor                       { get; set; }
        public Boolean selected                     { get; set; }
        public String selectedEntity                { get; set; }
        public String selectedFactor                { get; set; }
        public String mitigantComments              { get; set; }
        public Policy_Exception__c polException     { get; set; }
        public List<SelectOption> mitigatingFactors { get; set; }
        public List<SelectOption> availableEntities { get; set; }

        public policyWrapper(Policy_Exception__c pe, List<SelectOption> mitigationList, List<SelectOption> entityList) {
            polException = pe;
            mitigatingFactors = mitigationList;
            availableEntities = entityList;
            selectedFactor = null;
            selectedEntity = null;
            selected = false;
            mFactor = null;
            mitigantComments = null;
        }
    }

    public String getProfileName() {
        User u = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId()];
        return u.Name;
    }
    
    public String getCurrentLoanId() {
        return objId;
    }

    public String getCurrentLoanName() {
        LLC_BI__Loan__c l = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE Id =: objId];
        return l.Name;
    }

    public List<SelectOption> getEntities() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('001d000000VvCog', 'None'));

        List<LLC_BI__Legal_Entities__c> entities = [SELECT Id, LLC_BI__Account__c, LLC_BI__Account__r.Name, LLC_BI__Loan__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: objId];
        for (LLC_BI__Legal_Entities__c ent : entities) {
            options.add(new SelectOption(ent.LLC_BI__Account__c, ent.LLC_BI__Account__r.Name));
        }
        return options;
    }
    
    public List<Policy_Exception__c> getExistingPolicies() {
        List<Policy_Exception__c> loanPolicies = [select Account__r.Name, Description__c, Mitigating_Factors__c, Mitigation_Comments__c from Policy_Exception__c where Loan__c =: objId and Original_Policy_Exception__c != null];
        
        if(loanPolicies != null && loanPolicies.size() > 0) {
            return loanPolicies;
        } else {
            return null;
        }
    }
    
    public List<policyWrapper> getPolicyExceptions() {
        peList.clear();
        LLC_BI__Loan__c loan = [SELECT LLC_BI__Product_Reference__c, LLC_BI__Product_Reference__r.LLC_BI__Product_Type__c, LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__c FROM LLC_BI__Loan__c WHERE Id =: objId];

        //Filter out Policy Exceptions that have already been added based on their parent template
        List<Policy_Exception__c> loanPolicies = [select Id, Original_Policy_Exception__c from Policy_Exception__c where Loan__c =: objId and Original_Policy_Exception__c != null];
        
        List<Id> existingPolicies = new List<Id>();
        for(Policy_Exception__c existing : loanPolicies) {
            existingPolicies.add(existing.Original_Policy_Exception__c);
        }
        
        //Grab our relationships through entity involvement so we can list them properly
        List<SelectOption> entityList = new List<SelectOption>();
        entityList.add(new SelectOption('', 'None'));
        
        for(LLC_BI__Legal_Entities__c e : [SELECT LLC_BI__Account__r.Name, LLC_BI__Account__r.Type, LLC_BI__Account__r.Id FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: objId]) {
            entityList.add(new SelectOption(e.LLC_BI__Account__c, e.LLC_BI__Account__r.Name));
        }
        
        List<Policy_Exception__c> pList = [
                                            SELECT 
                                                Id, 
                                                Template__c, 
                                                Description__c, 
                                                Require_Mitigating_Comments__c, 
                                                Mitigation_Comments__c, 
                                                Mitigating_Factors__c 
                                            FROM 
                                                Policy_Exception__c pel 
                                            WHERE 
                                                Template__c = true
                                            AND 
                                                Ended__c = false
                                            AND 
                                                ((Product_Line__c =: null AND Product_Type__c = null AND Product__c = null) 
                                                OR (Product_Line__c =: loan.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__c) 
                                                OR (Product_Type__c =: loan.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__c) 
                                                OR (Product__c =: loan.LLC_BI__Product_Reference__c))
                                            AND 
                                                Id NOT IN: existingPolicies 
                                          ];
        
        for(Policy_Exception__c p : pList) {
            List<SelectOption> mitigatingFactors = new List<SelectOption>();
            mitigatingFactors.add(new SelectOption('None', 'None'));
            
            for(Exception_Mitigations__c eM : [SELECT Description__c FROM Exception_Mitigations__c WHERE Policy_Exception__c =: p.Id AND Ended__c = false]) {
                mitigatingFactors.add(new SelectOption(eM.Description__c, eM.Description__c));
            }
            peList.add(new policyWrapper(p, mitigatingFactors, entityList));
        }
        
        return peList;
    }
    
    public PageReference getSelected() {
        selectedExceptions.clear();
        
        for(policyWrapper pewrapper : peList) {
            if(pewrapper.selected == true) {
                selectedExceptions.add(pewrapper);
            }
        }
        return null;
    }
    
    public List<policyWrapper> GetSelectedPolicyExceptions() {
        if(selectedExceptions.size() > 0) {
            return selectedExceptions;
        } else {
            return null;
        }
    }
    
    public PageReference createExceptions() {
        PageReference returnPage = new PageReference('/' + objId);

        if(selectedExceptions.size() > 0) {
            for(policyWrapper pWrap : selectedExceptions) {
               if(pWrap.polException.Template__c == true) {
                    Policy_Exception__c nPE = new Policy_Exception__c();
                    nPE.Description__c = pWrap.polException.Description__c;
                    nPE.Exception_Date__c = Date.Today();
                    nPE.Loan__c = objId;
                    nPE.Original_Policy_Exception__c = pWrap.polException.Id;
                    nPE.Mitigation_Comments__c = pWrap.mitigantComments;
                    nPE.Require_Mitigating_Comments__c = pWrap.polException.Require_Mitigating_Comments__c;
                    
                    if(pWrap.selectedEntity != null) {
                        nPE.Account__c = pWrap.selectedEntity;
                    }
                   
                    if(pWrap.selectedFactor != 'None') {
                        nPE.Mitigating_Factors__c = pWrap.selectedFactor;
                    }
                   
                    if(pWrap.polException.Require_Mitigating_Comments__c == true && pWrap.selectedEntity != 'None' && pWrap.mitigantComments.length() == 0) {
                        system.debug('*** Required: ' + pWrap.polException.Require_Mitigating_Comments__c);
                        system.debug('*** Entity Selected: ' + pWrap.selectedEntity);
                        system.debug('*** Comment Length: ' + pWrap.mitigantComments.length());
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Policy Exception "' + pWrap.polException.Description__c + '" requires mitigating comments if a factor is provided.'));
                        return new PageReference('/apex/NewPolicyExceptionPage?id=' + objId);
                    }
                   
                    insert nPE;
                }
            }
            
            return returnPage;
        } else {
            return returnPage;
        }
    }
}