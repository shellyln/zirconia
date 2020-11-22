// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

import { LightningElement, api, wire } from 'lwc';
import { MessageContext } from 'lightning/messageService';
// import REPORT_PRINT_MC from '@salesforce/messageChannel/ZrO2ReportPrintMessageChannel__c';
import getResourceURL from '@salesforce/apex/ZrO2ReportRendererController.getResourceURL';

export default class MyReportPrint extends LightningElement {
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

    /** @type string */
    @api
    buttonVariant;

    /** @type string */
    @api
    contentData;

    // The record page provides recordId and objectApiName.

    /** @type string */
    @api
    recordId;

    /** @type string */
    @api
    objectApiName;

    @wire(MessageContext)
    messageContext;

    // eslint-disable-next-line no-unused-vars
    async handlePrintClick(event) {
        const resourcePath = await getResourceURL({ resourceName: this.resourceName });
        const resp = await fetch(`${resourcePath}/${this.resourceFileName}`);
        const reportDef = await resp.text();

        // Call directly
        await this.template.querySelector('c-zr-o2-report-renderer-core').renderReport(
            reportDef,
            JSON.parse(this.contentData),
            {
                commands: this.commands.split(','),
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                title: this.reportName,
                reportName: this.reportName,
                inputFormat: this.reportFormat,
                rawInput: false,
                dataFormat: 'object',
            },
        );

        /*
        // Call by message publishing
        // NOTE: Don't work on mobile app.
        publish(this.messageContext, REPORT_PRINT_MC, {
            reportDef,
            data: this.contentData,
            commands: this.commands,
            recordId: this.recordId,
            objectApiName: this.objectApiName,
            title: this.reportName,
            reportName: this.reportName,
            inputFormat: this.reportFormat,
            rawInput: false,
            dataFormat: 'object',
        });
        */
    }
}
