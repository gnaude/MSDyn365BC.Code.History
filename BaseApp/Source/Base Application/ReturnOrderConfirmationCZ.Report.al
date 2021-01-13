report 31093 "Return Order Confirmation CZ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReturnOrderConfirmationCZ.rdlc';
    Caption = 'Return Order Confirmation CZ';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(RegistrationNo_CompanyInformation; "Registration No.")
            {
            }
            column(VATRegistrationNo_CompanyInformation; "VAT Registration No.")
            {
            }
            column(HomePage_CompanyInformation; "Home Page")
            {
            }
            column(Picture_CompanyInformation; Picture)
            {
            }
            dataitem("Sales & Receivables Setup"; "Sales & Receivables Setup")
            {
                DataItemTableView = SORTING("Primary Key");
                column(LogoPositiononDocuments_SalesReceivablesSetup; Format("Logo Position on Documents", 0, 2))
                {
                }
                dataitem("General Ledger Setup"; "General Ledger Setup")
                {
                    DataItemTableView = SORTING("Primary Key");
                    column(LCYCode_GeneralLedgerSetup; "LCY Code")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, "Company Information");
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST("Return Order"));
            column(DocumentLbl; DocumentLbl)
            {
            }
            column(PageLbl; PageLbl)
            {
            }
            column(CopyLbl; CopyLbl)
            {
            }
            column(VendorLbl; VendLbl)
            {
            }
            column(CustomerLbl; CustLbl)
            {
            }
            column(ShipToLbl; ShipToLbl)
            {
            }
            column(PaymentTermsLbl; PaymentTermsLbl)
            {
            }
            column(PaymentMethodLbl; PaymentMethodLbl)
            {
            }
            column(ShipmentMethodLbl; ShipmentMethodLbl)
            {
            }
            column(SalespersonLbl; SalespersonLbl)
            {
            }
            column(UoMLbl; UoMLbl)
            {
            }
            column(CreatorLbl; CreatorLbl)
            {
            }
            column(SubtotalLbl; SubtotalLbl)
            {
            }
            column(DiscPercentLbl; DiscPercentLbl)
            {
            }
            column(TotalLbl; TotalLbl)
            {
            }
            column(VATLbl; VATLbl)
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(VATRegistrationNo_SalesHeaderCaption; FieldCaption("VAT Registration No."))
            {
            }
            column(VATRegistrationNo_SalesHeader; "VAT Registration No.")
            {
            }
            column(RegistrationNo_SalesHeaderCaption; FieldCaption("Registration No."))
            {
            }
            column(RegistrationNo_SalesHeader; "Registration No.")
            {
            }
            column(BankAccountNo_SalesHeaderCaption; FieldCaption("Bank Account No."))
            {
            }
            column(BankAccountNo_SalesHeader; "Bank Account No.")
            {
            }
            column(IBAN_SalesHeaderCaption; FieldCaption(IBAN))
            {
            }
            column(IBAN_SalesHeader; IBAN)
            {
            }
            column(BIC_SalesHeaderCaption; FieldCaption("SWIFT Code"))
            {
            }
            column(BIC_SalesHeader; "SWIFT Code")
            {
            }
            column(OrderDate_SalesHeaderCaption; FieldCaption("Order Date"))
            {
            }
            column(OrderDate_SalesHeader; "Order Date")
            {
            }
            column(PaymentTerms; PaymentTerms.Description)
            {
            }
            column(PaymentMethod; PaymentMethod.Description)
            {
            }
            column(YourReference_SalesHeaderCaption; FieldCaption("Your Reference"))
            {
            }
            column(YourReference_SalesHeader; "Your Reference")
            {
            }
            column(ShipmentMethod; ShipmentMethod.Description)
            {
            }
            column(CurrencyCode_SalesHeader; "Currency Code")
            {
            }
            column(Amount_SalesHeaderCaption; FieldCaption(Amount))
            {
            }
            column(Amount_SalesHeader; Amount)
            {
            }
            column(AmountIncludingVAT_SalesHeaderCaption; FieldCaption("Amount Including VAT"))
            {
            }
            column(AmountIncludingVAT_SalesHeader; "Amount Including VAT")
            {
            }
            column(DocFooterText; DocFooterText)
            {
            }
            column(CustAddr1; CustAddr[1])
            {
            }
            column(CustAddr2; CustAddr[2])
            {
            }
            column(CustAddr3; CustAddr[3])
            {
            }
            column(CustAddr4; CustAddr[4])
            {
            }
            column(CustAddr5; CustAddr[5])
            {
            }
            column(CustAddr6; CustAddr[6])
            {
            }
            column(ShipToAddr1; ShipToAddr[1])
            {
            }
            column(ShipToAddr2; ShipToAddr[2])
            {
            }
            column(ShipToAddr3; ShipToAddr[3])
            {
            }
            column(ShipToAddr4; ShipToAddr[4])
            {
            }
            column(ShipToAddr5; ShipToAddr[5])
            {
            }
            column(ShipToAddr6; ShipToAddr[6])
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CopyNo; Number)
                {
                }
                dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
                {
                    DataItemLink = Code = FIELD("Salesperson Code");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING(Code);
                    column(Name_SalespersonPurchaser; Name)
                    {
                    }
                    column(EMail_SalespersonPurchaser; "E-Mail")
                    {
                    }
                    column(PhoneNo_SalespersonPurchaser; "Phone No.")
                    {
                    }
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST("Return Order"));

                    trigger OnPreDataItem()
                    begin
                        CurrReport.Break;
                    end;
                }
                dataitem(RoundLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(LineNo_SalesLine; "Sales Line"."Line No.")
                    {
                    }
                    column(Type_SalesLine; Format("Sales Line".Type, 0, 2))
                    {
                    }
                    column(No_SalesLineCaption; "Sales Line".FieldCaption("No."))
                    {
                    }
                    column(No_SalesLine; "Sales Line"."No.")
                    {
                    }
                    column(Description_SalesLineCaption; "Sales Line".FieldCaption(Description))
                    {
                    }
                    column(Description_SalesLine; "Sales Line".Description)
                    {
                    }
                    column(Quantity_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                    {
                    }
                    column(Quantity_SalesLine; "Sales Line".Quantity)
                    {
                    }
                    column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                    {
                    }
                    column(UnitPrice_SalesLineCaption; "Sales Line".FieldCaption("Unit Price"))
                    {
                    }
                    column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                    {
                    }
                    column(LineDiscount_SalesLineCaption; "Sales Line".FieldCaption("Line Discount %"))
                    {
                    }
                    column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                    {
                    }
                    column(VAT_SalesLineCaption; "Sales Line".FieldCaption("VAT %"))
                    {
                    }
                    column(VAT_SalesLine; "Sales Line"."VAT %")
                    {
                    }
                    column(LineAmount_SalesLineCaption; "Sales Line".FieldCaption("Line Amount"))
                    {
                    }
                    column(LineAmount_SalesLine; "Sales Line"."Line Amount")
                    {
                    }
                    column(InvDiscountAmount_SalesLineCaption; "Sales Line".FieldCaption("Inv. Discount Amount"))
                    {
                    }
                    column(InvDiscountAmount_SalesLine; "Sales Line"."Inv. Discount Amount")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempSalesLine.FindSet
                        else
                            TempSalesLine.Next;

                        "Sales Line" := TempSalesLine;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempSalesLine.Count);
                    end;
                }
                dataitem("User Setup"; "User Setup")
                {
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("User ID");
                    dataitem(Employee; Employee)
                    {
                        DataItemLink = "No." = FIELD("Employee No.");
                        DataItemTableView = SORTING("No.");
                        column(FullName_Employee; FullName)
                        {
                        }
                        column(PhoneNo_Employee; "Phone No.")
                        {
                        }
                        column(CompanyEMail_Employee; "Company E-Mail")
                        {
                        }
                    }

                    trigger OnPreDataItem()
                    begin
                        SetRange("User ID", UserId);
                    end;
                }

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode then
                        CODEUNIT.Run(CODEUNIT::"Sales-Printed", "Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;

                    SetRange(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            var
                TempVATAmountLine: Record "VAT Amount Line" temporary;
                SalesPost: Codeunit "Sales-Post";
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");

                Clear(TempSalesLine);
                TempSalesLine.DeleteAll;
                SalesPost.GetSalesLines("Sales Header", TempSalesLine, 0);
                TempSalesLine.CalcVATAmountLines(0, "Sales Header", TempSalesLine, TempVATAmountLine);
                Amount := TempVATAmountLine.GetTotalVATBase;
                "Amount Including VAT" := TempVATAmountLine.GetTotalAmountInclVAT;

                if "Currency Code" = '' then
                    "Currency Code" := "General Ledger Setup"."LCY Code";

                if LogInteraction and not IsReportInPreviewMode then begin
                    if "Bill-to Contact No." <> '' then
                        SegMgt.LogDocument(
                          18, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", "Opportunity No.")
                    else
                        SegMgt.LogDocument(
                          18, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", "Opportunity No.");
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the number of copies to print.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want the program to record the return order confirmation you print as Interactions and add them to the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        "Sales & Receivables Setup".Get;
    end;

    var
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        ShipmentMethod: Record "Shipment Method";
        TempSalesLine: Record "Sales Line" temporary;
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegMgt: Codeunit SegManagement;
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        DocFooterText: Text[250];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DocumentLbl: Label 'Return Order Confirmation';
        PageLbl: Label 'Page';
        CopyLbl: Label 'Copy';
        VendLbl: Label 'Vendor';
        CustLbl: Label 'Customer';
        ShipToLbl: Label 'Ship-to';
        PaymentTermsLbl: Label 'Payment Terms';
        PaymentMethodLbl: Label 'Payment Method';
        ShipmentMethodLbl: Label 'Shipment Method';
        SalespersonLbl: Label 'Salesperson';
        UoMLbl: Label 'UoM';
        CreatorLbl: Label 'Posted by';
        SubtotalLbl: Label 'Subtotal';
        DiscPercentLbl: Label 'Discount %';
        TotalLbl: Label 'total';
        VATLbl: Label 'VAT';

    [Scope('OnPrem')]
    procedure InitLogInteraction()
    begin
        LogInteraction := SegMgt.FindInteractTmplCode(18) <> '';
    end;

    [Scope('OnPrem')]
    procedure InitializeRequest(NoOfCopiesFrom: Integer; LogInteractionFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        LogInteraction := LogInteractionFrom;
    end;

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
            FormatDocument.SetPaymentMethod(PaymentMethod, "Payment Method Code", "Language Code");

            DocFooterText := FormatDocument.GetDocumentFooterText("Language Code");
        end;
    end;

    local procedure FormatAddressFields(SalesHeader: Record "Sales Header")
    begin
        FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
        FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;
}

