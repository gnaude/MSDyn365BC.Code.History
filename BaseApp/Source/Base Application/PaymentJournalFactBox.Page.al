page 35517 "Payment Journal FactBox"
{
    Caption = 'Payment Journal Details';
    PageType = CardPart;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(content)
        {
            field(AccName; AccName)
            {
                ApplicationArea = All;
                Caption = 'Name';
                Editable = false;
                ToolTip = 'Specifies the name of the payment recipient.';
            }
            field(PaymentTerms; PaymentTerms)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Terms';
                Editable = false;
                ToolTip = 'Specifies the payment term of the vendor.';
            }
            field(OeRemainAmountFC; OeRemainAmountFC)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Amt.';
                Editable = false;
                ToolTip = 'Specifies the remaining amount of the open entry.';
            }
            field(PaymentAmt; PaymentAmt)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment';
                Editable = false;
                ToolTip = 'Specifies the payment amount of the actual line.';
            }
            field(RemainAfterPayment; RemainAfterPayment)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                CaptionClass = Format(RemainAfterPaymentCaption);
                Caption = 'Remaining after Payment';
                Editable = false;
                ToolTip = 'Specifies how much remains to be paid.';
            }
            field(PmtDiscount; PmtDiscount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pmt. Discount';
                Editable = false;
                ToolTip = 'Specifies the possible payment discount.';
            }
            field(PaymDiscDeductAmount; PaymDiscDeductAmount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deduction';
                Editable = false;
                ToolTip = 'Specifies the accepted payment discount deduction.';
            }
            field(AcceptedPaymentTol; AcceptedPaymentTol)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pmt. Tolerance';
                Editable = false;
                ToolTip = 'Specifies the accepted payment tolerance.';
            }
            field(PostingDate; PostingDate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Age';
                Editable = false;
                ToolTip = 'Specifies the posting date of the open entry.';
            }
            field(AgeDays; AgeDays)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Age Days';
                Editable = false;
                ToolTip = 'Specifies the number of days since the posting date of the open entry.';
            }
            field(DueDate; DueDate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Due';
                Editable = false;
                ToolTip = 'Specifies the due date of the open entry.';
            }
            field(DueDays; DueDays)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Due Days';
                Editable = false;
                ToolTip = 'Specifies the number of days until the due date of the open entry.';
            }
            field(PmtDiscDate; PmtDiscDate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Discount';
                Editable = false;
                ToolTip = 'Specifies the payment discount date of the open entry.';
            }
            field(PaymDiscDays; PaymDiscDays)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Cash Discount Days';
                Editable = false;
                ToolTip = 'Specifies the number of days to the payment discount date.';
            }
            field(TotalPayment; TotalPayAmount)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Payments';
                Editable = false;
                ToolTip = 'Specifies the total of payments in LCY.';
            }
            field(Balance; Balance)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Balance';
                Editable = false;
                ToolTip = 'Specifies the balance on the actual line in LCY.';
            }
            field(TotalBalance; TotalBalance)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Total Balance';
                Editable = false;
                ToolTip = 'Specifies the total balance in LCY.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);

        Factor := 1;
        if "Bal. Account Type" = "Bal. Account Type"::Vendor then
            Factor := -1;

        UpdateBalance;
        UpdateInfoBox;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
            GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
            UpdateBalance;
            UpdateInfoBox;
        end else begin
            AccName := '';
            BalAccName := '';
            AgeDays := 0;
            PaymDiscDays := 0;
            DueDays := 0;
            OeRemainAmountFC := 0;
            PaymDiscDeductAmount := 0;
            RemainAfterPayment := 0;
            PmtDiscount := 0;
            AcceptedPaymentTol := 0;
            PostingDate := 0D;
            DueDate := 0D;
            PmtDiscDate := 0D;
            PaymentAmt := 0;
            RemainAfterPaymentCaption := Text001;
            PaymentTerms := '';
            Balance := 0;
            TotalBalance := 0;
            TotalPayAmount := 0;
        end;
        exit(Find(Which));
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        AccName: Text[50];
        BalAccName: Text[50];
        RemainAfterPaymentCaption: Text[30];
        Balance: Decimal;
        TotalBalance: Decimal;
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        AgeDays: Integer;
        PaymDiscDays: Integer;
        DueDays: Integer;
        OeRemainAmountFC: Decimal;
        PaymDiscDeductAmount: Decimal;
        RemainAfterPayment: Decimal;
        TotalPayAmount: Decimal;
        PmtDiscount: Decimal;
        AcceptedPaymentTol: Decimal;
        Text001: Label 'Remaining after Payment';
        PostingDate: Date;
        DueDate: Date;
        PmtDiscDate: Date;
        PaymentAmt: Decimal;
        PaymentTerms: Code[10];
        Factor: Integer;

    local procedure UpdateBalance()
    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        Balance := 0;
        TotalBalance := 0;
        TotalPayAmount := 0;

        LineNo := "Line No.";
        PaymentAmt := -Amount * Factor;

        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Account Type", "Document Type");
        GenJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJnlLine.CalcSums("Balance (LCY)");
        TotalBalance := GenJnlLine."Balance (LCY)";

        GenJnlLine.SetFilter("Line No.", '<=%1', LineNo);
        GenJnlLine.CalcSums("Balance (LCY)");
        Balance := GenJnlLine."Balance (LCY)";

        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.SetFilter("Document Type", '%1|%2', GenJnlLine."Document Type"::Payment, GenJnlLine."Document Type"::Refund);
        GenJnlLine.SetRange("Line No.");
        GenJnlLine.CalcSums("Amount (LCY)");
        TotalPayAmount := -GenJnlLine."Amount (LCY)";

        GenJnlLine.SetRange("Account Type");
        GenJnlLine.SetRange("Bal. Account Type", GenJnlLine."Bal. Account Type"::Vendor);
        GenJnlLine.CalcSums("Amount (LCY)");
        TotalPayAmount += GenJnlLine."Amount (LCY)";
    end;

    [Scope('OnPrem')]
    procedure UpdateInfoBox()
    var
        ExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        IsAppliedToOneEntry: Boolean;
        CurrOeRemainAmountFC: Decimal;
        CurrPmtDiscount: Decimal;
        CurrPaymDiscDeductAmount: Decimal;
        CurrAcceptedPaymentTol: Decimal;
        CurrRemainAfterPayment: Decimal;
    begin
        AgeDays := 0;
        PaymDiscDays := 0;
        DueDays := 0;
        OeRemainAmountFC := 0;
        PaymDiscDeductAmount := 0;
        RemainAfterPayment := 0;
        PmtDiscount := 0;
        AcceptedPaymentTol := 0;
        RemainAfterPaymentCaption := Text001;
        PostingDate := 0D;
        DueDate := 0D;
        PmtDiscDate := 0D;
        PaymentTerms := '';

        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentKey("Document No.");
        Vend.Init;

        case true of
            "Applies-to ID" <> '':
                VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            "Applies-to Doc. No." <> '':
                begin
                    VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                    VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                end;
            else
                exit;
        end;

        if not VendLedgEntry.FindSet then
            exit;

        if Currency.ReadPermission then
            if Currency.Get("Currency Code") then
                Currency.InitRoundingPrecision;

        if not Vend.Get(VendLedgEntry."Vendor No.") then;
        PaymentTerms := Vend."Payment Terms Code";
        IsAppliedToOneEntry := VendLedgEntry.Count = 1;
        repeat
            // Calculate Days for Age, Payment Discount
            if ("Posting Date" > 0D) and IsAppliedToOneEntry then begin
                PostingDate := VendLedgEntry."Posting Date";
                PmtDiscDate := VendLedgEntry."Pmt. Discount Date";
                DueDate := VendLedgEntry."Due Date";
                if VendLedgEntry."Posting Date" > 0D then
                    AgeDays := "Posting Date" - VendLedgEntry."Posting Date";
                if VendLedgEntry."Pmt. Discount Date" > 0D then
                    PaymDiscDays := VendLedgEntry."Pmt. Discount Date" - "Posting Date";
                if VendLedgEntry."Due Date" > 0D then
                    DueDays := VendLedgEntry."Due Date" - "Posting Date";
            end;

            VendLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
            CurrOeRemainAmountFC := -VendLedgEntry."Remaining Amount";
            CurrPmtDiscount := -VendLedgEntry."Remaining Pmt. Disc. Possible";
            CurrPmtDiscount :=
              ExchRate.ExchangeAmtFCYToFCY("Posting Date", VendLedgEntry."Currency Code",
                "Currency Code", -VendLedgEntry."Remaining Pmt. Disc. Possible");
            CurrPmtDiscount := Round(CurrPmtDiscount, Currency."Amount Rounding Precision");

            // calculate FC-amount of open entries and remaining amount
            if VendLedgEntry."Currency Code" <> "Currency Code" then begin
                CurrOeRemainAmountFC :=
                  ExchRate.ExchangeAmtLCYToFCY(
                    "Posting Date", "Currency Code", -VendLedgEntry."Remaining Amt. (LCY)", "Currency Factor");
                CurrOeRemainAmountFC := Round(CurrOeRemainAmountFC, Currency."Amount Rounding Precision");
            end;

            if (VendLedgEntry."Pmt. Discount Date" >= "Posting Date") or
               ((VendLedgEntry."Pmt. Disc. Tolerance Date" >= "Posting Date") and
                VendLedgEntry."Accepted Pmt. Disc. Tolerance")
            then begin
                CurrPaymDiscDeductAmount := -VendLedgEntry."Remaining Pmt. Disc. Possible";
                if VendLedgEntry."Currency Code" <> "Currency Code" then
                    CurrPaymDiscDeductAmount :=
                      ExchRate.ExchangeAmtFCYToFCY(
                        "Posting Date", VendLedgEntry."Currency Code", "Currency Code", CurrPaymDiscDeductAmount);
            end;
            CurrPaymDiscDeductAmount := Round(CurrPaymDiscDeductAmount, Currency."Amount Rounding Precision");

            // Accepted Payment Tolerance
            CurrAcceptedPaymentTol := -VendLedgEntry."Accepted Payment Tolerance";
            if VendLedgEntry."Currency Code" <> "Currency Code" then
                CurrAcceptedPaymentTol :=
                  ExchRate.ExchangeAmtFCYToFCY(
                    "Posting Date", VendLedgEntry."Currency Code", "Currency Code", CurrAcceptedPaymentTol);
            CurrAcceptedPaymentTol := Round(CurrAcceptedPaymentTol, Currency."Amount Rounding Precision");

            CurrRemainAfterPayment :=
              CurrOeRemainAmountFC - (Amount * Factor) - CurrPaymDiscDeductAmount - CurrAcceptedPaymentTol;

            if ("Currency Code" <> VendLedgEntry."Currency Code") and
               (("Currency Code" <> '') and (VendLedgEntry."Currency Code" <> ''))
            then begin
                RemainAfterPaymentCaption := '';
                CurrRemainAfterPayment := 0;
                exit;
            end;

            // Pmt. Disc is not applied if entry is not closed
            if CurrRemainAfterPayment > 0 then begin
                CurrRemainAfterPayment := CurrRemainAfterPayment + CurrPaymDiscDeductAmount;
                CurrPaymDiscDeductAmount := 0;
            end;
            OeRemainAmountFC += CurrOeRemainAmountFC;
            PmtDiscount += CurrPmtDiscount;
            PaymDiscDeductAmount += CurrPaymDiscDeductAmount;
            AcceptedPaymentTol += CurrAcceptedPaymentTol;
            RemainAfterPayment += CurrRemainAfterPayment;
        until VendLedgEntry.Next = 0;
    end;
}
