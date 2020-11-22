// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import { publish, MessageContext } from 'lightning/messageService';
import REFRESH_VIEW_MC from '@salesforce/messageChannel/ZrO2RefreshViewMessageChannel__c';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import attachFile from '@salesforce/apex/ZrO2ReportRendererController.attachFile';
import ZrO2Resources from '@salesforce/resourceUrl/ZrO2Resources';

export default class ZrO2ReportRendererCore extends NavigationMixin(LightningElement) {
    /** @type string */
    frameSrc = '/apex/ZrO2LwcReportRendererProxy';

    /** Lifecycle callback */
    async connectedCallback() {
        await loadScript(this, ZrO2Resources + '/menneu_0_4_0/menneu.min.js');
    }

    /** 
     * @param {string} reportDef
     * @param {*} data
     * @param {{
     *     commands: ('print' | 'download' | 'attach' | 'attach+navigate' | 'event')[],
     *     recordId: string,
     *     objectApiName: string,
     *     title: string,
     *     reportName: string,
     *     inputFormat: 'md' | 'md-fragment' | 'lisp' | 'html',
     *     rawInput: boolean,
     *     dataFormat: 'object' | 'json' | 'lisp' }} options
     * @returns {Promise<string>}
     */
    @api
    async renderReport(reportDef, data, options) {
        // eslint-disable-next-line no-undef
        const buf = await menneu.render(reportDef, JSON.parse(JSON.stringify(data)), {
            replacementMacros: [{
                re: /!!!lsx\s([\s\S]+?)!!!/g,
                fn: 'lsx', // evaluate input as LSX script
            }],
            title: options.title ?? options.reportName ?? 'Untitled',
            inputFormat: options.inputFormat ?? 'html',
            rawInput: options.rawInput ?? false,
            dataFormat: options.dataFormat ?? 'object',
            outputFormat: 'html',
        });

        const content = buf.toString();

        for (const command of options.commands ?? []) {
            switch (command) {
            case 'print': case 'download':
                this.template
                    .querySelector('iframe').contentWindow
                    .postMessage({
                        command,
                        fileName: `${options.reportName ?? 'Untitled'}.html`,
                        content,
                    }, '*');
                break;
            case 'attach':
                // eslint-disable-next-line no-await-in-loop
                await attachFile({
                    title: options.reportName,
                    fileName: `${options.reportName}.html`,
                    fileContent: content,
                    id: options.recordId,
                });
                getRecordNotifyChange([{recordId: options.recordId}]); // no effects
                publish(this.messageContext, REFRESH_VIEW_MC, {});
                break;
            case 'attach+navigate':
                {
                    // eslint-disable-next-line no-await-in-loop
                    const contetnId = await attachFile({
                        title: options.reportName,
                        fileName: `${options.reportName}.html`,
                        fileContent: content,
                        id: options.recordId,
                    });
                    this[NavigationMixin.Navigate]({
                        type: 'standard__namedPage',
                        attributes: {
                            pageName: 'filePreview'
                        },
                        state : {
                            recordIds: contetnId,
                            selectedRecordId: contetnId,
                        },
                    });
                    getRecordNotifyChange([{recordId: options.recordId}]); // no effects
                    publish(this.messageContext, REFRESH_VIEW_MC, {});
                }
                break;
            case 'event':
                this.dispatchEvent(new CustomEvent('zrO2ReportRendered', {
                    content,
                }));
                break;
            default:
                break;
            }
        }

        return content;
    }

    @wire(MessageContext)
    messageContext;
}
