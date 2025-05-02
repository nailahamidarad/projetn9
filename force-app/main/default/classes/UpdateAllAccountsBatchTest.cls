@isTest
private class UpdateAllAccountsBatchTest {

    @isTest
    static void testBatchExecution() {

        Account acc1 = TestDataFactory.createTestAccount();
        Account acc2 = TestDataFactory.createTestAccount();

        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        Product2 product1 = TestDataFactory.createTestProduct();
        Product2 product2 = TestDataFactory.createTestProduct();
        PricebookEntry pbe1 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product1.Id);
        PricebookEntry pbe2 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product2.Id);

        Order order1 = new Order(AccountId = acc1.Id, Status = 'Draft', EffectiveDate = System.today(),Pricebook2Id = pricebook.Id);
        Order order2 = new Order(AccountId = acc1.Id, Status = 'Draft', EffectiveDate = System.today(),Pricebook2Id = pricebook.Id);
        Order order3 = new Order(AccountId = acc2.Id, Status = 'Draft', EffectiveDate = System.today(),Pricebook2Id = pricebook.Id);

        insert new List<Order>{ order1, order2, order3 };

        OrderItem orderItem1 = new OrderItem(OrderId = order1.Id, Product2Id = product1.Id, Quantity = 1, UnitPrice = 1000, PricebookEntryId = pbe1.Id);
        OrderItem orderItem2 = new OrderItem(OrderId = order1.Id, Product2Id = product2.Id, Quantity = 1, UnitPrice = 500, PricebookEntryId = pbe2.Id);
        OrderItem orderItem3 = new OrderItem(OrderId = order2.Id, Product2Id = product1.Id, Quantity = 2, UnitPrice = 500, PricebookEntryId = pbe1.Id);
        OrderItem orderItem4 = new OrderItem(OrderId = order3.Id, Product2Id = product2.Id, Quantity = 2, UnitPrice = 1000, PricebookEntryId = pbe2.Id);

        insert new List<OrderItem>{ orderItem1, orderItem2, orderItem3, orderItem4 };

        order1.Status = 'Activated';
        order2.Status = 'Activated';
        order3.Status = 'Activated';
        update new List<Order>{ order1, order2, order3 };

        acc1 = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc1.Id];
        acc2 = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc2.Id];

        acc1.Chiffre_d_Affaire__c=0;
        acc2.Chiffre_d_Affaire__c=0;
        update new List <Account>{ acc1, acc2 };

        System.assertEquals(0, acc1.Chiffre_d_Affaire__c);
        System.assertEquals(0, acc2.Chiffre_d_Affaire__c);

        Test.startTest();
        Database.executeBatch(new UpdateAllAccountsBatch(), 200);
        Test.stopTest();

        acc1 = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc1.Id];
        acc2 = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc2.Id];

        System.assertEquals(2500, acc1.Chiffre_d_Affaire__c);  
        System.assertEquals(2000, acc2.Chiffre_d_Affaire__c);  
    }

    @isTest
    static void testNoActivatedOrders() {
        Account acc = TestDataFactory.createTestAccount();

        acc = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, acc.Chiffre_d_Affaire__c);

        Test.startTest();
        Database.executeBatch(new UpdateAllAccountsBatch(), 200);
        Test.stopTest();

        acc = [SELECT Id, Chiffre_d_Affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, acc.Chiffre_d_Affaire__c);
    }

    @isTest
    static void testEmptyAccountList() {
        Test.startTest();
        Database.executeBatch(new UpdateAllAccountsBatch(), 200);
        Test.stopTest();

    }
}
