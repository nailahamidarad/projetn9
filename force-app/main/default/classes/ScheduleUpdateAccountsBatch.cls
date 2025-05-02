public with sharing class ScheduleUpdateAccountsBatch {

    public void ScheduleUpdateAccountsBatch() {
        UpdateAllAccountsBatch batch = new UpdateAllAccountsBatch();

        Database.executeBatch(batch, 200);
    }
}

