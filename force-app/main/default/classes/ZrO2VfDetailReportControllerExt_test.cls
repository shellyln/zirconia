// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

@isTest
public with sharing class ZrO2VfDetailReportControllerExt_test {
    public ZrO2VfDetailReportControllerExt_test() {
    }

    @isTest
    static void test_RecordJSON() {
        Account acc = new Account(Name='Acme Inc.');
        insert acc;

        PageReference pageRef = Page.ZrO2ExampleAccountDetailReport;
        Test.setCurrentPage(pageRef);

        Apexpages.StandardController sc = new Apexpages.StandardController(acc);
        ZrO2VfDetailReportControllerExt ext = new ZrO2VfDetailReportControllerExt(sc);

        String json = ext.RecordJSON;
        System.assertNotEquals(json, '');
    }
}
