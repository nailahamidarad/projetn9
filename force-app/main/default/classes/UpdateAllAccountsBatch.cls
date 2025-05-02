global class UpdateAllAccountsBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext info) {
        String query = 'SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Activated\')';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        Set<Id> accountIds = new Map<Id, Account>(scope).keySet();
        AccountRevenueUpdater.updateChiffreAffaire(accountIds);
    }

    global void finish(Database.BatchableContext info) {
        System.debug('Batch terminé.');
    }
}
