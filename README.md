# 💎 Zirconia
## Report rendering library for Salesforce LWC and Visualforce

You can easily build the complex documents written in [Markdown](https://github.com/markdown-it/markdown-it), HTML, and [LSX](https://github.com/shellyln/liyad#what-is-lsx)
that including images, [charts](https://www.chartjs.org/), [UML diagrams](http://plantuml.com/), [barcodes and 2d codes (QR Code)](https://github.com/shellyln/red-agate/tree/master/packages/red-agate-barcode).  
And get the output as a HTML that packed into the single file.  
Zirconia is powered by [Ménneu](https://github.com/shellyln/menneu) document processor.

## 💡 Examples of report template

See https://github.com/shellyln/menneu/tree/master/examples and  
`force-app/main/default/staticresources/ZrO2ReportExamples`

<table align="center">
  <tbody>
    <tr align="center">
      <td style="width:33%">
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-markdown.pdf">
          <img src="https://shellyln.github.io/menneu/assets/pdf/example-markdown.png" style="max-width:100%;">
        </a>
        Markdown Demo
        <a href="https://github.com/shellyln/menneu/tree/master/examples/markdown-demo">
          source
        </a>
        /
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-markdown.pdf">
          pdf
        </a>
      </td>
      <td width="33%">
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-bill.pdf">
          <img src="https://shellyln.github.io/menneu/assets/pdf/example-bill.png" style="max-width:100%;">
        </a>
        Billing Statement
        <a href="https://github.com/shellyln/menneu/tree/master/examples/billing">
          source
        </a>
        /
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-bill.pdf">
          pdf
        </a>
      </td>
      <td width="33%">
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-html.pdf">
          <img src="https://shellyln.github.io/menneu/assets/pdf/example-html.png" style="max-width:100%;">
        </a>
        HTML Demo
        <a href="https://github.com/shellyln/menneu/tree/master/examples/html-demo">
          source
        </a>
        /
        <a href="https://shellyln.github.io/menneu/assets/pdf/example-html.pdf">
          pdf
        </a>
      </td>
    </tr>
    <tr>
      <td style="text-align:center">
        Testing the basic and extended markdown syntaxes.
      </td>
      <td style="text-align:center">
        Reporting example that markuped up with Lisp LSX syntax.
      </td>
      <td style="text-align:center">
        Testing the html template that embedding Lisp LSX.
      </td>
    </tr>
  </tbody>
</table>


## 💡 LSX Language reference

See [https://github.com/shellyln/liyad#what-is-lsx](https://github.com/shellyln/liyad#what-is-lsx)


## 📝 Visual editors

* [Ménneu Playground](https://shellyln.github.io/menneu/playground.html)
    * Report definition
      ```md
      %%%($=for $data """
      # %%%($last ::$data:Name)
      """)
      ## h2
      ### h3
      ```
    * Preview data
      ```json
      [{"Id":"1","Name":"Foo"},{"Id":"2","Name":"Bar"}]
      ```

* [MDNE Online](https://shellyln.github.io/mdne/#filename=Untitled.md&open.d=eJwDAAAAAAE)
    * Report definition and Preview data
      ```md
      <!--- Preview data -->
      %%%($last
          ($let $data ($list
              (# ("Id" "1")("Name" "Foo"))
              (# ("Id" "2")("Name" "Bar")) )) nil)
      
      <!--- Report definition -->
      %%%($=for $data """
      # %%%($last ::$data:Name)
      """)
      ## h2
      ### h3
      ```
        * Turn on the `Scripting` switch

* [MDNE Desktop app](https://github.com/shellyln/mdne) ([for Node.js+Chrome](https://github.com/shellyln/mdne)), ([Electron standalone app](https://github.com/shellyln/mdne-electron))
    * `path/to/report-def.md`
      ```md
      %%%($=for $data """
      # %%%($last ::$data:Name)
      """)
      ## h2
      ### h3
      ```
    * `path/to/report-def.data.json`
      ```json
      [{"Id":"1","Name":"Foo"},{"Id":"2","Name":"Bar"}]
      ```
        * Turn on the `Scripting` switch

## ⚙️ Setup a deployment and contribution environment

```bash
git clone https://github.com/shellyln/zirconia.git
cd zirconia
git checkout -b my-package-releases

# Authorize a Dev-Hub org (if you haven't already done).
sfdx force:auth:web:login \
    --setdefaultdevhubusername
    --setalias my-hub-org

sfdx force:org:create \
    --definitionfile config/project-scratch-def.json \
    --setalias ZirconiaOrg \
    --durationdays 30 \
    --setdefaultusername
npm install

sfdx force:source:push
sfdx force:org:open

# and try it!
```

## 📖 Usage

### 🟢 Object detail reports with LWC

1. Open object detail view page.
1. Click `⚙️Setup` menu and click `Edit page`.
1. Select `Components > Custom > ZrO2RefreshViewMessageBroker` from Left pane, and drop to any top level panel of right pane.
1. Select `Components > Custom > zrO2SingleRecordProvider` from Left pane, and drop to any panel of right pane you want to place a `Print` button.
1. Set `zrO2SingleRecordProvider` properties:
    | Field            | Value |
    |------------------|-------|
    | reportName       | `example` |
    | resourceName     | `ZrO2ReportExamples` (static resource name) |
    | resourceFileName | `example-lwc-detail.md`, `example-lwc-detail-chart.md`, or something you created |
    | reportFormat     | `md` (select from `md` \| `md-fragment` \| `lisp` \| `html`) |
    | commands         | `print,download,attach+navigate` (select from `print` \| `download` \| `attach` \| `attach+navigate` \| `event`) |
    | buttonCaption    | `Print` |
    | buttonVariant    | `brand` (select from `neutral` \| `brand` \| `outline-brand` \| `destructive` \| `text-destructive` \| `success`) |
    * To query the relationships, create a new LWC with `zrO2SingleRecordProvider` as the boilerplate.
1. If you haven't activated this flexi page yet, click the `Activation...` button.
1. Click `Save` button.

### 🟢 Object detail reports with Visualforce (VF Button)

1. Click `⚙️Setup` menu and click `⚙️Setup`.
1. Open `Object Manager` and select the object you want to add report. (e.g.: `Account`)
1. Select `Buttons, Links, and Actions` menu and click `New Button or Link` button.
1. Set properties and save:
    | Field          | Value |
    |----------------|-------|
    | Display Type   | Detail Page Button |
    | Behavior       | Display in existing window with sidebar |
    | Content Source | Visualforce Page |
    | Content        | `ZrO2ExampleAccountDetailReport` or something you created |
    * To change the target object, data querying condition, and report template,
      create a new Visualforce Page with `ZrO2ExampleAccountDetailReport` as the boilerplate.
1. Select `Page Layouts` menu and add the button to the page layouts.

### 🟢 Object detail reports with Visualforce (VF Quick Action)

1. Click `⚙️Setup` menu and click `⚙️Setup`.
1. Open `Object Manager` and select the object you want to add report. (e.g.: `Account`)
1. Select `Buttons, Links, and Actions` menu and click `New Action` button.
1. Set properties and save:
    | Field          | Value |
    |----------------|-------|
    | Action Type    | Custom Visualforce |
    | Visualforce Page | `ZrO2ExampleAccountDetailReport` or something you created |
    * To change the target object, data querying condition, and report template,
      create a new Visualforce Page with `ZrO2ExampleAccountDetailReport` as the boilerplate.
1. Select `Page Layouts` menu and add the Quick Action to the page layouts.

### 🟢 Object list reports with Visualforce

1. Click `⚙️Setup` menu and click `⚙️Setup`.
1. Open `Object Manager` and select the object you want to add report. (e.g.: `Account`)
1. Select `Buttons, Links, and Actions` menu and click `New Button or Link` button.
1. Set properties and save:
    | Field          | Value |
    |----------------|-------|
    | Display Type   | List Button |
    | &nbsp;&nbsp;Display Checkboxes | X |
    | Behavior       | Display in existing window with sidebar |
    | Content Source | Visualforce Page |
    | Content        | `ZrO2ExampleAccountListReport` or something you created |
    * To change the target object, data querying condition, and report template,
      create a new Visualforce Page with `ZrO2ExampleAccountListReport` as the boilerplate.
1. Select `Search Layouts` menu and add the button to the list layouts.
1. Select `Search Layouts for Salesforce Classic` menu and add the button to the `List View` layouts.

## 📦 Deploy the package (pre-release)

```bash
sfdx force:org:list

# Specify the `USERNAME` or` ALIAS` of the DevHub org listed in the above command.
sfdx force:package:create \
    -n Zirconia \
    -d "Report rendering library for Salesforce LWC and Visualforce" \
    -r force-app \
    -t Unlocked \
    -v <devhub_org_username_or_alias>

sfdx force:package:list

cat sfdx-project.json

sfdx force:package:version:create \
    -p Zirconia \
    -d force-app \
    -k test1234 \
    -v <devhub_org_username_or_alias> \
    --codecoverage \
    --wait 10

sfdx force:package:version:list --verbose

git add .
git commit -m "v0.1.0-1"

# Install the package in your developer or sandbox org for testing.
sfdx force:package:install \
    -u <target_dev_or_sandbox_org_username_or_alias> \
    --package Zirconia@0.1.0-1 \
    -k test1234 \
    --wait 10 \
    --publishwait 10 \
    --noprompt
```

## 🚀 Deploy the package (production-release)

```bash
# Promote the package version to production.
sfdx force:package:version:promote \
    -p Zirconia@0.1.0-1 \
    -v <devhub_org_username_or_alias>

# Install the package in your production org.
sfdx force:package:install \
    -u <target_org_username_or_alias> \
    --package Zirconia@0.1.0-1 \
    -k test1234 \
    --wait 10 \
    --publishwait 10 \
    --noprompt
```

## 🚧 Manage the package and package versions

```bash
sfdx force:package:version:list --verbose
sfdx force:package:version:delete -p 04tXXX
sfdx force:package:delete -p 0HoXXX
```


---

## ⚖️ License
[MIT](https://github.com/shellyln/zirconia/blob/master/LICENSE.md)  
Copyright (c) 2020 Shellyl_N and Authors

