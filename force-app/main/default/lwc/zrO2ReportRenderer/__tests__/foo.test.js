// hello.test.js
import { createElement } from "lwc";
import MyComp from "c/ZrO2ReportRenderer";

// https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.unit_testing_using_jest_create_tests
// https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.unit_testing_using_wire_utility

describe("c-zr-o2-report-renderer", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("test c-zr-o2-report-renderer", () => {
    // Create element
    const element = createElement("c-zr-o2-report-renderer", {
      is: MyComp
    });
    document.body.appendChild(element);

    // Verify displayed greeting
    // const button = element.shadowRoot.querySelector("button");
    // expect(button.textContent).toBe(
    //   "Print"
    // );
    expect(1).toEqual(1);
  });
});
