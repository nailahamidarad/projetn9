public with sharing class OrderTriggerHandler {

    public static void updateChiffreAffaire(List<Order> newOrders) {
        System.debug('=== [updateChiffreAffaire] Début ===');
        System.debug('Orders reçues : ' + newOrders.size());
        System.debug('SOQL avant : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML avant : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('Heap avant : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        System.debug('CPU avant : ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());

        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();

        for (Order o : newOrders) {
            if (o.AccountId != null && o.TotalAmount != null) {
                if (!accountRevenueMap.containsKey(o.AccountId)) {
                    accountRevenueMap.put(o.AccountId, 0);
                }
                accountRevenueMap.put(o.AccountId, accountRevenueMap.get(o.AccountId) + o.TotalAmount);
            }
        }

        if (!accountRevenueMap.isEmpty()) {
            List<Account> accountsToUpdate = [
                SELECT Id, Chiffre_d_Affaire__c
                FROM Account
                WHERE Id IN :accountRevenueMap.keySet()
            ];

            for (Account acc : accountsToUpdate) {
                Decimal newRevenue = accountRevenueMap.get(acc.Id);
                acc.Chiffre_d_Affaire__c = newRevenue;
            }

            update accountsToUpdate;
        }

        System.debug('SOQL après : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML après : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('Heap après : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        System.debug('CPU après : ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        System.debug('=== [updateChiffreAffaire] Fin ===');
    }

    public static void updateNetAmount(List<Order> newOrders) {
        System.debug('=== [updateNetAmount] Début ===');
        System.debug('Orders reçues : ' + newOrders.size());
        System.debug('SOQL avant : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML avant : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('Heap avant : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        System.debug('CPU avant : ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());

        List<Order> ordersToUpdate = new List<Order>();

        for (Order order : newOrders) {
            if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
                ordersToUpdate.add(order);
            }
        }

        System.debug('SOQL après : ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML après : ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('Heap après : ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        System.debug('CPU après : ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        System.debug('=== [updateNetAmount] Fin ===');
    }
}
