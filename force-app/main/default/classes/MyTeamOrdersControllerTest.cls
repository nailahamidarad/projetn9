@isTest
private class MyTeamOrdersControllerTest {

    @isTest
    static void testGetSumOrdersByAccount_ValidAccount() {
        Account acc = TestDataFactory.createTestAccount();
        Pricebook2 standardPricebook = TestDataFactory.createTestPricebook();

        Product2 product1 = TestDataFactory.createTestProduct();
        Product2 product2 = TestDataFactory.createTestProduct();

        PricebookEntry pbe1 = TestDataFactory.createTestPricebookEntry(standardPricebook.Id, product1.Id);
        PricebookEntry pbe2 = TestDataFactory.createTestPricebookEntry(standardPricebook.Id, product2.Id);

        Order order1 = new Order(
            AccountId = acc.Id,
            Pricebook2Id = standardPricebook.Id,
            Status = 'Draft',
            EffectiveDate = System.today(),
            ShipmentCost__c = 0
        );
        insert order1;

        OrderItem orderItem1 = new OrderItem(
            OrderId = order1.Id,
            PricebookEntryId = pbe1.Id,
            Quantity = 1,
            UnitPrice = 1000
        );

        OrderItem orderItem2 = new OrderItem(
            OrderId = order1.Id,
            PricebookEntryId = pbe2.Id,
            Quantity = 1,
            UnitPrice = 500
        );
        insert new List<OrderItem>{ orderItem1, orderItem2 };

        order1.Status = 'Activated';
        update order1;

        Test.startTest();
        Decimal sum = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(1500, sum); 
    }

    @isTest
    static void testGetSumOrdersByAccount_NoActivatedOrders() {
        Account acc = TestDataFactory.createTestAccount();
        Product2 product1 = TestDataFactory.createTestProduct();
        Pricebook2 pricebook = TestDataFactory.createTestPricebook();
        PricebookEntry pbe1 = TestDataFactory.createTestPricebookEntry(pricebook.Id, product1.Id);

        Order order1 = new Order(
            AccountId = acc.Id,
            Pricebook2Id = pricebook.Id,
            Status = 'Draft',
            EffectiveDate = System.today(),
            ShipmentCost__c = 0
        );
        insert order1;

        OrderItem orderItem1 = new OrderItem(
            OrderId = order1.Id,
            PricebookEntryId = pbe1.Id,
            Quantity = 1,
            UnitPrice = 500
        );
        insert orderItem1;

        Test.startTest();
        Decimal sum = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(0, sum); // Non activé
    }

    @isTest
    static void testGetSumOrdersByAccount_AccountWithoutOrders() {
        Account acc = TestDataFactory.createTestAccount();

        Test.startTest();
        Decimal sum = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(0, sum);
    }
}
