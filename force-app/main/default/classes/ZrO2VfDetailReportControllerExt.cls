// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

global with sharing class ZrO2VfDetailReportControllerExt {
    ApexPages.StandardController con;

    global ZrO2VfDetailReportControllerExt(ApexPages.StandardController controller) {
        con = controller;
    }

    global string RecordJSON {
        get {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('data');
            gen.writeObject(con.getRecord());
            gen.writeEndObject();
            String json = gen.getAsString();
            return json;
        }
    }
}
