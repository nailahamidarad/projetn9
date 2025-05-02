public with sharing class AccountRevenueUpdater {

    public static void updateChiffreAffaire(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) return;

        AggregateResult[] results = [
            SELECT AccountId, SUM(TotalAmount) total
            FROM Order
            WHERE Status = 'Activated' AND AccountId IN :accountIds
            GROUP BY AccountId
        ];

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
            update accountsToUpdate;
        }
    }
}
