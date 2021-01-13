codeunit 135406 "Item Charges Plan-based E2E"
{
    Subtype = Test;

    trigger OnRun()
    begin
        // [FEATURE] [Item Charges] [UI] [User Group Plan]
    end;

    var
        Assert: Codeunit Assert;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
        LibraryERM: Codeunit "Library - ERM";
        LibraryPurchase: Codeunit "Library - Purchase";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        IsInitialized: Boolean;
        MissingPermissionsErr: Label 'You do not have the following permissions';

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsBusinessManager()
    var
        TempVendorDetails: Record Vendor temporary;
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A user with Business Manager Plan
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Purchase Invoice With Item Charges is Created, Posted, and Cancelled
        PostedPurchaseCreditMemoNo := CreatePostAndCancelPurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsEsternalAccountant()
    var
        TempVendorDetails: Record Vendor temporary;
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A user with External Accountant Plan
        LibraryE2EPlanPermissions.SetExternalAccountantPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Purchase Invoice With Item Charges is Created, Posted, and Cancelled
        PostedPurchaseCreditMemoNo := CreatePostAndCancelPurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsTeamMember()
    var
        TempVendorDetails: Record Vendor temporary;
        ErrorMessagesPage: TestPage "Error Messages";
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PurchaseInvoiceNo: Code[20];
        PostedPurchaseInvoiceNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] An item charge
        ItemChargeNo := CreateItemCharge;
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Purchase Invoice With Item Charges is Created
        asserterror CreatePurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);
        // [THEN] An error is thrown
        Assert.ExpectedErrorCode('TestValidation');
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        PurchaseInvoiceNo := CreatePurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Purchase Invoice With Item Charges is Posted
        ErrorMessagesPage.Trap;
        PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedMessage(MissingPermissionsErr, ErrorMessagesPage.Description.Value);
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        PostedPurchaseInvoiceNo := PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo, false);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Posted Purchase Invoice With Item Charges is Cancelled
        asserterror CancelPurchaseInvoiceWithItemCharges(PostedPurchaseInvoiceNo, true);
        // [THEN] An error is thrown
        Assert.ExpectedErrorCode('TestWrapped:Dialog');
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        PostedPurchaseCreditMemoNo := CancelPurchaseInvoiceWithItemCharges(PostedPurchaseInvoiceNo, false);
        Commit;

        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [THEN] All the verifications pass
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsEssentialISVEmbUser()
    var
        TempVendorDetails: Record Vendor temporary;
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A user with Essential ISV Emb Plan
        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Purchase Invoice With Item Charges is Created, Posted, and Cancelled
        PostedPurchaseCreditMemoNo := CreatePostAndCancelPurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsTeamMemberISVEmb()
    var
        TempVendorDetails: Record Vendor temporary;
        ErrorMessagesPage: TestPage "Error Messages";
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PurchaseInvoiceNo: Code[20];
        PostedPurchaseInvoiceNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] An item charge
        ItemChargeNo := CreateItemCharge;
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Purchase Invoice With Item Charges is Created
        asserterror CreatePurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);
        // [THEN] An error is thrown
        Assert.ExpectedErrorCode('TestValidation');

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        PurchaseInvoiceNo := CreatePurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Purchase Invoice With Item Charges is Posted
        ErrorMessagesPage.Trap;
        PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedMessage(MissingPermissionsErr, ErrorMessagesPage.Description.Value);

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        PostedPurchaseInvoiceNo := PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo, false);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Posted Purchase Invoice With Item Charges is Cancelled
        asserterror CancelPurchaseInvoiceWithItemCharges(PostedPurchaseInvoiceNo, true);
        // [THEN] An error is thrown
        Assert.ExpectedErrorCode('TestWrapped:Dialog');

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        PostedPurchaseCreditMemoNo := CancelPurchaseInvoiceWithItemCharges(PostedPurchaseInvoiceNo, false);
        Commit;

        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [THEN] All the verifications pass
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentPurchModalPageHandler,PostedPurchaseInvoicePageHandler,PostedPurchaseCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectPurchaseInvoiceAsDeviceISVEmbUser()
    var
        TempVendorDetails: Record Vendor temporary;
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedPurchaseCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Purchase Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A user with Device ISV Emb Plan
        LibraryE2EPlanPermissions.SetDeviceISVEmbUserPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Purchase Invoice With Item Charges is Created, Posted, and Cancelled
        PostedPurchaseCreditMemoNo := CreatePostAndCancelPurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyVendorLedgerEntries(PostedPurchaseCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsBusinessManager()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] A user with Business Manager Plan
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Sales Invoice With Item Charges is Created, Posted, and Cancelled
        PostedSalesCreditMemoNo := CreatePostAndCancelSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsExternalAccountant()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] A user with External Accountant Plan
        LibraryE2EPlanPermissions.SetExternalAccountantPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Sales Invoice With Item Charges is Created, Posted, and Cancelled
        PostedSalesCreditMemoNo := CreatePostAndCancelSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsTeamMember()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        ErrorMessagesPage: TestPage "Error Messages";
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        SalesInvoiceNo: Code[20];
        PostedSalesInvoiceNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] An item charge
        ItemChargeNo := CreateItemCharge;
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Sales Invoice With Item Charges is Created
        asserterror SalesInvoiceNo := CreateSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);
        Assert.ExpectedErrorCode('TestValidation');
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        SalesInvoiceNo := CreateSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);
        // [THEN] No permission error is thrown
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Sales Invoice With Item Charges is Posted
        ErrorMessagesPage.Trap;
        PostSalesInvoiceWithItemCharges(SalesInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedMessage(MissingPermissionsErr, ErrorMessagesPage.Description.Value);
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        PostedSalesInvoiceNo := PostSalesInvoiceWithItemCharges(SalesInvoiceNo, false);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] A Posted Sales Invoice With Item Charges is Cancelled
        asserterror CancelSalesInvoiceWithItemCharges(PostedSalesInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedErrorCode('TestWrapped:Dialog');
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        PostedSalesCreditMemoNo := CancelSalesInvoiceWithItemCharges(PostedSalesInvoiceNo, false);
        Commit;

        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [THEN] All the verifications pass
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsEssentialISVEmb()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] A user with Essential ISV Emb Plan
        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Sales Invoice With Item Charges is Created, Posted, and Cancelled
        PostedSalesCreditMemoNo := CreatePostAndCancelSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsTeamMemberISVEmb()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        ErrorMessagesPage: TestPage "Error Messages";
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        SalesInvoiceNo: Code[20];
        PostedSalesInvoiceNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] An item charge
        ItemChargeNo := CreateItemCharge;
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Sales Invoice With Item Charges is Created
        asserterror SalesInvoiceNo := CreateSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);
        Assert.ExpectedErrorCode('TestValidation');

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        SalesInvoiceNo := CreateSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);
        // [THEN] No permission error is thrown
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Sales Invoice With Item Charges is Posted
        ErrorMessagesPage.Trap;
        PostSalesInvoiceWithItemCharges(SalesInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedMessage(MissingPermissionsErr, ErrorMessagesPage.Description.Value);

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        PostedSalesInvoiceNo := PostSalesInvoiceWithItemCharges(SalesInvoiceNo, false);
        Commit;

        // [GIVEN] A user with Team Member Plan
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] A Posted Sales Invoice With Item Charges is Cancelled
        asserterror CancelSalesInvoiceWithItemCharges(PostedSalesInvoiceNo, true);
        // [THEN] A permission error is thrown
        Assert.ExpectedErrorCode('TestWrapped:Dialog');

        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        PostedSalesCreditMemoNo := CancelSalesInvoiceWithItemCharges(PostedSalesInvoiceNo, false);
        Commit;

        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [THEN] All the verifications pass
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    [Test]
    [HandlerFunctions('ConfigTemplatesModalPageHandler,ConfirmHandlerYes,ItemChargeAssignmentSalesModalPageHandler,PostedSalesInvoicePageHandler,PostedSalesCreditMemoHandler')]
    [Scope('OnPrem')]
    procedure ItemChargesCreatePostAndCorrectSalesInvoiceAsDeviceISVEmb()
    var
        TempCustomerDetails: Record Customer temporary;
        TempVendorDetails: Record Vendor temporary;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        ItemNo: Code[20];
        ItemChargeNo: Code[20];
        PostedSalesCreditMemoNo: Code[20];
    begin
        // [E2E] Scenario going trough the process of creating and cancelling a Sales Invoice containing Item Charges

        Initialize;
        FindVendorPostingAndVATSetup(TempVendorDetails);
        FindCustomerPostingAndVATSetup(TempCustomerDetails);

        // [GIVEN] An item
        ItemNo := CreateItemFromVendor(VendorNo, TempVendorDetails);
        // [GIVEN] A customer
        CustomerNo := CreateCustomer(TempCustomerDetails);
        // [GIVEN] A user with Device ISV Emb Plan
        LibraryE2EPlanPermissions.SetDeviceISVEmbUserPlan;

        // [WHEN] An Item Charge is created
        ItemChargeNo := CreateItemCharge;
        // [WHEN] A Sales Invoice With Item Charges is Created, Posted, and Cancelled
        PostedSalesCreditMemoNo := CreatePostAndCancelSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);

        // [THEN] All the verifications pass and no error is thrown
        VerifyCustLedgerEntries(PostedSalesCreditMemoNo);
        LibraryVariableStorage.AssertEmpty;
    end;

    local procedure Initialize()
    var
        ExperienceTierSetup: Record "Experience Tier Setup";
        LibraryERMCountryData: Codeunit "Library - ERM Country Data";
        LibraryNotificationMgt: Codeunit "Library - Notification Mgt.";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        AzureADPlanTestLibrary: Codeunit "Azure AD Plan Test Library";
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"Item Charges Plan-based E2E");

        LibraryNotificationMgt.ClearTemporaryNotificationContext;
        LibraryVariableStorage.Clear;

        ApplicationAreaMgmtFacade.SaveExperienceTierCurrentCompany(ExperienceTierSetup.FieldCaption(Essential));

        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"Item Charges Plan-based E2E");

        EnableReceiptAndShipmentOnInvoice;
        LibrarySales.SetCreditWarningsToNoWarnings;
        LibrarySales.SetStockoutWarning(false);

        LibraryERMCountryData.CreateVATData;
        LibraryERMCountryData.UpdatePurchasesPayablesSetup;

        IsInitialized := true;
        Commit;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"Item Charges Plan-based E2E");

        // Populate table Plan if empty
        AzureADPlanTestLibrary.PopulatePlanTable();
    end;

    local procedure EnableReceiptAndShipmentOnInvoice()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        PurchasesPayablesSetup.Get;
        PurchasesPayablesSetup."Receipt on Invoice" := true;
        PurchasesPayablesSetup.Modify(true);
        SalesReceivablesSetup.Get;
        SalesReceivablesSetup."Shipment on Invoice" := true;
        SalesReceivablesSetup.Modify(true);
    end;

    local procedure CreatePostAndCancelPurchaseInvoiceWithItemCharges(VendorNo: Code[20]; ItemNo: Code[20]; ItemChargeNo: Code[20]) PostedPurchaseCreditMemoNo: Code[20]
    var
        PurchaseInvoiceNo: Code[20];
        PostedPurchaseInvoiceNo: Code[20];
    begin
        PurchaseInvoiceNo := CreatePurchaseInvoiceWithItemCharges(VendorNo, ItemNo, ItemChargeNo);
        PostedPurchaseInvoiceNo := PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo, false);
        PostedPurchaseCreditMemoNo := CancelPurchaseInvoiceWithItemCharges(PostedPurchaseInvoiceNo, false);
    end;

    local procedure CreatePurchaseInvoiceWithItemCharges(VendorNo: Code[20]; ItemNo: Code[20]; ItemChargeNo: Code[20]) PurchaseInvoiceNo: Code[20]
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseInvoice: TestPage "Purchase Invoice";
    begin
        PurchaseInvoice.OpenNew;
        PurchaseInvoice."Buy-from Vendor Name".SetValue(VendorNo);
        PurchaseInvoice."Vendor Invoice No.".SetValue(LibraryUtility.GenerateGUID);

        CreatePurchaseInvoiceLine(
          PurchaseInvoice, Format(PurchaseLine.Type::Item), ItemNo, LibraryRandom.RandIntInRange(1, 10), LibraryRandom.RandDecInRange(1, 1000, 2));
        CreatePurchaseInvoiceLine(
          PurchaseInvoice, Format(PurchaseLine.Type::"Charge (Item)"), ItemChargeNo, LibraryRandom.RandIntInRange(1, 10),
          LibraryRandom.RandDecInRange(1, 1000, 2));

        PurchaseInvoice.PurchLines.ItemChargeAssignment.Invoke;
        PurchaseInvoiceNo := PurchaseInvoice."No.".Value;
        PurchaseInvoice.OK.Invoke;
    end;

    local procedure CreatePurchaseInvoiceLine(var PurchaseInvoice: TestPage "Purchase Invoice"; Type: Text; No: Code[20]; Quantity: Integer; DirectUnitCost: Decimal)
    begin
        PurchaseInvoice.PurchLines.New;
        PurchaseInvoice.PurchLines.FilteredTypeField.SetValue(Type);
        PurchaseInvoice.PurchLines."No.".SetValue(No);
        PurchaseInvoice.PurchLines.Quantity.SetValue(Quantity);
        PurchaseInvoice.PurchLines."Direct Unit Cost".SetValue(DirectUnitCost);
    end;

    local procedure PostPurchaseInvoiceWithItemCharges(PurchaseInvoiceNo: Code[20]; ExpectedFailure: Boolean) PostedPurchaseInvoiceNo: Code[20]
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseInvoice: TestPage "Purchase Invoice";
    begin
        PurchaseInvoice.OpenEdit;
        PurchaseInvoice.GotoKey(PurchaseHeader."Document Type"::Invoice, PurchaseInvoiceNo);
        PurchaseInvoice.Post.Invoke;
        if not ExpectedFailure then
            PostedPurchaseInvoiceNo := CopyStr(LibraryVariableStorage.DequeueText, 1, MaxStrLen(PostedPurchaseInvoiceNo));
    end;

    local procedure CancelPurchaseInvoiceWithItemCharges(PostedInvoiceNo: Code[20]; ExpectedFailure: Boolean) PostedPurchaseCreditMemoNo: Code[20]
    var
        PostedPurchaseInvoice: TestPage "Posted Purchase Invoice";
    begin
        PostedPurchaseInvoice.OpenEdit;
        PostedPurchaseInvoice.GotoKey(PostedInvoiceNo);
        PostedPurchaseInvoice.CancelInvoice.Invoke;
        if not ExpectedFailure then
            PostedPurchaseCreditMemoNo := CopyStr(LibraryVariableStorage.DequeueText, 1, MaxStrLen(PostedPurchaseCreditMemoNo));
    end;

    local procedure CreatePostAndCancelSalesInvoiceWithItemCharges(CustomerNo: Code[20]; ItemNo: Code[20]; ItemChargeNo: Code[20]) PostedSalesCreditMemoNo: Code[20]
    var
        SalesInvoiceNo: Code[20];
        PostedSalesInvoiceNo: Code[20];
    begin
        SalesInvoiceNo := CreateSalesInvoiceWithItemCharges(CustomerNo, ItemNo, ItemChargeNo);
        PostedSalesInvoiceNo := PostSalesInvoiceWithItemCharges(SalesInvoiceNo, false);
        Commit;
        PostedSalesCreditMemoNo := CancelSalesInvoiceWithItemCharges(PostedSalesInvoiceNo, false);
    end;

    local procedure CreateSalesInvoiceWithItemCharges(CustomerNo: Code[20]; ItemNo: Code[20]; ItemChargeNo: Code[20]) SalesInvoiceNo: Code[20]
    var
        SalesLine: Record "Sales Line";
        SalesInvoice: TestPage "Sales Invoice";
    begin
        SalesInvoice.OpenNew;
        SalesInvoice."Sell-to Customer Name".SetValue(CustomerNo);

        CreateSalesInvoiceLine(
          SalesInvoice, Format(SalesLine.Type::Item), ItemNo, LibraryRandom.RandIntInRange(1, 10), LibraryRandom.RandDecInRange(1, 1000, 2));
        CreateSalesInvoiceLine(
          SalesInvoice, Format(SalesLine.Type::"Charge (Item)"), ItemChargeNo, LibraryRandom.RandIntInRange(1, 10),
          LibraryRandom.RandDecInRange(1, 1000, 2));

        SalesInvoice.SalesLines."Item Charge &Assignment".Invoke; // ITEM CHARGE ASSIGNMENT
        SalesInvoiceNo := SalesInvoice."No.".Value;
        SalesInvoice.OK.Invoke;
    end;

    local procedure CreateSalesInvoiceLine(var SalesInvoice: TestPage "Sales Invoice"; Type: Text; No: Code[20]; Quantity: Integer; UnitPrice: Decimal)
    begin
        SalesInvoice.SalesLines.New;
        SalesInvoice.SalesLines.FilteredTypeField.SetValue(Type);
        SalesInvoice.SalesLines."No.".SetValue(No);
        SalesInvoice.SalesLines.Quantity.SetValue(Quantity);
        SalesInvoice.SalesLines."Unit Price".SetValue(UnitPrice);
    end;

    local procedure PostSalesInvoiceWithItemCharges(SalesInvoiceNo: Code[20]; ExpectedFailure: Boolean) PostedSalesInvoiceNo: Code[20]
    var
        SalesHeader: Record "Sales Header";
        SalesInvoice: TestPage "Sales Invoice";
    begin
        SalesInvoice.OpenEdit;
        SalesInvoice.GotoKey(SalesHeader."Document Type"::Invoice, SalesInvoiceNo);
        SalesInvoice.Post.Invoke;
        if not ExpectedFailure then
            PostedSalesInvoiceNo := CopyStr(LibraryVariableStorage.DequeueText, 1, MaxStrLen(PostedSalesInvoiceNo));
    end;

    local procedure CancelSalesInvoiceWithItemCharges(PostedInvoiceNo: Code[20]; ExpectedFailure: Boolean) PostedSalesCreditMemoNo: Code[20]
    var
        PostedSalesInvoice: TestPage "Posted Sales Invoice";
    begin
        PostedSalesInvoice.OpenEdit;
        PostedSalesInvoice.GotoKey(PostedInvoiceNo);
        PostedSalesInvoice.CancelInvoice.Invoke;
        if not ExpectedFailure then
            PostedSalesCreditMemoNo := CopyStr(LibraryVariableStorage.DequeueText, 1, MaxStrLen(PostedSalesCreditMemoNo));
    end;

    local procedure VerifyVendorLedgerEntries(PostedCreditMemoNo: Code[20])
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DetailedVendorLedgEntries: TestPage "Detailed Vendor Ledg. Entries";
        TotalAmount: Decimal;
        LineAmount: Decimal;
    begin
        DetailedVendorLedgEntries.OpenView;
        DetailedVendorLedgEntries.FILTER.SetFilter("Entry Type", Format(DetailedVendorLedgEntry."Entry Type"::Application));
        DetailedVendorLedgEntries.FILTER.SetFilter("Document Type", Format(DetailedVendorLedgEntry."Document Type"::"Credit Memo"));
        DetailedVendorLedgEntries.FILTER.SetFilter("Document No.", PostedCreditMemoNo);
        Assert.IsTrue(DetailedVendorLedgEntries.First, 'No Vendor Ledger Entries Found');
        repeat
            Assert.IsTrue(Evaluate(LineAmount, DetailedVendorLedgEntries.Amount.Value), 'Evaluate Failed On Amount');
            TotalAmount += LineAmount;
        until not DetailedVendorLedgEntries.Next;

        Assert.AreEqual(0, TotalAmount, 'The Ledger Entries Total Amount Should Always Be 0');
    end;

    local procedure VerifyCustLedgerEntries(PostedCreditMemoNo: Code[20])
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntries: TestPage "Detailed Cust. Ledg. Entries";
        TotalAmount: Decimal;
        LineAmount: Decimal;
    begin
        DetailedCustLedgEntries.OpenView;
        DetailedCustLedgEntries.FILTER.SetFilter("Entry Type", Format(DetailedCustLedgEntry."Entry Type"::Application));
        DetailedCustLedgEntries.FILTER.SetFilter("Document Type", Format(DetailedCustLedgEntry."Document Type"::"Credit Memo"));
        DetailedCustLedgEntries.FILTER.SetFilter("Document No.", PostedCreditMemoNo);
        Assert.IsTrue(DetailedCustLedgEntries.First, 'No Vendor Ledger Entries Found');
        repeat
            Assert.IsTrue(Evaluate(LineAmount, DetailedCustLedgEntries.Amount.Value), 'Evaluate Failed On Amount');
            TotalAmount += LineAmount;
        until not DetailedCustLedgEntries.Next;

        Assert.AreEqual(0, TotalAmount, 'The Ledger Entries Total Amount Should Always Be 0');
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure ItemChargeAssignmentPurchModalPageHandler(var ItemChargeAssignmentPurch: TestPage "Item Charge Assignment (Purch)")
    begin
        ItemChargeAssignmentPurch.SuggestItemChargeAssignment.Invoke;
        ItemChargeAssignmentPurch.OK.Invoke;
    end;

    [PageHandler]
    [Scope('OnPrem')]
    procedure PostedPurchaseInvoicePageHandler(var PostedPurchaseInvoice: TestPage "Posted Purchase Invoice")
    begin
        LibraryVariableStorage.Enqueue(PostedPurchaseInvoice."No.".Value);
        PostedPurchaseInvoice.Close;
    end;

    [PageHandler]
    [Scope('OnPrem')]
    procedure PostedPurchaseCreditMemoHandler(var PostedPurchaseCreditMemo: TestPage "Posted Purchase Credit Memo")
    begin
        LibraryVariableStorage.Enqueue(PostedPurchaseCreditMemo."No.".Value);
        PostedPurchaseCreditMemo.Close;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure ItemChargeAssignmentSalesModalPageHandler(var ItemChargeAssignmentSales: TestPage "Item Charge Assignment (Sales)")
    begin
        ItemChargeAssignmentSales.SuggestItemChargeAssignment.Invoke;
        ItemChargeAssignmentSales.OK.Invoke;
    end;

    [PageHandler]
    [Scope('OnPrem')]
    procedure PostedSalesInvoicePageHandler(var PostedSalesInvoice: TestPage "Posted Sales Invoice")
    begin
        LibraryVariableStorage.Enqueue(PostedSalesInvoice."No.".Value);
        PostedSalesInvoice.Close;
    end;

    [PageHandler]
    [Scope('OnPrem')]
    procedure PostedSalesCreditMemoHandler(var PostedSalesCreditMemo: TestPage "Posted Sales Credit Memo")
    begin
        LibraryVariableStorage.Enqueue(PostedSalesCreditMemo."No.".Value);
        PostedSalesCreditMemo.Close;
    end;

    local procedure CreateItemFromVendor(var VendorNo: Code[20]; TempVendor: Record Vendor temporary) ItemNo: Code[20]
    begin
        VendorNo := CreateVendor(TempVendor);
        ItemNo := CreateItem(VendorNo);
    end;

    local procedure CreateVendor(TempVendorDetails: Record Vendor temporary) VendorNo: Code[20]
    var
        Vendor: Record Vendor;
        VendorCard: TestPage "Vendor Card";
        VendorName: Text[100];
    begin
        VendorName := CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Vendor.Name)), 1, MaxStrLen(Vendor.Name));
        LibraryVariableStorage.Enqueue('VENDOR');
        VendorCard.OpenNew;
        VendorCard.Name.SetValue(VendorName);
        VendorCard."Gen. Bus. Posting Group".SetValue(TempVendorDetails."Gen. Bus. Posting Group");
        VendorCard."VAT Bus. Posting Group".SetValue(TempVendorDetails."VAT Bus. Posting Group");
        VendorCard."Vendor Posting Group".SetValue(TempVendorDetails."Vendor Posting Group");
        VendorNo := VendorCard."No.".Value;
        VendorCard.OK.Invoke;
    end;

    local procedure CreateCustomer(TempCustomerDetails: Record Customer temporary) CustomerNo: Code[20]
    var
        Customer: Record Customer;
        CustomerCard: TestPage "Customer Card";
        CustomerName: Text[100];
    begin
        CustomerName := CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Customer.Name)), 1, MaxStrLen(Customer.Name));
        LibraryVariableStorage.Enqueue('CUSTOMER');
        CustomerCard.OpenNew;
        CustomerCard.Name.SetValue(CustomerName);
        CustomerCard."Gen. Bus. Posting Group".SetValue(TempCustomerDetails."Gen. Bus. Posting Group");
        CustomerCard."VAT Bus. Posting Group".SetValue(TempCustomerDetails."VAT Bus. Posting Group");
        CustomerCard."Customer Posting Group".SetValue(TempCustomerDetails."Customer Posting Group");
        CustomerNo := CustomerCard."No.".Value;
        CustomerCard.OK.Invoke;
    end;

    local procedure CreateItem(VendorNo: Code[20]) ItemNo: Code[20]
    var
        GeneralPostingSetup: Record "General Posting Setup";
        Item: Record Item;
        VATPostingSetup: Record "VAT Posting Setup";
        ItemCard: TestPage "Item Card";
        UnitCost: Decimal;
        Description: Text[100];
    begin
        UnitCost := LibraryRandom.RandDec(100, 2);
        Description := CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Item.Description)), 1, MaxStrLen(Item.Description));
        LibraryVariableStorage.Enqueue('ITEM');
        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);

        ItemCard.OpenNew;
        ItemCard.Description.SetValue(Description);
        ItemCard."Unit Price".SetValue(UnitCost + LibraryRandom.RandDec(100, 2));
        ItemCard."Unit Cost".SetValue(UnitCost);
        ItemCard."Vendor No.".SetValue(VendorNo);
        ItemCard."Gen. Prod. Posting Group".SetValue(GeneralPostingSetup."Gen. Prod. Posting Group");
        if ApplicationAreaMgmtFacade.IsVATEnabled then begin
            LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);
            ItemCard."VAT Prod. Posting Group".SetValue(VATPostingSetup."VAT Prod. Posting Group");
        end;
        ItemNo := ItemCard."No.".Value;
        ItemCard.OK.Invoke;
    end;

    local procedure CreateItemCharge() ItemChargeNo: Code[20]
    var
        ItemCharge: Record "Item Charge";
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        ItemCharges: TestPage "Item Charges";
        Description: Text[100];
    begin
        ItemChargeNo := LibraryUtility.GenerateRandomCode(ItemCharge.FieldNo("No."), DATABASE::"Item Charge");
        Description := CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(ItemCharge.Description)), 1, MaxStrLen(ItemCharge.Description));
        LibraryERM.FindGeneralPostingSetupInvtBase(GeneralPostingSetup);
        LibraryERM.FindZeroVATPostingSetup(VATPostingSetup, VATPostingSetup."VAT Calculation Type"::"Normal VAT");

        ItemCharges.OpenEdit;
        ItemCharges.New;
        ItemCharges."No.".SetValue(ItemChargeNo);
        ItemCharges.Description.SetValue(Description);
        ItemCharges."Gen. Prod. Posting Group".SetValue(GeneralPostingSetup."Gen. Prod. Posting Group");
        if ApplicationAreaMgmtFacade.IsVATEnabled then
            ItemCharges."VAT Prod. Posting Group".SetValue(VATPostingSetup."VAT Prod. Posting Group");
        ItemCharges.OK.Invoke;
    end;

    local procedure FindVendorPostingAndVATSetup(var TempVendorDetails: Record Vendor temporary)
    begin
        TempVendorDetails.Init;
        FindBusPostingGroups(TempVendorDetails."Gen. Bus. Posting Group", TempVendorDetails."VAT Bus. Posting Group");
        TempVendorDetails."Vendor Posting Group" := LibraryPurchase.FindVendorPostingGroup;
    end;

    local procedure FindCustomerPostingAndVATSetup(var TempCustomerDetails: Record Customer temporary)
    begin
        TempCustomerDetails.Init;
        FindBusPostingGroups(TempCustomerDetails."Gen. Bus. Posting Group", TempCustomerDetails."VAT Bus. Posting Group");
        TempCustomerDetails."Customer Posting Group" := LibrarySales.FindCustomerPostingGroup;
    end;

    local procedure FindBusPostingGroups(var GenBusPostingGroup: Code[20]; var VATBusPostingGroup: Code[20])
    var
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);
        GenBusPostingGroup := GeneralPostingSetup."Gen. Bus. Posting Group";

        LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);
        VATBusPostingGroup := VATPostingSetup."VAT Bus. Posting Group";
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure ConfigTemplatesModalPageHandler(var ConfigTemplates: TestPage "Config Templates")
    var
        Type: Text;
    begin
        Type := LibraryVariableStorage.DequeueText;
        if (Type = 'CUSTOMER') or (Type = 'VENDOR') then
            ConfigTemplates.First
        else
            ConfigTemplates.Last;

        ConfigTemplates.OK.Invoke;
    end;

    [ConfirmHandler]
    [Scope('OnPrem')]
    procedure ConfirmHandlerYes(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;
}

