Trigger loan_CreateApprovalHistory on LLC_BI__Loan__c (before update) {

    Set<Id> loanIds = new Set<Id>();
    for (Integer i = 0 ; i < trigger.new.size(); i++) {
        if (trigger.isUpdate && trigger.new[i].Last_Approval_Status__c != null) {
            if ((trigger.new[i].Last_Approval_Status__c == 'Approved') || (trigger.new[i].Last_Approval_Status__c == 'Rejected') || (trigger.new[i].Last_Approval_Status__c == 'Removed')) {
                loanIds.add(trigger.new[i].Id);
            }
        }
        for (LLC_BI__Loan__c loan : trigger.new) {
            if (loan.Last_Approval_Status__c != null) {
                loan.Last_Approval_Status__c = '';
            }
        }
    }

    if (loanIds.size() > 0) {
        Map<Id,ProcessInstance> processMap = new Map<Id, ProcessInstance>([SELECT
            Id,
            CompletedDate,
            ElapsedTimeInDays,
            ElapsedTimeInHours,
            ElapsedTimeInMinutes,
            TargetObjectId,
            LastActor.Name,
            LastActorId,
            (SELECT
                Id,
                OriginalActor.Name,
                Comments,
                StepStatus
            FROM
                Steps
            WHERE
                StepStatus != 'Started'
            AND
                StepStatus != 'Submitted'
            ORDER BY
                CreatedDate Desc)
        FROM
            ProcessInstance
        WHERE
            TargetObjectId IN : loanIds
        AND
            ((Status != 'Started') AND (Status != 'Submitted'))]);

        for (ProcessInstance psi : processMap.values()) {
            for (ProcessInstanceStep ppt : psi.Steps) {
                Integer historyCounter = [SELECT COUNT() FROM Approval_History__c WHERE Loan__c =: psi.TargetObjectId AND ((Actual_Approver__c =: psi.LastActor.Name) AND (Date__c =: psi.CompletedDate) AND (Comments__c =: ppt.Comments) AND (Assigned_To__c =: ppt.OriginalActor.Name) AND (Status__c =: ppt.StepStatus))];
                if (historyCounter == 0) {
                    Approval_History__c a = new Approval_History__c();
                        a.Loan__c = psi.TargetObjectId;
                        a.Actual_Approver__c = psi.LastActor.Name;
                        a.Actual_Approver_Id__c = psi.LastActorId;
                        a.Date__c = psi.CompletedDate;
                        a.Elapsed_Days__c = psi.ElapsedTimeInDays;
                        a.Elapsed_Hours__c = psi.ElapsedTimeInHours;
                        a.Elapsed_Minutes__c = psi.ElapsedTimeInMinutes;
                        a.Comments__c = ppt.Comments;
                        a.Assigned_To__c = ppt.OriginalActor.Name;
                        a.Status__c = ppt.StepStatus;
                    insert a;
                }
            }
        }
    }
}