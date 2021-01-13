report 11005 "VAT Statement Germany"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VATStatementGermany.rdlc';
    Caption = 'VAT Statement Germany';

    dataset
    {
        dataitem("VAT Statement Name"; "VAT Statement Name")
        {
            DataItemTableView = SORTING("Statement Template Name", Name);
            RequestFilterFields = "Statement Template Name", Name;
            column(StmtTemplName_VATStmtName; "Statement Template Name")
            {
            }
            column(Name_VATStmtName; Name)
            {
            }
            dataitem("VAT Statement Line"; "VAT Statement Line")
            {
                DataItemLink = "Statement Template Name" = FIELD("Statement Template Name"), "Statement Name" = FIELD(Name);
                DataItemTableView = SORTING("Statement Template Name", "Statement Name") WHERE(Print = CONST(true));
                RequestFilterFields = "Row No.";
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Heading; Heading)
                {
                }
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(Heading2; Heading2)
                {
                }
                column(PrintInIntegers; PrintInIntegers)
                {
                }
                column(UseAmtsInAddCurr; UseAmtsInAddCurr)
                {
                }
                column(Selection; SelectionInt)
                {
                }
                column(HeaderText; HeaderText)
                {
                }
                column(GLSetupAddRepCurrency; StrSubstNo(Text1140002, GLSetup."Additional Reporting Currency"))
                {
                }
                column(TableCaptionVATStmtFilter; "VAT Statement Line".TableCaption + ': ' + VATStmtLineFilter)
                {
                }
                column(VATStmtLineFilter; VATStmtLineFilter)
                {
                }
                column(TotalUnrealizedAmount; TotalUnrealizedAmount)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(TotalUnrealizedBase; TotalUnrealizedBase)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(TotalAmount; TotalAmount)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(TotalBase; TotalBase)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(TotalEmpty; TotalEmpty)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(Description_VATStmtLine; Description)
                {
                }
                column(RowNoVATStmtLine; "Row No.")
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(StmtTemplName_VATStmtLine; "Statement Template Name")
                {
                }
                column(StmtName_VATStmtLine; "Statement Name")
                {
                }
                column(LineNo_VATStmtLine; "Line No.")
                {
                }
                column(VATStatementCaption; VATStatementCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(VATStmtTemplNameCaption; VATStmtTemplNameCaptionLbl)
                {
                }
                column(VATStmtNameCaption; VATStmtNameCaptionLbl)
                {
                }
                column(AmtInWholeLCYCaption; AmtInWholeLCYCaptionLbl)
                {
                }
                column(InclAllVATEntriesCaption; InclAllVATEntriesCaptionLbl)
                {
                }
                column(InclClosedVATEntCaption; InclClosedVATEntCaptionLbl)
                {
                }
                column(UnrealizedVATAmtCaption; UnrealizedVATAmtCaptionLbl)
                {
                }
                column(UnrealizedBaseAmtCaption; UnrealizedBaseAmtCaptionLbl)
                {
                }
                column(VATAmountCaption; VATAmountCaptionLbl)
                {
                }
                column(BaseAmountCaption; BaseAmountCaptionLbl)
                {
                }
                column(DescCaption_VATStatementLine; FieldCaption(Description))
                {
                }
                column(RowNoCaption_VATStatementLine; FieldCaption("Row No."))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcLineTotal("VAT Statement Line", TotalAmount, TotalEmpty, TotalBase, TotalUnrealizedAmount, TotalUnrealizedBase, 0);
                    if PrintInIntegers then begin
                        TotalEmpty := Round(TotalEmpty, 1, '<');
                        TotalAmount := Round(TotalAmount, 1, '<');
                        TotalBase := Round(TotalBase, 1, '<');
                        TotalUnrealizedAmount := Round(TotalUnrealizedAmount, 1, '<');
                        TotalUnrealizedBase := Round(TotalUnrealizedBase, 1, '<');
                    end;
                    if "Print with" = "Print with"::"Opposite Sign" then begin
                        TotalEmpty := -TotalEmpty;
                        TotalAmount := -TotalAmount;
                        TotalBase := -TotalBase;
                        TotalUnrealizedAmount := -TotalUnrealizedAmount;
                        TotalUnrealizedBase := -TotalUnrealizedBase;
                    end;

                    case "Amount Type" of
                        "Amount Type"::Base:
                            TotalAmount := 0;
                        "Amount Type"::Amount:
                            TotalBase := 0;
                        "Amount Type"::"Unrealized Base":
                            TotalUnrealizedAmount := 0;
                        "Amount Type"::"Unrealized Amount":
                            TotalUnrealizedBase := 0;
                    end;

                    if NewPage then begin
                        PageGroupNo := PageGroupNo + 1;
                        NewPage := false;
                    end;
                    NewPage := "New Page";
                end;

                trigger OnPreDataItem()
                begin
                    // moved from Section

                    if UseAmtsInAddCurr then
                        HeaderText := StrSubstNo(Text1140001, GLSetup."Additional Reporting Currency")
                    else begin
                        GLSetup.TestField("LCY Code");
                        HeaderText := StrSubstNo(Text1140001, GLSetup."LCY Code");
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                GLSetup.Get;

                PageGroupNo := 1;
                NewPage := false;
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
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartDate; StartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                            ToolTip = 'Specifies the date from which the report or batch job processes information.';
                        }
                        field(EndDateReq; EndDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                            ToolTip = 'Specifies the last date that the report includes data for.';
                        }
                    }
                    field(Selection; Selection)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include VAT Entries';
                        OptionCaption = 'Open,Closed,Open and Closed';
                        ToolTip = 'Specifies if you want to include VAT entries from before the specified time period in the report.';
                    }
                    field(PeriodSelection; PeriodSelection)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include VAT Entries';
                        OptionCaption = 'Before and Within Period,Within Period';
                        ToolTip = 'Specifies if you want to include VAT entries from before the specified time period in the report.';
                    }
                    field(PrintInIntegers; PrintInIntegers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Round to Whole Numbers';
                        ToolTip = 'Specifies if you want the amounts in the report to be rounded to whole numbers.';
                    }
                    field(UseAmtsInAddCurr; UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want report amounts to be shown in the additional reporting currency.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if EndDateReq = 0D then
            EndDate := 99991231D
        else
            EndDate := EndDateReq;
        VATStmtLine.SetRange("Date Filter", StartDate, EndDateReq);
        if PeriodSelection = PeriodSelection::"Before and Within Period" then
            Heading := Text1140000
        else
            Heading := Text1140003;
        Heading2 := StrSubstNo(Text1140004, StartDate, EndDateReq);
        VATStmtLineFilter := VATStmtLine.GetFilters;

        SelectionInt := Selection;
    end;

    var
        Text1140000: Label 'VAT entries before and within the period';
        Text1140001: Label 'All amounts are in %1';
        Text1140002: Label 'Amounts are rounded down to a whole %1 amount';
        Text1140003: Label 'VAT entries within the period';
        Text1140004: Label 'Period: %1..%2';
        GLAcc: Record "G/L Account";
        VATEntry: Record "VAT Entry";
        GLSetup: Record "General Ledger Setup";
        VATStmtLine: Record "VAT Statement Line";
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        PrintInIntegers: Boolean;
        VATStmtLineFilter: Text;
        Heading: Text[50];
        Amount: Decimal;
        TotalAmount: Decimal;
        RowNo: array[6] of Code[10];
        ErrorText: Text[80];
        i: Integer;
        UseAmtsInAddCurr: Boolean;
        HeaderText: Text[50];
        EndDate: Date;
        StartDate: Date;
        EndDateReq: Date;
        Heading2: Text[50];
        TotalEmpty: Decimal;
        TotalBase: Decimal;
        TotalUnrealizedAmount: Decimal;
        TotalUnrealizedBase: Decimal;
        PageGroupNo: Integer;
        NewPage: Boolean;
        SelectionInt: Integer;
        VATStatementCaptionLbl: Label 'VAT Statement';
        CurrReportPageNoCaptionLbl: Label 'Page';
        VATStmtTemplNameCaptionLbl: Label 'VAT Statement Template';
        VATStmtNameCaptionLbl: Label 'VAT Statement Name';
        AmtInWholeLCYCaptionLbl: Label 'Amounts are in whole LCYs.';
        InclAllVATEntriesCaptionLbl: Label 'The report includes all VAT entries.';
        InclClosedVATEntCaptionLbl: Label 'The report includes only closed VAT entries.';
        UnrealizedVATAmtCaptionLbl: Label 'Unrealized VAT Amount';
        UnrealizedBaseAmtCaptionLbl: Label 'Unrealized Base Amount';
        VATAmountCaptionLbl: Label 'VAT Amount';
        BaseAmountCaptionLbl: Label 'Base Amount';

    [Scope('OnPrem')]
    procedure CalcLineTotal(VATStmtLine2: Record "VAT Statement Line"; var TotalAmount: Decimal; var TotalEmpty: Decimal; var TotalBase: Decimal; var TotalUnrealizedAmount: Decimal; var TotalUnrealizedBase: Decimal; Level: Integer): Boolean
    begin
        if Level = 0 then begin
            TotalAmount := 0;
            TotalEmpty := 0;
            TotalBase := 0;
            TotalUnrealizedAmount := 0;
            TotalUnrealizedBase := 0;
        end;
        case VATStmtLine2.Type of
            VATStmtLine2.Type::"Account Totaling":
                begin
                    GLAcc.SetFilter("No.", VATStmtLine2."Account Totaling");
                    if EndDateReq = 0D then
                        EndDate := 99991231D
                    else
                        EndDate := EndDateReq;
                    if PeriodSelection = PeriodSelection::"Before and Within Period" then
                        GLAcc.SetRange("Date Filter", 0D, EndDate)
                    else
                        GLAcc.SetRange("Date Filter", StartDate, EndDate);
                    Amount := 0;
                    if GLAcc.FindSet and (VATStmtLine2."Account Totaling" <> '') then
                        repeat
                            GLAcc.CalcFields("Net Change", "Additional-Currency Net Change");
                            Amount := ConditionalAdd(Amount, GLAcc."Net Change", GLAcc."Additional-Currency Net Change");
                        until GLAcc.Next = 0;
                    CalcTotalAmount(VATStmtLine2, TotalAmount, TotalEmpty, TotalBase, TotalUnrealizedAmount, TotalUnrealizedBase);
                end;
            VATStmtLine2.Type::"VAT Entry Totaling":
                begin
                    VATEntry.Reset;
                    VATEntry.SetCurrentKey(
                      Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group",
                      "Tax Jurisdiction Code", "Use Tax", "Posting Date");
                    VATEntry.SetRange(Type, VATStmtLine2."Gen. Posting Type");
                    VATEntry.SetRange("VAT Bus. Posting Group", VATStmtLine2."VAT Bus. Posting Group");
                    VATEntry.SetRange("VAT Prod. Posting Group", VATStmtLine2."VAT Prod. Posting Group");
                    VATEntry.SetRange("Tax Jurisdiction Code", VATStmtLine2."Tax Jurisdiction Code");
                    VATEntry.SetRange("Use Tax", VATStmtLine2."Use Tax");
                    if (EndDateReq <> 0D) or (StartDate <> 0D) then
                        if PeriodSelection = PeriodSelection::"Before and Within Period" then
                            VATEntry.SetRange("Posting Date", 0D, EndDate)
                        else
                            VATEntry.SetRange("Posting Date", StartDate, EndDate);
                    case Selection of
                        Selection::Open:
                            VATEntry.SetRange(Closed, false);
                        Selection::Closed:
                            VATEntry.SetRange(Closed, true);
                        else
                            VATEntry.SetRange(Closed);
                    end;
                    OnBeforeCalcAmountVATEntryTotaling(VATEntry, VATStmtLine2);
                    case VATStmtLine2."Amount Type" of
                        VATStmtLine2."Amount Type"::Amount:
                            begin
                                VATEntry.CalcSums(Amount, "Additional-Currency Amount");
                                Amount := ConditionalAdd(0, VATEntry.Amount, VATEntry."Additional-Currency Amount");
                            end;
                        VATStmtLine2."Amount Type"::Base:
                            begin
                                VATEntry.CalcSums(Base, "Additional-Currency Base");
                                Amount := ConditionalAdd(0, VATEntry.Base, VATEntry."Additional-Currency Base");
                            end;
                        VATStmtLine2."Amount Type"::"Unrealized Amount":
                            begin
                                VATEntry.CalcSums("Unrealized Amount", "Add.-Currency Unrealized Amt.");
                                Amount := ConditionalAdd(0, VATEntry."Unrealized Amount", VATEntry."Add.-Currency Unrealized Amt.");
                            end;
                        VATStmtLine2."Amount Type"::"Unrealized Base":
                            begin
                                VATEntry.CalcSums("Unrealized Base", "Add.-Currency Unrealized Base");
                                Amount := ConditionalAdd(0, VATEntry."Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                            end;
                        else
                            VATStmtLine2.TestField("Amount Type");
                    end;
                    CalcTotalAmount(VATStmtLine2, TotalAmount, TotalEmpty, TotalBase, TotalUnrealizedAmount, TotalUnrealizedBase);
                end;
            VATStmtLine2.Type::"Row Totaling":
                begin
                    if Level >= ArrayLen(RowNo) then
                        exit(false);
                    Level := Level + 1;
                    RowNo[Level] := VATStmtLine2."Row No.";

                    if VATStmtLine2."Row Totaling" = '' then
                        exit(true);
                    VATStmtLine2.SetRange("Statement Template Name", VATStmtLine2."Statement Template Name");
                    VATStmtLine2.SetRange("Statement Name", VATStmtLine2."Statement Name");
                    VATStmtLine2.SetFilter("Row No.", VATStmtLine2."Row Totaling");
                    if VATStmtLine2.FindSet then
                        repeat
                            if not CalcLineTotal(
                                VATStmtLine2, TotalAmount, TotalEmpty, TotalBase,
                                TotalUnrealizedAmount, TotalUnrealizedBase, Level)
                            then begin
                                if Level > 1 then
                                    exit(false);
                                for i := 1 to ArrayLen(RowNo) do
                                    ErrorText := ErrorText + RowNo[i] + ' => ';
                                ErrorText := ErrorText + '...';
                                VATStmtLine2.FieldError("Row No.", ErrorText);
                            end;
                        until VATStmtLine2.Next = 0;
                end;
            VATStmtLine2.Type::Description:
                ;
        end;

        exit(true);
    end;

    local procedure CalcTotalAmount(VATStmtLine2: Record "VAT Statement Line"; var TotalAmount: Decimal; var TotalEmpty: Decimal; var TotalBase: Decimal; var TotalUnrealizedAmount: Decimal; var TotalUnrealizedBase: Decimal)
    begin
        if VATStmtLine2."Calculate with" = 1 then
            Amount := -Amount;
        if PrintInIntegers and VATStmtLine2.Print then
            Amount := Round(Amount, 1, '<');

        case VATStmtLine2."Amount Type" of
            VATStmtLine2."Amount Type"::" ":
                TotalEmpty := TotalEmpty + Amount;
            VATStmtLine2."Amount Type"::Base:
                TotalBase := TotalBase + Amount;
            VATStmtLine2."Amount Type"::Amount:
                TotalAmount := TotalAmount + Amount;
            VATStmtLine2."Amount Type"::"Unrealized Amount":
                TotalUnrealizedAmount := TotalUnrealizedAmount + Amount;
            VATStmtLine2."Amount Type"::"Unrealized Base":
                TotalUnrealizedBase := TotalUnrealizedBase + Amount;
        end;
    end;

    [Scope('OnPrem')]
    procedure InitializeRequest(var NewVATStatementName: Record "VAT Statement Name"; var NewVATStatementLine: Record "VAT Statement Line"; NewSelection: Option Open,Closed,"Open and Closed"; NewPeriodSelection: Option "Before and Within Period","Within Period"; NewPrintInIntegers: Boolean; NewUseAmtsInAddCurr: Boolean)
    begin
        "VAT Statement Name".Copy(NewVATStatementName);
        "VAT Statement Line".Copy(NewVATStatementLine);
        Selection := NewSelection;
        PeriodSelection := NewPeriodSelection;
        PrintInIntegers := NewPrintInIntegers;
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        if NewVATStatementLine.GetFilter("Date Filter") <> '' then begin
            StartDate := NewVATStatementLine.GetRangeMin("Date Filter");
            EndDateReq := NewVATStatementLine.GetRangeMax("Date Filter");
            EndDate := EndDateReq;
        end else begin
            StartDate := 0D;
            EndDateReq := 0D;
            EndDate := 99991231D
        end;
    end;

    [Scope('OnPrem')]
    procedure ConditionalAdd(Amount: Decimal; AmountToAdd: Decimal; AddCurrAmountToAdd: Decimal): Decimal
    begin
        if UseAmtsInAddCurr then
            exit(Amount + AddCurrAmountToAdd);

        exit(Amount + AmountToAdd);
    end;

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
            exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcAmountVATEntryTotaling(var VATEntry: Record "VAT Entry"; var VATStatementLine: Record "VAT Statement Line")
    begin
    end;
}
