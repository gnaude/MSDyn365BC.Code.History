table 31067 "VIES Declaration Line"
{
    Caption = 'VIES Declaration Line';

    fields
    {
        field(1; "VIES Declaration No."; Code[20])
        {
            Caption = 'VIES Declaration No.';
            TableRelation = "VIES Declaration Header";
        }
        field(2; "Trade Type"; Option)
        {
            Caption = 'Trade Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'New,Cancellation,Correction';
            OptionMembers = New,Cancellation,Correction;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(8; "Related Line No."; Integer)
        {
            Caption = 'Related Line No.';
        }
        field(9; "EU Service"; Boolean)
        {
            Caption = 'EU Service';
        }
        field(10; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(11; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    "Corrected Reg. No." := true;
            end;
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
                if "Amount (LCY)" <> xRec."Amount (LCY)" then
                    "Corrected Amount" := true;
            end;
        }
        field(13; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(14; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(15; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(17; "Number of Supplies"; Decimal)
        {
            BlankNumbers = DontBlank;
            Caption = 'Number of Supplies';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(20; "Corrected Reg. No."; Boolean)
        {
            Caption = 'Corrected Reg. No.';
            Editable = false;
        }
        field(21; "Corrected Amount"; Boolean)
        {
            Caption = 'Corrected Amount';
            Editable = false;
        }
        field(25; "Trade Role Type"; Option)
        {
            Caption = 'Trade Role Type';
            OptionCaption = 'Direct Trade,Intermediate Trade,Property Movement';
            OptionMembers = "Direct Trade","Intermediate Trade","Property Movement";

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckLineType;
            end;
        }
        field(29; "System-Created"; Boolean)
        {
            Caption = 'System-Created';
            Editable = false;
        }
        field(30; "Report Page Number"; Integer)
        {
            Caption = 'Report Page Number';
        }
        field(31; "Report Line Number"; Integer)
        {
            Caption = 'Report Line Number';
        }
    }

    keys
    {
        key(Key1; "VIES Declaration No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount (LCY)", "Number of Supplies";
        }
        key(Key2; "Trade Type", "Country/Region Code", "VAT Registration No.", "Trade Role Type", "EU Service")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key3; "VAT Registration No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen;
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        if ("Line Type" = "Line Type"::Cancellation) and (CurrFieldNo <> FieldNo("Line Type")) then
            Error(CancelModifyErr);
    end;

    var
        VIESDeclarationHeader: Record "VIES Declaration Header";
        CancelModifyErr: Label 'You cannot change Cancellation line.';
        CancelYesTxt: Label 'A', Comment = 'A';
        CancelNoTxt: Label 'N', Comment = 'N';

    local procedure TestStatusOpen()
    begin
        VIESDeclarationHeader.Get("VIES Declaration No.");
        VIESDeclarationHeader.TestField(Status, VIESDeclarationHeader.Status::Open);
    end;

    [Scope('OnPrem')]
    procedure GetTradeRole(): Code[10]
    begin
        case "Trade Role Type" of
            "Trade Role Type"::"Direct Trade":
                if (not "EU Service") and (not "EU 3-Party Intermediate Role") then
                    exit('0');
            "Trade Role Type"::"Property Movement":
                exit('1');
            "Trade Role Type"::"Intermediate Trade":
                if (not "EU Service") and "EU 3-Party Intermediate Role" then
                    exit('2');
        end;
        if "EU Service" then
            exit('3');
    end;

    [Scope('OnPrem')]
    procedure GetCancelCode(): Code[10]
    begin
        if "Line Type" = "Line Type"::Cancellation then
            exit(CancelYesTxt);
        exit(CancelNoTxt);
    end;

    [Scope('OnPrem')]
    procedure GetVATRegNo() VATRegNo: Code[20]
    var
        Country: Record "Country/Region";
    begin
        VATRegNo := "VAT Registration No.";

        if "Country/Region Code" <> '' then begin
            Country.Get("Country/Region Code");
            if CopyStr("VAT Registration No.", 1, StrLen(Country."EU Country/Region Code")) = Country."EU Country/Region Code" then
                VATRegNo := CopyStr("VAT Registration No.", StrLen(Country."EU Country/Region Code") + 1);
        end;
    end;

    [Scope('OnPrem')]
    procedure DrillDownAmountLCY()
    var
        VATEntry: Record "VAT Entry";
        TempVATEntry: Record "VAT Entry" temporary;
        VATPostingSetup: Record "VAT Posting Setup";
        AddToDrillDown: Boolean;
    begin
        VIESDeclarationHeader.Get("VIES Declaration No.");

        VATEntry.SetCurrentKey(Type, "Country/Region Code");
        VATEntry.SetRange(Type, "Trade Type" + 1);
        VATEntry.SetRange("Country/Region Code", "Country/Region Code");
        VATEntry.SetRange("VAT Registration No.", "VAT Registration No.");
        case "Trade Role Type" of
            "Trade Role Type"::"Direct Trade":
                VATEntry.SetRange("EU 3-Party Trade", false);
            "Trade Role Type"::"Intermediate Trade":
                VATEntry.SetRange("EU 3-Party Trade", true);
            "Trade Role Type"::"Property Movement":
                exit;
        end;
        VATEntry.SetRange("VAT Date", VIESDeclarationHeader."Start Date", VIESDeclarationHeader."End Date");
        VATEntry.SetRange("EU Service", "EU Service");
        if VATEntry.FindSet then
            repeat
                AddToDrillDown := false;
                if VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group") then begin
                    case "Trade Type" of
                        "Trade Type"::Sale:
                            AddToDrillDown := VATPostingSetup."VIES Sales";
                        "Trade Type"::Purchase:
                            AddToDrillDown := VATPostingSetup."VIES Purchases";
                    end;
                    if AddToDrillDown then begin
                        TempVATEntry := VATEntry;
                        TempVATEntry.Insert;
                    end;
                end;
            until VATEntry.Next = 0;

        PAGE.Run(0, TempVATEntry);
    end;

    [Scope('OnPrem')]
    procedure CheckLineType()
    begin
        if "Line Type" = "Line Type"::Cancellation then
            Error(CancelModifyErr);
    end;
}
