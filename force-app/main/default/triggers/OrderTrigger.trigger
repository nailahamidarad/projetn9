trigger OrderTrigger on Order (before insert, before update, after insert, after update) {
    
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        OrderTriggerHandler.updateNetAmount(Trigger.new);
    }

    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        OrderTriggerHandler.updateChiffreAffaire(Trigger.new);
    }
}
