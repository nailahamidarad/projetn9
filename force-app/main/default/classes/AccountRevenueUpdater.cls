public with sharing class AccountRevenueUpdater {

    public static void updateChiffreAffaire(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) return;

        // Début du traçage
        System.debug('--- Début updateChiffreAffaire ---');
        System.debug('Avant SOQL - Queries utilisées : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('Heap Size avant SOQL : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize() + ' octets');

        AggregateResult[] results = [
            SELECT AccountId, SUM(TotalAmount) total
            FROM Order
            WHERE Status = 'Activated' AND AccountId IN :accountIds
            GROUP BY AccountId
        ];

        System.debug('Après SOQL - Queries utilisées : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('Heap Size après SOQL : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());

        Map<Id, Decimal> accountToTotalMap = new Map<Id, Decimal>();
        for (AggregateResult ar : results) {
            accountToTotalMap.put((Id) ar.get('AccountId'), (Decimal) ar.get('total'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountToTotalMap.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accId,
                Chiffre_d_Affaire__c = accountToTotalMap.get(accId)
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            System.debug('Avant DML - DML utilisés : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
            update accountsToUpdate;
            System.debug('Après DML - DML utilisés : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        }

        System.debug('CPU Time utilisé : ' + Limits.getCpuTime() + ' ms / ' + Limits.getLimitCpuTime() + ' ms');
        System.debug('--- Fin updateChiffreAffaire ---');
    }
}
