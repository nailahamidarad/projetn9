public with sharing class OrderTriggerHandler {

    public static void updateChiffreAffaire(List<Order> newOrders) {
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
                // Calcul du chiffre d'affaire total en tenant compte de l'existant test
                //Decimal currentRevenue = acc.Chiffre_d_Affaire__c != null ? acc.Chiffre_d_Affaire__c : 0;
                Decimal newRevenue = accountRevenueMap.get(acc.Id);
                acc.Chiffre_d_Affaire__c = newRevenue;

                // Ajout du montant dans la map des comptes à mettre à jour
            }

            update accountsToUpdate;
        }
    }

    public static void updateNetAmount(List<Order> newOrders) {
        List<Order> ordersToUpdate = new List<Order>();

        for (Order order : newOrders) {
            if (order.TotalAmount != null && order.ShipmentCost__c != null) {
                order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
                ordersToUpdate.add(order);
            }
    }
}
}