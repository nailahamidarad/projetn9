@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testUpdateChiffreAffaire() {
        Account acc = TestDataFactory.createTestAccount();
        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        Product2 product1 = TestDataFactory.createTestProduct();
        Product2 product2 = TestDataFactory.createTestProduct();
        PricebookEntry pbe1 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product1.Id);
        PricebookEntry pbe2 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product2.Id);

        Order order = new Order(AccountId = acc.Id, Status = 'Draft', Pricebook2Id = pricebook.Id, EffectiveDate = System.today(), ShipmentCost__c = 0);
        insert order;

        OrderItem item1 = new OrderItem(OrderId = order.Id, PricebookEntryId = pbe1.Id, Quantity = 1, UnitPrice = 1000);
        OrderItem item2 = new OrderItem(OrderId = order.Id, PricebookEntryId = pbe2.Id, Quantity = 2, UnitPrice = 500);
        insert new List<OrderItem>{ item1, item2 };

        order.Status = 'Activated';
        update order;

        acc = [SELECT Chiffre_d_Affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2000, acc.Chiffre_d_Affaire__c); 
    }

    @isTest
    static void testUpdateNetAmount() {
        Account acc = TestDataFactory.createTestAccount();
        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pbe = TestDataFactory.createTestPricebookEntry(pricebook.Id, product.Id);

        Order order = new Order(ShipmentCost__c = 0, AccountId = acc.Id, Status = 'Draft', Pricebook2Id = pricebook.Id, EffectiveDate = System.today());
        insert order;

        OrderItem item = new OrderItem(OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity = 2, UnitPrice = 1000);
        insert item;

        order.Status = 'Activated';
        order.ShipmentCost__c = 100;
        update order;

        order = [SELECT NetAmount__c FROM Order WHERE Id = :order.Id];
        System.assertEquals(1900, order.NetAmount__c);  
    }

    @isTest
    static void testUpdateChiffreAffaire_WithMultipleAccounts() {
        Account acc1 = TestDataFactory.createTestAccount();
        Account acc2 = TestDataFactory.createTestAccount();
        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        Product2 product1 = TestDataFactory.createTestProduct();
        Product2 product2 = TestDataFactory.createTestProduct();
        PricebookEntry pbe1 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product1.Id);
        PricebookEntry pbe2 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product2.Id);

        Order order1 = new Order(AccountId = acc1.Id, Status = 'Draft', Pricebook2Id = pricebook.Id, EffectiveDate = System.today(), ShipmentCost__c = 0);
        Order order2 = new Order(AccountId = acc2.Id, Status = 'Draft', Pricebook2Id = pricebook.Id, EffectiveDate = System.today(), ShipmentCost__c = 0);
        insert new List<Order>{ order1, order2 };

        insert new List<OrderItem> {
            new OrderItem(OrderId = order1.Id, PricebookEntryId = pbe1.Id, Quantity = 1, UnitPrice = 1000),
            new OrderItem(OrderId = order1.Id, PricebookEntryId = pbe2.Id, Quantity = 2, UnitPrice = 500),
            new OrderItem(OrderId = order2.Id, PricebookEntryId = pbe1.Id, Quantity = 3, UnitPrice = 1500),
            new OrderItem(OrderId = order2.Id, PricebookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 2000)
        };

        order1.Status = 'Activated';
        order2.Status = 'Activated';
        update new List<Order>{ order1, order2 };

        acc1 = [SELECT Chiffre_d_Affaire__c FROM Account WHERE Id = :acc1.Id];
        acc2 = [SELECT Chiffre_d_Affaire__c FROM Account WHERE Id = :acc2.Id];

        System.assertEquals(2000, acc1.Chiffre_d_Affaire__c);  // 1000 + (2 * 500)
        System.assertEquals(6500, acc2.Chiffre_d_Affaire__c);  // (3 * 1500) + 2000
    }

    @isTest
    static void testUpdateNetAmount_WithNoShipmentCost() {
        Account acc = TestDataFactory.createTestAccount();
        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pbe = TestDataFactory.createTestPricebookEntry(pricebook.Id, product.Id);

        Order order = new Order(AccountId = acc.Id, Status = 'Draft', Pricebook2Id = pricebook.Id, EffectiveDate = System.today(), ShipmentCost__c = 0);
        insert order;

        insert new OrderItem(OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 1000);

        order.Status = 'Activated';
        update order;

        order = [SELECT NetAmount__c FROM Order WHERE Id = :order.Id];
        System.assertEquals(1000, order.NetAmount__c);  // 1000 - 0 (aucun frais de livraison)
    }
}
