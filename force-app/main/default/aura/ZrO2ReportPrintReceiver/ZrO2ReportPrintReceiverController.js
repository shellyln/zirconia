// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

({
    handleReceiveRefreshViewMessage: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleReceiveReportPrintMessage: function (component, event, helper) {
        if (event != null) {
            var message = event.getParams();
            component.find('childlwc')
            .renderReport(message['reportDef'], JSON.parse(message['data']), {
                commands: message['commands'].split(','),
                recordId: message['recordId'],
                objectApiName: message['objectApiName'],
                title: message['title'],
                reportName: message['reportName'],
                inputFormat: message['inputFormat'],
                rawInput: Boolean(message['rawInput']),
                dataFormat: 'object'
            })
            .then(function (content) {
                //
            })
            .catch(function (err) {
                console.error(err);
            });
        }
    }
})
