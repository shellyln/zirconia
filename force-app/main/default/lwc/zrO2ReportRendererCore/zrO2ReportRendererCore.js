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
     *     title: string,
     *     reportName: string,
     *     commands: ('print' | 'download' | 'attach' | 'attach+navigate' | 'event')[],
     *     recordId: string,
     *     objectApiName: string,
     *     inputFormat: 'md' | 'md-fragment' | 'lisp' | 'html',
     *     rawInput: boolean,
     *     dataFormat: 'object' | 'json' | 'lisp',
     *     bodyStyle: string,
     *     markdownBodyStyle: string,
     *     tocIncludeLevel: [1] | [1, 2] | [1, 2, 3] | [1, 2, 3, 4] | [1, 2, 3, 4, 5] | [1, 2, 3, 4, 5, 6]
     *     darkTheme: boolean,
     *     replacementMacros: {re: RegExp, fn: 'lsx' | Function}[],
     * }} options
     * @returns {Promise<string>}
     */
    @api
    async renderReport(reportDef, data, options) {
        // eslint-disable-next-line no-undef
        const buf = await menneu.render(reportDef, JSON.parse(JSON.stringify(data)), {
            title: options.title ?? options.reportName ?? 'Untitled',
            inputFormat: options.inputFormat ?? 'html',
            rawInput: options.rawInput ?? false,
            dataFormat: options.dataFormat ?? 'object',
            outputFormat: 'html',
            bodyStyle: options.bodyStyle ?? '',
            markdownBodyStyle: options.markdownBodyStyle ?? '',
            tocIncludeLevel: options.tocIncludeLevel ?? [1, 2],
            darkTheme: options.darkTheme ?? false,
            replacementMacros: options.replacementMacros ?? [{
                re: /!!!lsx\s([\s\S]+?)!!!/g,
                fn: 'lsx', // evaluate input as LSX script
            }],
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
