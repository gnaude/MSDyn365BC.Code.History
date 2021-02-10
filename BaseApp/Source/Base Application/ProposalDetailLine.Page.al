page 11000002 "Proposal Detail Line"
{
    Caption = 'Proposal Detail Line';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Proposal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of account for which the proposal line will be created.';
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the account for which the proposal line will be created.';
                }
                field(Bank; Bank)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number for the bank you want to perform payments to, or collections from.';
                }
                field("Our Bank No."; "Our Bank No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of your bank through which you want to perform payments or collections.';
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amounts on the proposal line.';
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when you want the payment or collection to be performed.';
                }
                field("Transaction Mode"; "Transaction Mode")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the transaction mode used in telebanking.';
                }
                field("Order"; Order)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the order type of the proposal line.';
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the bank account number you want to perform payments to, or collections from.';
                }
                field("Our Bank Account No."; "Our Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank account used by the bank that you want to perform payments/collections.';
                }
                field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the direct debit mandate of the customer that this collection proposal is for.';
                }
            }
            part(Control2; "Detail Line Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Our Bank" = FIELD("Our Bank No."),
                              Status = CONST(Proposal),
                              "Connect Lines" = FIELD("Line No."),
                              "Account Type" = FIELD("Account Type");
                SubPageView = SORTING("Our Bank", Status, "Connect Batches", "Connect Lines", Date);
            }
            group(Remark)
            {
                Caption = 'Remark';
                field(Identification; Identification)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the identification number for the proposal line.';
                }
                field("Description 1"; "Description 1")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the proposal line.';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional description of the proposal line.';
                }
                field("Description 3"; "Description 3")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional description of the proposal line.';
                }
                field("Description 4"; "Description 4")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional description of the proposal line.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pr&oposal")
            {
                Caption = 'Pr&oposal';
                Image = SuggestElectronicDocument;
                action(Check)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Check';
                    Image = Check;
                    RunPageOnRec = false;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Validate the proposal line before you process it.';

                    trigger OnAction()
                    begin
                        ProcessingLines.Run(Rec);
                        ProcessingLines.CheckProposallines;
                    end;
                }
                action(Process)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Process';
                    Image = Setup;
                    ShortCutKey = 'F9';
                    ToolTip = 'Process the payment or collection proposals. After you processed a proposal, the proposal will be empty and the payments/collections will be posted to the payment history.';

                    trigger OnAction()
                    begin
                        ProcessingLines.Run(Rec);
                        ProcessingLines.ProcessProposallines;
                    end;
                }
                action(ToOtherBank)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Other Bank';
                    Image = ExportToBank;
                    ToolTip = 'Transfer the selected proposal to another bank account from where you want to process it. ';

                    trigger OnAction()
                    var
                        BankAcc: Record "Bank Account";
                        "Bank Account List": Page "Bank Account List";
                        Propline: Record "Proposal Line";
                    begin
                        BankAcc.Get("Our Bank No.");
                        "Bank Account List".SetRecord(BankAcc);
                        "Bank Account List".LookupMode(true);
                        if "Bank Account List".RunModal = ACTION::LookupOK then begin
                            "Bank Account List".GetRecord(BankAcc);
                            if BankAcc."No." <> "Our Bank No." then begin
                                BankAcc.TestField("Currency Code", "Currency Code");
                                if Confirm(StrSubstNo(Text1000000, TableCaption, "Our Bank No.", BankAcc."No.")) then begin
                                    Propline.SetCurrentKey("Our Bank No.");
                                    Propline.SetRange("Our Bank No.", BankAcc."No.");
                                    if Propline.FindLast then
                                        Rename(BankAcc."No.", Propline."Line No." + 10000)
                                    else
                                        Rename(BankAcc."No.", 10000);
                                end;
                            end;
                        end;
                    end;
                }
                action(UpdateDescriptions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Descriptions';
                    Image = UpdateDescription;
                    ToolTip = 'Update the descriptions with any changes made since you opened the window.';

                    trigger OnAction()
                    var
                        CompanyInfo: Record "Company Information";
                        Custm: Record Customer;
                        Vend: Record Vendor;
                        CustEntry: Record "Cust. Ledger Entry";
                        VenEntry: Record "Vendor Ledger Entry";
                        EmployeeLedgerEntry: Record "Employee Ledger Entry";
                        UseDocumentNo: Code[30];
                    begin
                        CurrPage.Update(true);
                        if not Docket then begin
                            "Detail line2".SetCurrentKey("Our Bank", Status, "Connect Batches", "Connect Lines", Date);
                            "Detail line2".SetRange("Our Bank", "Our Bank No.");
                            "Detail line2".SetFilter(Status, '%1', "Detail line".Status::Proposal);
                            "Detail line2".SetRange("Connect Lines", "Line No.");
                            "Detail line2".SetRange("Account Type", "Account Type");
                            if "Detail line2".Find('-') then begin
                                "Description 1" := Text1000001;
                                Clear("Description 2");
                                Clear("Description 3");
                                Clear("Description 4");
                                repeat
                                    case "Detail line2"."Account Type" of
                                        "Detail line2"."Account Type"::Customer:
                                            begin
                                                CustEntry.Get("Detail line2"."Serial No. (Entry)");
                                                UseDocumentNo := CustEntry."Document No.";
                                                if CustEntry."Document Type" <> CustEntry."Document Type"::Invoice then
                                                    Docket := true;
                                            end;
                                        "Detail line2"."Account Type"::Vendor:
                                            begin
                                                VenEntry.Get("Detail line2"."Serial No. (Entry)");
                                                if VenEntry."External Document No." <> '' then
                                                    UseDocumentNo := VenEntry."External Document No."
                                                else
                                                    UseDocumentNo := VenEntry."Document No.";
                                                if VenEntry."Document Type" <> VenEntry."Document Type"::Invoice then
                                                    Docket := true;
                                            end;
                                        "Detail line2"."Account Type"::Employee:
                                            begin
                                                EmployeeLedgerEntry.Get("Detail line2"."Serial No. (Entry)");
                                                UseDocumentNo := EmployeeLedgerEntry."Document No.";
                                                if EmployeeLedgerEntry."Document Type" <> EmployeeLedgerEntry."Document Type"::Invoice then
                                                    Docket := true;
                                            end;
                                    end;
                                    if not Docket then begin
                                        if StrLen("Description 1" + ' ' + UseDocumentNo) < MaxStrLen("Description 1") then
                                            "Description 1" := DelChr("Description 1" + ' ' + UseDocumentNo, '<>')
                                        else
                                            if StrLen("Description 2" + ' ' + UseDocumentNo) < MaxStrLen("Description 2") then
                                                "Description 2" := DelChr("Description 2" + ' ' + UseDocumentNo, '<>')
                                            else
                                                if StrLen("Description 3" + ' ' + UseDocumentNo) < MaxStrLen("Description 3") then
                                                    "Description 3" := DelChr("Description 3" + ' ' + UseDocumentNo, '<>')
                                                else
                                                    if StrLen("Description 4" + ' ' + UseDocumentNo) < MaxStrLen("Description 4") then
                                                        "Description 4" := DelChr("Description 4" + ' ' + UseDocumentNo, '<>')
                                                    else
                                                        Docket := true;
                                    end;
                                    if Docket then
                                        if "Description 1" <> Text1000002 then begin
                                            "Description 1" := Text1000002;
                                            case "Account Type" of
                                                "Account Type"::Customer:
                                                    begin
                                                        Custm.Get("Account No.");
                                                        if Custm."Our Account No." <> '' then
                                                            "Description 2" := CopyStr(StrSubstNo(Text1000004,
                                                                  Custm."Our Account No."),
                                                                1,
                                                                MaxStrLen("Description 2"))
                                                        else begin
                                                            CompanyInfo.Get;
                                                            "Description 2" :=
                                                              CopyStr(CompanyInfo.Name, 1, MaxStrLen("Description 2"));
                                                        end;
                                                    end;
                                                "Account Type"::Vendor:
                                                    begin
                                                        Vend.Get("Account No.");
                                                        if Vend."Our Account No." <> '' then
                                                            "Description 2" := CopyStr(StrSubstNo(Text1000003,
                                                                  Vend."Our Account No."),
                                                                1,
                                                                MaxStrLen("Description 2"))
                                                        else begin
                                                            CompanyInfo.Get;
                                                            "Description 2" :=
                                                              CopyStr(CompanyInfo.Name, 1, MaxStrLen("Description 2"));
                                                        end;
                                                    end;
                                                "Account Type"::Employee:
                                                    begin
                                                        // Employees do not have the "Our Account No." field
                                                        // so we just take the company name.
                                                        CompanyInfo.Get;
                                                        "Description 2" := CopyStr(CompanyInfo.Name, 1, MaxStrLen("Description 2"));
                                                    end;
                                            end;
                                            "Description 3" := '';
                                            "Description 4" := '';
                                        end;
                                until "Detail line2".Next = 0;
                                LockTable;
                                Modify;
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AfterGetCurrentRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        AfterGetCurrentRecord;
    end;

    var
        Text1000000: Label 'Moving %1 from %2 to %3';
        Text1000001: Label 'Invoice';
        Text1000002: Label 'Combined order, see docket';
        Text1000003: Label 'Vendor No. %1';
        Text1000004: Label 'CustomerNo. %1';
        "Detail line": Record "Detail Line";
        "Detail line2": Record "Detail Line";
        ProcessingLines: Codeunit "Process Proposal Lines";

    local procedure AfterGetCurrentRecord()
    begin
        xRec := Rec;
        CurrPage.Caption(GetSourceName());
        SetRange("Line No.");
    end;
}
