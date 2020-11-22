// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';

export default class MyReportPrintSingleRecordProvider extends LightningElement {
    /** @type string */
    @api
    reportName;

    /** @type string */
    @api
    resourceName;

    /** @type string */
    @api
    resourceFileName;

    /**
     * @type {'md' | 'md-fragment' | 'lisp' | 'html'}
     */
    @api
    reportFormat;

    /**
     * @type string
     * Comma separated commands ('print' | 'download' | 'attach' | 'attach+navigate' | 'event').
     */
    @api
    commands;

    /** @type string */
    @api
    buttonCaption;

    /** @type {'neutral' | 'brand' | 'outline-brand' | 'destructive' | 'text-destructive' | 'success'} */
    @api
    buttonVariant;

    // The record page provides recordId and objectApiName.

    /** @type string */
    @api
    recordId;

    /** @type string */
    @api
    objectApiName;

    /** @type string */
    @track
    contentData;

    @wire(getRecord, {
        recordId: '$recordId',
        layoutTypes: ['Full'],
        modes: ['View'],
    })
    wiredRecordObj({ error, data }) {
        if (error) {
            //
        } else {
            this.recordObj = data;
            this.makeContentData();
        }
    }

    @track
    recordObj;

    @wire(getRecord, {
        recordId: USER_ID,
        layoutTypes: ['Full'],
        modes: ['View'],
    })
    wiredLoginUser({ error, data }) {
        if (error) {
            //
        } else {
            this.loginUser = data;
            this.makeContentData();
        }
    }

    @track
    loginUser;

    makeContentData() {
        if (!this.loginUser || !this.recordObj) {
            return;
        }
        this.contentData = JSON.stringify({
            loginUser: JSON.parse(JSON.stringify(this.loginUser)),
            reportName: this.reportName,
            ...JSON.parse(JSON.stringify(this.recordObj)), // convert to pure object
        });
    }
}
