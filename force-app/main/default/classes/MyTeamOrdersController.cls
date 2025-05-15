public without sharing class MyTeamOrdersController {

    @AuraEnabled
    public static Decimal getSumOrdersByAccount(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('L\'ID du compte ne peut pas être nul.');
        }

        AggregateResult groupedResults = [
            SELECT SUM(TotalAmount) total 
            FROM Order 
            WHERE Status = 'Activated' AND AccountId = :accountId
        ];

        return (Decimal)(groupedResults.get('total') != null ? groupedResults.get('total') : 0);
    }
}
