page 12111 "Show Computed Withh. Contrib."
{
    Caption = 'Show-Computed Withh-Contrib';
    PageType = Card;
    SourceTable = "Tmp Withholding Contribution";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Related Date"; "Related Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the transaction date of the purchase that generated the payment journal entry.';
                }
                field("Payment Date"; "Payment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date that the taxes are paid to the tax authority.';
                }
                field(Reason; Reason)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason code.';
                }
            }
            group("Withholding Tax")
            {
                Caption = 'Withholding Tax';
                field("Withholding Tax Code"; "Withholding Tax Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the withholding tax code that was applied to the original purchase.';
                }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the total amount of the original purchase that is subject to withholding tax.';
                }
                field("Base - Excluded Amount"; "Base - Excluded Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the original purchase that is excluded from the withholding tax calculation based on exclusions allowed by law.';
                }
                field("Non Taxable Amount By Treaty"; "Non Taxable Amount By Treaty")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the original purchase that is excluded from withholding tax based on residency.';
                }
                field("Non Taxable %"; "Non Taxable %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the percent of the original purchase that is not taxable due to provisions in the law.';
                }
                field("Non Taxable Amount"; "Non Taxable Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original purchase that is not taxable due to provisions in the law.';
                }
                field("Taxable Base"; "Taxable Base")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original purchase that is subject to withholding tax after nontaxable and excluded amounts have been subtracted.';

                    trigger OnValidate()
                    begin
                        Error('');
                    end;
                }
                field("Withholding Tax %"; "Withholding Tax %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the percentage of the purchase that is subject to withholding tax.';
                }
                field("Withholding Tax Amount"; "Withholding Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the amount of withholding tax that is due for this payment journal entry.';
                }
            }
            group("Social Security")
            {
                Caption = 'Social Security';
                field("Social Security Code"; "Social Security Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Social Security code that is applied to the payment.';
                }
                field("Gross Amount"; "Gross Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the total amount of the original purchase that is subject to Social Security withholding tax.';
                }
                field("Soc.Sec.Non Taxable Amount"; "Soc.Sec.Non Taxable Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the original purchase that is excluded from Social Security tax liability based on provisions in the law.';
                }
                field("Contribution Base"; "Contribution Base")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original purchase that is subject to Social Security tax after the nontaxable amount has been subtracted.';
                }
                field("Social Security %"; "Social Security %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the purchase that is subject to Social Security tax.';
                }
                field("Total Social Security Amount"; "Total Social Security Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the total amount of Social Security tax that is due for the purchase.';
                }
                field("Free-Lance %"; "Free-Lance %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the Social Security tax liability that is the responsibility of the independent contractor or vendor.';
                }
                field("Free-Lance Amount"; "Free-Lance Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the Social Security tax liability that is the responsibility of the independent contractor or vendor.';
                }
                field("Company Amount"; "Company Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the amount of Social Security tax from the purchase that your company is liable for.';
                }
            }
            group(INAIL)
            {
                Caption = 'INAIL';
                field("INAIL Code"; "INAIL Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the INAIL withholding tax code that is applied to this purchase for workers compensation insurance.';
                }
                field("INAIL Gross Amount"; "INAIL Gross Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the total amount of the original purchase that is subject to INAIL withholding tax.';
                }
                field("INAIL Non Taxable Amount"; "INAIL Non Taxable Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the original purchase excluded from the INAIL withholding tax based on provisions in the law.';
                }
                field("INAIL Contribution Base"; "INAIL Contribution Base")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original purchase that is subject to INAIL withholding tax, after non-taxable amounts have been subtracted.';
                }
                field("INAIL Per Mil"; "INAIL Per Mil")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the purchase that is subject to INAIL withholding tax for workers compensation insurance.';
                }
                field("INAIL Total Amount"; "INAIL Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the total amount of the INAIL withholding tax that is due for this purchase.';
                }
                field("INAIL Free-Lance %"; "INAIL Free-Lance %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the INAIL tax liability that is the responsibility of the independent contractor or vendor.';
                }
                field("INAIL Free-Lance Amount"; "INAIL Free-Lance Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the INAIL tax liability that is the responsibility of the independent contractor or vendor.';
                }
                field("INAIL Company Amount"; "INAIL Company Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Italian Workers'' Compensation Authority (INAIL) tax amount that your company is liable for.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Vend.Get("Vendor No.");
        CurrPage.Caption := Text1033 + "Vendor No." + ' - ' + Vend.Name + ' - ' + "Invoice No.";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then
            OKOnPush;
    end;

    var
        Text1033: Label 'INPS AND WITHH. TAXES - Vendor - ';
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TmpGenJnlLine: Record "Gen. Journal Line" temporary;
        Vend: Record Vendor;
        PurchSetup: Integer;

    local procedure OKOnPush()
    begin
        GenJnlLine2.Reset;
        GenJnlLine2.SetRange("Journal Template Name", "Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJnlLine2.SetRange("Line No.", "Line No.");

        if GenJnlLine2.FindFirst then begin
            if GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Payment then
                GenJnlLine2.Validate(Amount, GenJnlLine2.Amount - "Withholding Tax Amount" + "Old Withholding Amount" -
                  "Free-Lance Amount" + "Old Free-Lance Amount" -
                  "INAIL Free-Lance Amount" + "Old INAIL Free-Lance Amount")
            else
                GenJnlLine2.Validate(Amount, GenJnlLine2.Amount + "Withholding Tax Amount" - "Old Withholding Amount" +
                  "Free-Lance Amount" - "Old Free-Lance Amount" +
                  "INAIL Free-Lance Amount" - "Old INAIL Free-Lance Amount");
            GenJnlLine2.Modify;
            GenJnlLine2.SetRange("Line No.");
            TmpGenJnlLine.Copy(GenJnlLine2);

            if "Withholding Tax Code" <> ''
            then begin
                if "Payment Line-Withholding" = 0 then begin
                    GenJnlLine.Init;
                    GenJnlLine.Copy(GenJnlLine2);
                    if GenJnlLine2.FindLast then
                        PurchSetup := GenJnlLine2."Line No.";
                    GenJnlLine."Line No." := PurchSetup + 10000;
                    GenJnlLine."System-Created Entry" := true;
                end else begin
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange("Journal Template Name", TmpGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TmpGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", "Payment Line-Withholding");
                    GenJnlLine.FindFirst;
                    ClearFilters;
                end;
                GenJnlLine.Validate("Account No.");
                if GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment then
                    GenJnlLine.Validate(Amount, "Withholding Tax Amount")
                else
                    GenJnlLine.Validate(Amount, -"Withholding Tax Amount");
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := "Withholding Account";
                GenJnlLine.Validate("Bal. Account No.", "Withholding Account");

                if "Payment Line-Withholding" = 0 then begin
                    GenJnlLine.Insert;
                    "Payment Line-Withholding" := GenJnlLine."Line No.";
                    Modify;
                end else
                    GenJnlLine.Modify;
            end;

            if ("Social Security Code" <> '') and
               ("Free-Lance Amount" <> 0)
            then begin
                if "Payment Line-Soc. Sec." = 0 then begin
                    GenJnlLine.Init;
                    GenJnlLine.Copy(TmpGenJnlLine);
                    if GenJnlLine2.FindLast then
                        PurchSetup := GenJnlLine2."Line No.";
                    GenJnlLine."Line No." := PurchSetup + 10000;
                    GenJnlLine."System-Created Entry" := true;
                end else begin
                    GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                    GenJnlLine.SetRange("Journal Template Name", TmpGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TmpGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", "Payment Line-Soc. Sec.");
                    GenJnlLine.FindFirst;
                    ClearFilters;
                end;

                GenJnlLine.Validate(Amount, "Free-Lance Amount");
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := "Social Security Acc.";
                if "Payment Line-Soc. Sec." = 0 then begin
                    GenJnlLine.Insert;
                    "Payment Line-Soc. Sec." := GenJnlLine."Line No.";
                    Modify;
                end else
                    GenJnlLine.Modify;
            end;

            if ("Social Security Code" <> '') and
               ("Company Amount" <> 0)
            then begin
                if "Payment Line-Company" = 0 then begin
                    GenJnlLine.Init;
                    GenJnlLine.Copy(TmpGenJnlLine);
                    if GenJnlLine2.FindLast then
                        PurchSetup := GenJnlLine2."Line No.";
                    GenJnlLine."Line No." := PurchSetup + 10000;
                    GenJnlLine."System-Created Entry" := true;
                end else begin
                    GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                    GenJnlLine.SetRange("Journal Template Name", TmpGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TmpGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", "Payment Line-Company");
                    GenJnlLine.FindFirst;
                    ClearFilters;
                end;
                GenJnlLine.Validate(Amount, "Company Amount");
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := "Social Security Acc.";

                GenJnlLine.Validate("Account No.", "Social Security Charges Acc.");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::" ";
                GenJnlLine."Applies-to Doc. No." := '';

                if "Payment Line-Company" = 0 then begin
                    GenJnlLine.Insert;
                    "Payment Line-Company" := GenJnlLine."Line No.";
                    Modify;
                end else
                    GenJnlLine.Modify;
            end;
            "Old Withholding Amount" := "Withholding Tax Amount";
            "Old Free-Lance Amount" := "Free-Lance Amount";
            Modify;

            if ("INAIL Code" <> '') and
               ("INAIL Free-Lance Amount" <> 0)
            then begin
                if "INAIL Payment Line" = 0 then begin
                    GenJnlLine.Init;
                    GenJnlLine.Copy(TmpGenJnlLine);
                    if GenJnlLine2.FindLast then
                        PurchSetup := GenJnlLine2."Line No.";
                    GenJnlLine."Line No." := PurchSetup + 10000;
                    GenJnlLine."System-Created Entry" := true;
                end else begin
                    GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                    GenJnlLine.SetRange("Journal Template Name", TmpGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TmpGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", "INAIL Payment Line");
                    GenJnlLine.FindFirst;
                    ClearFilters;
                end;
                GenJnlLine.Validate(Amount, "INAIL Free-Lance Amount");
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := "INAIL Debit Account";
                if "INAIL Payment Line" = 0 then begin
                    GenJnlLine.Insert;
                    "INAIL Payment Line" := GenJnlLine."Line No.";
                    Modify;
                end else
                    GenJnlLine.Modify;
            end;

            if ("INAIL Code" <> '') and
               ("INAIL Company Amount" <> 0)
            then begin
                if "INAIL Company Payment Line" = 0 then begin
                    GenJnlLine.Init;
                    GenJnlLine.Copy(TmpGenJnlLine);
                    if GenJnlLine2.FindLast then
                        PurchSetup := GenJnlLine2."Line No.";
                    GenJnlLine."Line No." := PurchSetup + 10000;
                    GenJnlLine."System-Created Entry" := true;
                end else begin
                    GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                    GenJnlLine.SetRange("Journal Template Name", TmpGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", TmpGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", "Payment Line-Company");
                    GenJnlLine.FindFirst;
                    ClearFilters;
                end;
                GenJnlLine.Validate(Amount, "INAIL Company Amount");
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := "INAIL Debit Account";

                GenJnlLine.Validate("Account No.", "INAIL Charge Account");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::" ";
                GenJnlLine."Applies-to Doc. No." := '';

                if "INAIL Company Payment Line" = 0 then begin
                    GenJnlLine.Insert;
                    "INAIL Company Payment Line" := GenJnlLine."Line No.";
                    Modify;
                end else
                    GenJnlLine.Modify;
            end;
            "Old Free-Lance Amount" := "INAIL Free-Lance Amount";
            Modify;
        end;
    end;

    local procedure ClearFilters()
    begin
        GenJnlLine.SetRange("Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name");
        GenJnlLine.SetRange("Line No.");
    end;
}
