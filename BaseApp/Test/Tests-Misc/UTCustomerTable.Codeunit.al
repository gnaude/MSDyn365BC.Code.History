codeunit 134825 "UT Customer Table"
{
    Subtype = Test;
    TestPermissions = NonRestrictive;

    trigger OnRun()
    begin
        // [FEATURE] [Customer] [Find Customer] [UT]
    end;

    var
        Assert: Codeunit Assert;
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        CustNotRegisteredTxt: Label 'This customer is not registered. To continue, choose one of the following options:';
        YouMustSelectCustomerErr: Label 'You must select an existing customer.';
        CustomerNameWithFilterCharsTxt: Label '&C*u|s(t''o)m)e&r*';
        DummyValueForAddressTxt: Label 'Dummy address';
        LibraryERM: Codeunit "Library - ERM";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        LibraryRandom: Codeunit "Library - Random";
        isInitialized: Boolean;
        SalesDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        DeleteCustomerSalesDocExistsErr: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
        DialogErr: Label 'Dialog';
        PhoneNoCannotContainLettersErr: Label '%1 must not contain letters in %2 %3=''%4''.';

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByExactNo()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);

        CreateCustomerFromNo(Customer1, RandomText1);
        CreateCustomerFromNo(Customer2, RandomText1 + RandomText2);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer1."No.", Customer1.GetCustNo(RandomText1), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByStartNo()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2 - 1);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);

        CreateCustomerFromNo(Customer1, RandomText1);
        CreateCustomerFromNo(Customer2, RandomText1 + RandomText2);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer1."No.", Customer1.GetCustNo(CopyStr(RandomText1, 1, 8)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartNo()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2 - 2);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);

        CreateCustomerFromNo(Customer1, RandomText1);
        CreateCustomerFromNo(Customer2, RandomText1 + RandomText2);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer2."No.", Customer2.GetCustNo(CopyStr(RandomText2, 2, 8)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByExactName()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);

        CreateCustomerFromName(Customer1, RandomText1 + RandomText2);
        CreateCustomerFromName(Customer2, RandomText1);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer2."No.", Customer2.GetCustNo(RandomText1), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByStartOfName()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);

        CreateCustomerFromName(Customer1, RandomText1 + RandomText2);
        CreateCustomerFromName(Customer2, RandomText1);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer2."No.", Customer1.GetCustNo(CopyStr(RandomText1, 1, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfName()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1.Name) / 2);

        CreateCustomerFromName(Customer1, RandomText1 + RandomText2);
        CreateCustomerFromName(Customer2, RandomText1);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer1."No.", Customer1.GetCustNo(CopyStr(RandomText2, 5, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfCity()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate(City, LibraryUtility.GenerateRandomText(MaxStrLen(Customer.City)));
        Customer.Modify(true);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer."No.", Customer.GetCustNo(CopyStr(Customer.City, 5, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfContact()
    var
        Customer: Record Customer;
        RandomText: Text;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        RandomText := LibraryUtility.GenerateRandomText(MaxStrLen(Customer.Contact) / 2 - 1);
        Customer.Validate(Contact, CopyStr(RandomText + '  ' + RandomText, 1, MaxStrLen(Customer.Contact)));
        Customer.Modify(true);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer."No.", Customer.GetCustNo(CopyStr(Customer.Contact, 5, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfPhoneNo()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate("Phone No.", Format(LibraryRandom.RandIntInRange(100000000, 999999999)));
        Customer.Modify(true);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer."No.", Customer.GetCustNo(CopyStr(Customer."Phone No.", 5, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfPostCode()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate("Post Code", LibraryUtility.GenerateRandomText(MaxStrLen(Customer."Post Code")));
        Customer.Modify(true);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer."No.", Customer.GetCustNo(CopyStr(Customer."Post Code", 5, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByPartOfNameIncludingFilterChars()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        CreateCustomerFromName(Customer, CustomerNameWithFilterCharsTxt);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer."No.", Customer.GetCustNo(CustomerNameWithFilterCharsTxt), 'Customer not found');
    end;

    [Test]
    [HandlerFunctions('CustomerNotRegisteredStrMenuHandlerCancel')]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByNoInputOverflow()
    var
        Customer: Record Customer;
    begin
        Initialize;
        // Offset the random
        LibraryUtility.GenerateRandomText(1);

        // Setup
        CreateCustomerFromNo(Customer, LibraryUtility.GenerateRandomText(MaxStrLen(Customer."No.")));

        // Exercise
        asserterror Customer.GetCustNo(Customer."No." + 'Extra Text');
        Assert.ExpectedError(YouMustSelectCustomerErr);
    end;

    [Test]
    [HandlerFunctions('CustomerNotRegisteredStrMenuHandlerCancel')]
    [Scope('OnPrem')]
    procedure TestGetCustNoPromptCreateCustomer()
    var
        Customer: Record Customer;
        NoneExixtingCustomerNo: Code[20];
    begin
        Initialize;

        // Setup
        NoneExixtingCustomerNo := LibrarySales.CreateCustomerNo;
        Customer.Get(NoneExixtingCustomerNo);
        Customer.Delete();

        // Exercise and Verify None Existing Customer
        asserterror Customer.GetCustNo(NoneExixtingCustomerNo);
        Assert.ExpectedError(YouMustSelectCustomerErr);
        // Confirm handler will verify the confirm and skip creation of customer
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForAddress()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.Address := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForAddress2()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer."Address 2" := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForCity()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.City := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForCounty()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.County := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForPostCode()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer."Post Code" := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestHasAddressForContact()
    var
        Customer: Record Customer;
    begin
        Initialize;

        // Setup
        LibrarySales.CreateCustomer(Customer);
        Customer.Contact := DummyValueForAddressTxt;

        // Exercise
        Assert.IsTrue(Customer.HasAddress, 'The customer should have an address');
    end;

    [Test]
    [HandlerFunctions('CancelSelectionOfCustomerFromCustomerListModalPageHandler')]
    [Scope('OnPrem')]
    procedure TestGetCustNoPromptPickCustomer()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2 - 3);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);

        CreateCustomerFromNo(Customer1, RandomText1);
        CreateCustomerFromNo(Customer2, RandomText1 + RandomText2);

        // Exercise and Verify Existing Customer
        asserterror Customer1.GetCustNo(CopyStr(RandomText1, 2, 10));
        Assert.ExpectedError(YouMustSelectCustomerErr);
        // Confirm handler will verify the customer list opens and cancel selection of customer
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure CancelSelectionOfCustomerFromCustomerListModalPageHandler(var CustomerList: TestPage "Customer List")
    begin
        CustomerList.Cancel.Invoke;
    end;

    [Test]
    [HandlerFunctions('SelectionFirstCustomerFromCustomerListModalPageHandler')]
    [Scope('OnPrem')]
    procedure TestGetCustNoSelectCustomerFromPickCustomer()
    var
        Customer1: Record Customer;
        Customer2: Record Customer;
        RandomText1: Text;
        RandomText2: Text;
    begin
        Initialize;

        // Setup
        RandomText1 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2 - 3);
        RandomText2 := LibraryUtility.GenerateRandomText(MaxStrLen(Customer1."No.") / 2);

        CreateCustomerFromNo(Customer1, RandomText1);
        CreateCustomerFromNo(Customer2, RandomText1 + RandomText2);

        // Exercise and Verify Existing Customer
        Assert.AreEqual(Customer1."No.", Customer1.GetCustNo(CopyStr(RandomText1, 2, 10)), 'Customer not found');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerValidateContactWithEmptyBusRelationCode()
    var
        MarketingSetup: Record "Marketing Setup";
        Customer: Record Customer;
        ExpectedContact: Text[50];
        ExpectedPrimaryContactNo: Code[20];
    begin
        // [FEATURE] [Contact] [Marketing Setup]
        // [SCENARIO 231916] When "Bus. Relation Code" is empty in Marketing Setup and random text is inserted into Customer Contact field then "Primary Contact No." and Contact fields are not cleared.
        Initialize;
        ExpectedPrimaryContactNo := LibraryUtility.GenerateGUID;

        // [GIVEN] "Bus. Relation Code" = '' in Marketing Setup
        MarketingSetup.Validate("Bus. Rel. Code for Customers", '');
        MarketingSetup.Modify(true);

        // [GIVEN] Customer with empty Contact field and "YY" in "Primary Contact No." field.
        LibrarySales.CreateCustomer(Customer);
        Customer."Primary Contact No." := ExpectedPrimaryContactNo;
        Customer.Contact := '';
        Customer.Modify();

        // [GIVEN] Text[50] = "XX"
        ExpectedContact := CopyStr(LibraryUtility.GenerateRandomText(50), 1, 50);

        // [WHEN] Update Contact field with "XX" value
        Customer.Validate(Contact, ExpectedContact);

        // [THEN] Contact = "XX"
        Customer.TestField(Contact, ExpectedContact);

        // [THEN] "Primary Contact No." = "YY"
        Customer.TestField("Primary Contact No.", ExpectedPrimaryContactNo);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenInvoiceExists()
    begin
        // [FEATURE] [Sales] [Invoice]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Invoice.
        Initialize;

        // [GIVEN] Sales Invoice for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Invoice for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::Invoice);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenQuoteExists()
    begin
        // [FEATURE] [Sales] [Quote]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Quote.
        Initialize;

        // [GIVEN] Sales Quote for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Quote for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::Quote);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenCreditMemoExists()
    begin
        // [FEATURE] [Sales] [Credit Memo]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Credit Memo.
        Initialize;

        // [GIVEN] Sales Credit Memo for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Credit Memo for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::"Credit Memo");
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenOrderExists()
    begin
        // [FEATURE] [Sales] [Order]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Order.
        Initialize;

        // [GIVEN] Sales Order for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Order for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::Order);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenReturnOrderExists()
    begin
        // [FEATURE] [Sales] [Return Order]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Return Order.
        Initialize;

        // [GIVEN] Sales Return Order for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Return Order for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::"Return Order");
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestCustomerDeleteErrorWhenBlanketOrderExists()
    begin
        // [FEATURE] [Sales] [Blanket Order]
        // [SCENARIO 235731] The error is shown when trying to delete Customer with outstanding Sales Blanket Order.
        Initialize;

        // [GIVEN] Sales Blanket Order for Customer "C"
        // [WHEN] Trying to delete "C"
        // [THEN] Error is shown: 'You cannot delete Customer "C" because there is at least one outstanding Sales Blanket Order for this customer.'
        ErrorOnDeleteCustomerIfOutstandingDocExists(SalesDocumentType::"Blanket Order");
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestPhoneNoValidation()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO 321935] The error is shown when trying to enter letters in the Phone No. field.
        Initialize;

        // [GIVEN] Created a Customer
        LibrarySales.CreateCustomer(Customer);

        // [WHEN] Trying to enter letters in the Phone No. field
        asserterror Customer.Validate("Phone No.", LibraryUtility.GenerateRandomAlphabeticText(MaxStrLen(Customer."Phone No."), 1));

        // [THEN] Error is shown: 'Phone No. must not contain letters in Customer  No.=..'
        Assert.ExpectedError(
          StrSubstNo(
            PhoneNoCannotContainLettersErr, Customer.FieldCaption("Phone No."), Customer.TableCaption,
            Customer.FieldCaption("No."), Customer."No."));
        Assert.ExpectedErrorCode('NCLCSRTS:TableErrorStr');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure TestGetCustNoGetCustomerByName_CaseSensitive_Blocked()
    var
        Customer: array[4] of Record Customer;
        RandomText1: Text[100];
        RandomText2: Text[100];
    begin
        Initialize;

        RandomText1 := 'aaa';
        RandomText2 := 'AAA';

        CreateCustomerFromNameAndBlocked(Customer[1], RandomText1, Customer[1].Blocked::All);
        CreateCustomerFromNameAndBlocked(Customer[2], RandomText1, Customer[2].Blocked::" ");
        CreateCustomerFromNameAndBlocked(Customer[3], RandomText2, Customer[3].Blocked::All);
        CreateCustomerFromNameAndBlocked(Customer[4], RandomText2, Customer[4].Blocked::" ");

        Assert.AreEqual(Customer[2]."No.", Customer[1].GetCustNo(RandomText1), '');
        Assert.AreEqual(Customer[2]."No.", Customer[1].GetCustNo(RandomText2), '');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldMultipleEmailAddressesWithSemicolon()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it contains multiple e-mail addresses, separated by ;

        // [WHEN] Validate E-Mail field of Customer table, when it contains multiple email addresses in cases, separated by ;
        Customer.Validate("E-Mail", 'test1@test.com; test2@test.com; test3@test.com');

        // [THEN] String is validated without errors.
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldOnEmptyEmailAddress()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it's empty.

        // [WHEN] Validate E-Mail field of Customer table on empty value.
        Customer.Validate("E-Mail", '');

        // [THEN] String is validated without errors.
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldMultipleEmailAddressesWithComma()
    var
        Customer: Record Customer;
        MultipleAddressesTxt: Text;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it contains multiple e-mail addresses, separated by ,
        MultipleAddressesTxt := 'test1@test.com, test2@test.com, test3@test.com';

        // [WHEN] Validate E-Mail field of Customer table, when it contains multiple email addresses, separated by ,
        asserterror Customer.Validate("E-Mail", MultipleAddressesTxt);

        // [THEN] The error "The email address is not valid." is thrown.
        Assert.ExpectedError(StrSubstNo('The email address "%1" is not valid.', MultipleAddressesTxt));
        Assert.ExpectedErrorCode('Dialog');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldMultipleEmailAddressesWithVerticalBar()
    var
        Customer: Record Customer;
        MultipleAddressesTxt: Text;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it contains multiple e-mail addresses, separated by |
        MultipleAddressesTxt := 'test1@test.com| test2@test.com| test3@test.com';

        // [WHEN] Validate E-Mail field of Customer table, when it contains multiple email addresses, separated by |
        asserterror Customer.Validate("E-Mail", MultipleAddressesTxt);

        // [THEN] The error "The email address is not valid." is thrown.
        Assert.ExpectedError(StrSubstNo('The email address "%1" is not valid.', MultipleAddressesTxt));
        Assert.ExpectedErrorCode('Dialog');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldMultipleEmailAddressesWithSpace()
    var
        Customer: Record Customer;
        MultipleAddressesTxt: Text;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it contains multiple e-mail addresses, separated by space.
        MultipleAddressesTxt := 'test1@test.com test2@test.com test3@test.com';

        // [WHEN] Validate E-Mail field of Customer table, when it contains multiple email addresses, separated by space.
        asserterror Customer.Validate("E-Mail", MultipleAddressesTxt);

        // [THEN] The error "The email address is not valid." is thrown.
        Assert.ExpectedError(StrSubstNo('The email address "%1" is not valid.', MultipleAddressesTxt));
        Assert.ExpectedErrorCode('Dialog');
    end;

    [Test]
    [Scope('OnPrem')]
    procedure ValidateEmailFieldMultipleEmailAddressesWithInvalidEmail()
    var
        Customer: Record Customer;
        MultipleAddressesTxt: Text;
    begin
        // [SCENARIO 341841] Validate E-Mail field of Customer table in case it contains multiple e-mail addresses; one of them is not valid.
        MultipleAddressesTxt := 'test1@test.com; test2.com; test3@test.com';

        // [WHEN] Validate E-Mail field of Customer table, when it contains multiple email addresses, one of them is not a valid email address.
        asserterror Customer.Validate("E-Mail", MultipleAddressesTxt);

        // [THEN] The error "The email address is not valid." is thrown.
        Assert.ExpectedError('The email address "test2.com" is not valid.');
        Assert.ExpectedErrorCode('Dialog');
    end;

    local procedure Initialize()
    var
        Customer: Record Customer;
        LibraryApplicationArea: Codeunit "Library - Application Area";
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"UT Customer Table");
        Customer.DeleteAll();
        LibraryApplicationArea.EnableFoundationSetup;
        LibrarySetupStorage.Restore;

        if isInitialized then
            exit;
        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"UT Customer Table");

        LibrarySetupStorage.Save(DATABASE::"Sales & Receivables Setup");
        LibrarySetupStorage.Save(DATABASE::"Marketing Setup");
        isInitialized := true;
        Commit();
        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"UT Customer Table");
    end;

    local procedure CreateSalesDocument(SalesDocumentType: Integer; CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesDocumentType, CustNo);
        LibrarySales.CreateSalesLine(
          SalesLine, SalesHeader, SalesLine.Type::"G/L Account", LibraryERM.CreateGLAccountWithSalesSetup, LibraryRandom.RandInt(10));
    end;

    local procedure CreateCustomerFromNo(var Customer: Record Customer; No: Text)
    begin
        Customer.Validate("No.", CopyStr(No, 1, MaxStrLen(Customer."No.")));
        Customer.Insert(true);
    end;

    local procedure CreateCustomerFromName(var Customer: Record Customer; Name: Text)
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate(Name, CopyStr(Name, 1, MaxStrLen(Customer.Name)));
        Customer.Modify(true);
    end;

    local procedure CreateCustomerFromNameAndBlocked(var Customer: Record Customer; Name: Text; CustomerBlocked: Option)
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate(Name, CopyStr(Name, 1, MaxStrLen(Customer.Name)));
        Customer.Validate(Blocked, CustomerBlocked);
        Customer.Modify(true);
    end;

    local procedure ErrorOnDeleteCustomerIfOutstandingDocExists(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    var
        Customer: Record Customer;
    begin
        UpdateSalesReceivablesSetupNoS;
        LibrarySales.CreateCustomer(Customer);
        CreateSalesDocument(DocType, Customer."No.");

        asserterror Customer.Delete(true);

        Assert.ExpectedError(
          StrSubstNo(
            DeleteCustomerSalesDocExistsErr, Customer.TableCaption, Customer."No.", DocType));

        Assert.ExpectedErrorCode(DialogErr);
    end;

    local procedure UpdateSalesReceivablesSetupNoS()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesReceivablesSetup do begin
            Validate("Quote Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Order Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Invoice Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Posted Invoice Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Return Order Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Credit Memo Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Posted Credit Memo Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Blanket Order Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Validate("Customer Nos.", LibraryUtility.GetGlobalNoSeriesCode);
            Modify(true);
        end;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure SelectionFirstCustomerFromCustomerListModalPageHandler(var CustomerList: TestPage "Customer List")
    begin
        CustomerList.OK.Invoke;
    end;

    [StrMenuHandler]
    [Scope('OnPrem')]
    procedure CustomerNotRegisteredStrMenuHandlerCancel(Options: Text; var Choice: Integer; Instruction: Text)
    begin
        Assert.ExpectedMessage(CustNotRegisteredTxt, Instruction);
        Choice := 0;
    end;
}

