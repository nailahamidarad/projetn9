public with sharing class ScheduleUpdateAccountsBatch implements Schedulable {

    public void execute(SchedulableContext SC) {
        UpdateAllAccountsBatch batch = new UpdateAllAccountsBatch();

        Database.executeBatch(batch, 200);
    }
}

