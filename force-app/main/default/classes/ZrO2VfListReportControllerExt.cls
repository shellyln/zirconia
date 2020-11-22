// Copyright (c) 2020 Shellyl_N and Authors
// license: MIT
// https://github.com/shellyln

public with sharing class ZrO2VfListReportControllerExt {
    ApexPages.StandardSetController setCon;

    public ZrO2VfListReportControllerExt(ApexPages.StandardSetController controller) {
        setCon = controller;
    }

    public string AllRecordsJSON {
        get {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('data');
            gen.writeObject(setCon.getRecords());
            gen.writeEndObject();
            String json = gen.getAsString();
            return json;
        }
    }

    public string SelectedRecordsJSON {
        get {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('data');
            gen.writeObject(setCon.getSelected());
            gen.writeEndObject();
            String json = gen.getAsString();
            return json;
        }
    }
}