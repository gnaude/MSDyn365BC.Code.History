codeunit 142082 "UT REP Purchase Payables"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Purchase] [Reports]
    end;

    var
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryUTUtility: Codeunit "Library UT Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryRandom: Codeunit "Library - Random";

    [Test]
    [HandlerFunctions('AgedAccountsPayableRequestPageHandler')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure AgedAccountPayableAmountDueForSomeVendors()
    var
        VendorLedgerEntry: array[4] of Record "Vendor Ledger Entry";
    begin
        // [SCENARIO 285677] Run report 10085 - Aged Accounts Payable for four vendors with diferent due date
        Initialize();

        // [GIVEN] Vendor Ledger Entry on 23-02-20 with amount "A1" for "Vend1"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[1], CreateVendor(), CalcDate('<+30D>', WorkDate()) + 1, -1);
        // [GIVEN] Vendor Ledger Entry on 23-01-20 with amount "A2" for "Vend2"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[2], CreateVendor(), WorkDate(), -1);
        // [GIVEN] Vendor Ledger Entry on 23-12-19 with amount "A3" for "Vend3"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[3], CreateVendor(), CalcDate('<-30D>', WorkDate()) - 1, -1);
        // [GIVEN] Vendor Ledger Entry on 23-01-20 with amount "A4" for "Vend4"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[4], CreateVendor(), WorkDate(), -1);

        LibraryVariableStorage.Enqueue(CalcDate('<+30D>', WorkDate()) + 1);
        LibraryVariableStorage.Enqueue(
          LibraryVariableStorage.DequeueText() + '|' + LibraryVariableStorage.DequeueText() + '|' +
          LibraryVariableStorage.DequeueText() + '|' + LibraryVariableStorage.DequeueText());

        // [GIVEN] Report Period Dates 23-02-20/ 23-02-20/ 24-01-20/ 25-12-19
        // [WHEN] Run Aged Accounts Payable report on 01-03-21 with 30D as default reporting period, Aging Method = Due Date
        REPORT.Run(REPORT::"Aged Accounts Payable NA");  // Open AgedAccountsPayableRequestPageHandler.

        // [THEN] "Vend1" has AmountDue1 = "A1" whereas all other values of AmountDue are 0
        // [THEN] "Vend2" has AmountDue3 = "A2" whereas all other values of AmountDue are 0
        // [THEN] "Vend3" has AmountDue4 = "A3" whereas all other values of AmountDue are 0
        // [THEN] "Vend4" has AmountDue3 = "A4" whereas all other values of AmountDue are 0
        LibraryReportDataset.LoadDataSetFile();
        VerifyAmountDueForVendor(VendorLedgerEntry[1]."Document No.", -VendorLedgerEntry[1].Amount, 0, 0, 0);
        VerifyAmountDueForVendor(VendorLedgerEntry[2]."Document No.", 0, 0, -VendorLedgerEntry[2].Amount, 0);
        VerifyAmountDueForVendor(VendorLedgerEntry[3]."Document No.", 0, 0, 0, -VendorLedgerEntry[3].Amount);
        VerifyAmountDueForVendor(VendorLedgerEntry[4]."Document No.", 0, 0, -VendorLedgerEntry[4].Amount, 0);
    end;

    [Test]
    [HandlerFunctions('AgedAccountsPayablePrintDetailRequestPageHandler')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure AgedAccountPayableDetailedAmountDue()
    var
        VendorLedgerEntry: array[5] of Record "Vendor Ledger Entry";
        VendorNo: Code[20];
        PostingDate: Date;
    begin
        // [SCENARIO 285677] Run report 10085 - Aged Accounts Payable for vendor with entries of diferent due date
        Initialize();

        VendorNo := CreateVendor();
        PostingDate := CalcDate('<-4M>', WorkDate());
        // [GIVEN] Vendor Ledger Entry "V1" on 31-08-20 with amount "A1"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[1], VendorNo, PostingDate - 1, -1);

        // [GIVEN] Vendor Ledger Entry "V2" on 30-09-20 with amount "A2"
        PostingDate := CalcDate('<30D>', PostingDate);
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[2], VendorNo, PostingDate - 1, -1);

        // [GIVEN] Vendor Ledger Entry "V3" on 30-10-20 with amount "A3"
        PostingDate := CalcDate('<30D>', PostingDate);
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[3], VendorNo, PostingDate - 1, -1);

        // [GIVEN] Vendor Ledger Entry "V4" on 29-11-20 with amount "A4"
        PostingDate := CalcDate('<30D>', PostingDate);
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[4], VendorNo, PostingDate - 1, -1);

        // [GIVEN] Vendor Ledger Entry "V5" on 31-08-20 with amount "A5"
        CreateVendorLedgerEntryWithDetailed(VendorLedgerEntry[5], VendorNo, CalcDate('<-4M>', WorkDate()) - 1, 1); // positive entry for sorting

        LibraryVariableStorage.Enqueue(PostingDate);
        LibraryVariableStorage.Enqueue(
          LibraryVariableStorage.DequeueText() + '|' + LibraryVariableStorage.DequeueText() + '|' +
          LibraryVariableStorage.DequeueText() + '|' + LibraryVariableStorage.DequeueText() + '|' + LibraryVariableStorage.DequeueText());

        // [GIVEN] Report Period Dates 30-11-20/ 31-10-20/ 01-10-20/ 01-09-20
        // [WHEN] Run detailed Aged Accounts Payable report on 01-03-21 with 30D as default reporting period, Aging Method = Trans Date
        REPORT.Run(REPORT::"Aged Accounts Payable NA");  // Open PrintDetailAgedAccountsPayableRequestPageHandler.

        // [THEN] "V1" has AmountDue4 = "A1" whereas all other values of AmountDue are 0
        // [THEN] "V2" has AmountDue3 = "A2" whereas all other values of AmountDue are 0
        // [THEN] "V3" has AmountDue2 = "A3" whereas all other values of AmountDue are 0
        // [THEN] "V4" has AmountDue1 = "A4" whereas all other values of AmountDue are 0
        // [THEN] "V5" has AmountDue4 = "A5" whereas all other values of AmountDue are 0
        LibraryReportDataset.LoadDataSetFile();
        VerifyAmountDueForVendor(VendorLedgerEntry[1]."Document No.", 0, 0, 0, -VendorLedgerEntry[1].Amount);
        VerifyAmountDueForVendor(VendorLedgerEntry[2]."Document No.", 0, 0, -VendorLedgerEntry[2].Amount, 0);
        VerifyAmountDueForVendor(VendorLedgerEntry[3]."Document No.", 0, -VendorLedgerEntry[3].Amount, 0, 0);
        VerifyAmountDueForVendor(VendorLedgerEntry[4]."Document No.", -VendorLedgerEntry[4].Amount, 0, 0, 0);
        VerifyAmountDueForVendor(VendorLedgerEntry[5]."Document No.", 0, 0, 0, -VendorLedgerEntry[5].Amount);
    end;

    local procedure Initialize()
    begin
        LibraryVariableStorage.Clear();
    end;

    local procedure CreateVendor(): Code[20]
    var
        Vendor: Record Vendor;
    begin
        Vendor."No." := LibraryUTUtility.GetNewCode();
        Vendor.Insert();
        exit(Vendor."No.");
    end;

    local procedure CreateVendorLedgerEntryOnDate(var VendorLedgerEntry: Record "Vendor Ledger Entry"; VendorNo: Code[20]; PostingDate: Date)
    begin
        VendorLedgerEntry."Entry No." :=
          LibraryUtility.GetNewRecNo(VendorLedgerEntry, VendorLedgerEntry.FieldNo("Entry No."));
        VendorLedgerEntry."Vendor No." := VendorNo;
        VendorLedgerEntry."Document No." := LibraryUTUtility.GetNewCode();
        VendorLedgerEntry."Posting Date" := PostingDate;
        VendorLedgerEntry."Due Date" := PostingDate;
        VendorLedgerEntry.Open := true;
        VendorLedgerEntry.Insert();
        LibraryVariableStorage.Enqueue(VendorLedgerEntry."Vendor No.");  // Enqueue required for OpenVendorListingRequestPage.
    end;

    local procedure CreateDetailedVendorLedgerEntryOnDate(VendorLedgerEntryNo: Integer; VendorNo: Code[20]; PostingDate: Date; EntryAmount: Decimal)
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DetailedVendorLedgEntry."Entry No." :=
          LibraryUtility.GetNewRecNo(DetailedVendorLedgEntry, DetailedVendorLedgEntry.FieldNo("Entry No."));
        DetailedVendorLedgEntry."Vendor Ledger Entry No." := VendorLedgerEntryNo;
        DetailedVendorLedgEntry.Amount := EntryAmount;
        DetailedVendorLedgEntry."Amount (LCY)" := DetailedVendorLedgEntry.Amount;
        DetailedVendorLedgEntry."Posting Date" := PostingDate;
        DetailedVendorLedgEntry."Vendor No." := VendorNo;
        DetailedVendorLedgEntry.Insert(true);
    end;

    local procedure CreateVendorLedgerEntryWithDetailed(var VendorLedgerEntry: Record "Vendor Ledger Entry"; VendorNo: Code[20]; PostingDate: Date; Sign: Integer)
    begin
        CreateVendorLedgerEntryOnDate(VendorLedgerEntry, VendorNo, PostingDate);
        CreateDetailedVendorLedgerEntryOnDate(
          VendorLedgerEntry."Entry No.", VendorLedgerEntry."Vendor No.", PostingDate, Sign * LibraryRandom.RandDec(10, 2));
        VendorLedgerEntry.CalcFields(Amount);
    end;

    local procedure VerifyAmountDueForVendor(DocumentNo: Code[20]; AmountDue1: Decimal; AmountDue2: Decimal; AmountDue3: Decimal; AmountDue4: Decimal)
    begin
        LibraryReportDataset.SetRange('DocNo', DocumentNo);
        LibraryReportDataset.GetNextRow();
        LibraryReportDataset.AssertCurrentRowValueEquals('AmountDue_1_', AmountDue1);
        LibraryReportDataset.AssertCurrentRowValueEquals('AmountDue_2_', AmountDue2);
        LibraryReportDataset.AssertCurrentRowValueEquals('AmountDue_3_', AmountDue3);
        LibraryReportDataset.AssertCurrentRowValueEquals('AmountDue_4_', AmountDue4);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure AgedAccountsPayablePrintDetailRequestPageHandler(var AgedAccountsPayable: TestRequestPage "Aged Accounts Payable NA")
    begin
        AgedAccountsPayable.AgedAsOf.SetValue(LibraryVariableStorage.DequeueDate());
        AgedAccountsPayable.PrintDetailControl.SetValue(true);
        AgedAccountsPayable.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText());
        AgedAccountsPayable.AgingMethodControl.SetValue(1);
        AgedAccountsPayable.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure AgedAccountsPayableRequestPageHandler(var AgedAccountsPayable: TestRequestPage "Aged Accounts Payable NA")
    begin
        AgedAccountsPayable.AgedAsOf.SetValue(LibraryVariableStorage.DequeueDate());
        AgedAccountsPayable.PrintDetailControl.SetValue(false);
        AgedAccountsPayable.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText());
        AgedAccountsPayable.AgingMethodControl.SetValue(0);
        AgedAccountsPayable.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;
}
