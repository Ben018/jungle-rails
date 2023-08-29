describe("Homepage ", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  it("There is products on the page", () => {
    cy.get(".products article").should("be.visible");
  });

  it("There is 2 products on the page", () => {
    cy.get(".products article").should("have.length", 2);
  });

  it("Click on product takes you to the product details", () => {
    cy.get(".products article:first-child").click();
    cy.get(".product-detail").should("be.visible");
  });
});
