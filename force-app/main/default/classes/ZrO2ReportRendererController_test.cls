// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

@isTest
public with sharing class ZrO2ReportRendererController_test {
    public ZrO2ReportRendererController_test() {
    }

    @isTest
    static void test_getRecordById() {
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        String[] fields = new List<String>{ 'Id', 'Name' };
        Account obj = (Account)ZrO2ReportRendererController.getRecordById('Account', fields, acc.Id);
        System.assertEquals(obj.Id, acc.Id);
        System.assertEquals(obj.Name, 'Acme Inc.');
    }

    @isTest
    static void test_getRecords() {
        Account acc = new Account(Name='Acme Inc.');
        insert acc;
        String[] fields = new List<String>{ 'Id', 'Name' };
        Account[] objs = (Account[])ZrO2ReportRendererController.getRecords('Account', fields, 'Name=\'Acme Inc.\'', 'id', 0, 100);
        System.assertEquals(objs[0].Id, acc.Id);
        System.assertEquals(objs[0].Name, 'Acme Inc.');
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
