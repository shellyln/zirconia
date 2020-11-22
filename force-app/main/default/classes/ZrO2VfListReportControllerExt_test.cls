// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

@isTest
public with sharing class ZrO2VfListReportControllerExt_test {
    public ZrO2VfListReportControllerExt_test() {
    }

    @isTest
    static void test_RecordsJSON() {
        Account acc = new Account(Name='Acme Inc.');
        insert acc;

        PageReference pageRef = Page.ZrO2ExampleAccountListReport;
        Test.setCurrentPage(pageRef);

        Apexpages.StandardSetController sc = new Apexpages.StandardSetController(new List<Account>{acc});
        ZrO2VfListReportControllerExt ext = new ZrO2VfListReportControllerExt(sc);

        String jsonAll = ext.AllRecordsJSON;
        System.assertNotEquals(jsonAll, '');

        String jsonSel = ext.SelectedRecordsJSON;
        System.assertNotEquals(jsonSel, '');
    }
}
