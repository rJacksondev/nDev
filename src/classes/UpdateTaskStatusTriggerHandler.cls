public with sharing class UpdateTaskStatusTriggerHandler {

    public static void updateStatus(Id document) {

        Set<Id> loanDocIds = new Set<Id>();
        List<LLC_BI__LLC_LoanDocument__c> loanDocList = [SELECT
                Id,
                LLC_BI__reviewStatus__c
        FROM
                LLC_BI__LLC_LoanDocument__c
        WHERE
                Id =: document];

        for (LLC_BI__LLC_LoanDocument__c d : loanDocList) {
            loanDocIds.add(d.Id);
        }

        List<Task> taskList = [SELECT
                Id,
                Status
        FROM
                Task
        WHERE
                WhatId IN : loanDocIds];

        for (Task t : taskList) {
            if (t.Status != 'Completed') {
                t.Status = 'Completed';
            }
        }

        Database.update(taskList);
    }
}