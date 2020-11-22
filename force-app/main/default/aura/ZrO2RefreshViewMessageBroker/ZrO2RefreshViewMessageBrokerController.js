// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

({
    handleReceiveMessage: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})
