// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

global with sharing class ZrO2ReportRendererController {
    global ZrO2ReportRendererController() {
    }

    @TestVisible
    private static SObject getRecordById(String objectApiName, String[] fields, Id id){
        String flds = '';
        for (Integer i = 0; i < fields.size(); i++) {
            if (i != 0) {
                flds += ',';
            }
            flds += String.escapeSingleQuotes(fields[i]);
        }
        return (SObject)(Database.query(
            'select ' + flds + ',CreatedBy.Id,CreatedBy.Name,LastModifiedBy.Id,LastModifiedBy.Name,Owner.Id,Owner.Name ' +
            'from ' + String.escapeSingleQuotes(objectApiName) +
            ' where Id=\'' + String.escapeSingleQuotes(id) + '\' limit 1')[0]);
    }

    @TestVisible
    private static SObject[] getRecords(
            String objectApiName, String[] fields, String whereCondition, String sorting,
            Integer offset, Integer recordsInPage) {

        String flds = '';
        for (Integer i = 0; i < fields.size(); i++) {
            if (i != 0) {
                flds += ',';
            }
            flds += String.escapeSingleQuotes(fields[i]);
        }
        return (SObject[])(Database.query(
            'select ' + flds + ',CreatedBy.Id,CreatedBy.Name,LastModifiedBy.Id,LastModifiedBy.Name,Owner.Id,Owner.Name ' +
            'from ' + String.escapeSingleQuotes(objectApiName) + ' ' +
            (whereCondition != null && whereCondition.trim() != ''
                ? 'where ' + whereCondition + ' '
                : '') +
            'order by ' + (sorting != null ? String.escapeSingleQuotes(sorting) : 'id') + ' ' +
            'limit ' + recordsInPage + ' offset ' + offset + ' '));
    }

    // http://theblogreaders.com/insert-files-using-salesforce-apex/
    @RemoteAction
    @AuraEnabled
    global static Id attachFile(String title, String fileName, String fileContent, Id id) {
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = title; // Display name of the files
        conVer.VersionData = Blob.valueof(fileContent); // converting your string to Blog
        insert conVer;    //Insert ContentVersion

        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [
            SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id
        ].ContentDocumentId;

        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;

        return conDoc;
    }

    // https://salesforce.stackexchange.com/questions/5004/dynamically-get-the-path-to-a-static-resource
    @RemoteAction
    @AuraEnabled
    global static String getResourceURL(String resourceName){
        // Fetching the resource
        List<StaticResource> resourceList= [
            SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName
        ];

        // Checking if the result is returned or not
        if (resourceList.size() == 1) {
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            return (
                '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' +
                (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName
            ); 
        } else {
            return '';
        }
    }

    @RemoteAction
    @AuraEnabled
    global static String getSingleStaticResourceContent(String resourceName) {
        // Fetching the resource
        List<StaticResource> resourceList= [
            SELECT Id, Body FROM StaticResource WHERE Name = :resourceName
        ];

        // Checking if the result is returned or not
        if (resourceList.size() == 1) {
            return resourceList[0].Body.toString();
        } else {
            return '';
        }
    }
}
