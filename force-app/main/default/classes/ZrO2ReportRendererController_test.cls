// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

@isTest
public with sharing class ZrO2ReportRendererController_test {
    public ZrO2ReportRendererController_test() {
    }

    @isTest
    static void test_getRecordById_1() {
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        String[] fields = new List<String>{ 'Id', 'Name' };
        Account obj = (Account)ZrO2ReportRendererController.getRecordById('Account', fields, acc.Id);
        System.assertEquals(obj.Id, acc.Id);
        System.assertEquals(obj.Name, 'Acme Inc.');
        System.assertEquals(obj.CreatedBy.Id, currentUser.Id);
        System.assertEquals(obj.CreatedBy.Name, currentUser.Name);
        System.assertEquals(obj.LastModifiedBy.Id, currentUser.Id);
        System.assertEquals(obj.LastModifiedBy.Name, currentUser.Name);
        System.assertEquals(obj.Owner.Id, currentUser.Id);
        System.assertEquals(obj.Owner.Name, currentUser.Name);
    }

    @isTest
    static void test_getRecordById_2() {
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        Account obj = (Account)ZrO2ReportRendererController.getRecordById('Account', null, acc.Id);
        System.assertEquals(obj.Id, acc.Id);
        System.assertEquals(obj.Name, 'Acme Inc.');
        System.assertEquals(obj.CreatedBy.Id, currentUser.Id);
        System.assertEquals(obj.CreatedBy.Name, currentUser.Name);
        System.assertEquals(obj.LastModifiedBy.Id, currentUser.Id);
        System.assertEquals(obj.LastModifiedBy.Name, currentUser.Name);
        System.assertEquals(obj.Owner.Id, currentUser.Id);
        System.assertEquals(obj.Owner.Name, currentUser.Name);
    }

    @isTest
    static void test_getRecords_1() {
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        String[] fields = new List<String>{ 'Id', 'Name' };
        Account[] objs = (Account[])ZrO2ReportRendererController.getRecords('Account', fields, 'Name=\'Acme Inc.\'', 'id', 0, 100);
        System.assertEquals(objs[0].Id, acc.Id);
        System.assertEquals(objs[0].Name, 'Acme Inc.');
        System.assertEquals(objs[0].CreatedBy.Id, currentUser.Id);
        System.assertEquals(objs[0].CreatedBy.Name, currentUser.Name);
        System.assertEquals(objs[0].LastModifiedBy.Id, currentUser.Id);
        System.assertEquals(objs[0].LastModifiedBy.Name, currentUser.Name);
        System.assertEquals(objs[0].Owner.Id, currentUser.Id);
        System.assertEquals(objs[0].Owner.Name, currentUser.Name);
    }

    @isTest
    static void test_getRecords_2() {
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        Account[] objs = (Account[])ZrO2ReportRendererController.getRecords('Account', null, 'Name=\'Acme Inc.\'', 'id', 0, 100);
        System.assertEquals(objs[0].Id, acc.Id);
        System.assertEquals(objs[0].Name, 'Acme Inc.');
        System.assertEquals(objs[0].CreatedBy.Id, currentUser.Id);
        System.assertEquals(objs[0].CreatedBy.Name, currentUser.Name);
        System.assertEquals(objs[0].LastModifiedBy.Id, currentUser.Id);
        System.assertEquals(objs[0].LastModifiedBy.Name, currentUser.Name);
        System.assertEquals(objs[0].Owner.Id, currentUser.Id);
        System.assertEquals(objs[0].Owner.Name, currentUser.Name);
    }

    @isTest
    static void test_attachFile() {
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        String[] fields = new List<String>{ 'Id', 'Name' };
        string conDocId = ZrO2ReportRendererController.attachFile('test', 'filename.txt', 'Hello', acc.Id);

        ContentVersion conVer = [SELECT FileExtension, Title FROM ContentVersion WHERE ContentDocumentId = :conDocId and IsLatest=true];
        System.assertEquals(conVer.Title, 'test');
    }

    @isTest
    static void test_getResourceURL() {
        string url = ZrO2ReportRendererController.getResourceURL('ZrO2_7Yv8r6ZsQH68FzHD');
        System.assertEquals(url, '');
    }

    @isTest
    static void test_getSingleStaticResourceContent() {
        string url = ZrO2ReportRendererController.getSingleStaticResourceContent('ZrO2_7Yv8r6ZsQH68FzHD');
        System.assertEquals(url, '');
    }
}
