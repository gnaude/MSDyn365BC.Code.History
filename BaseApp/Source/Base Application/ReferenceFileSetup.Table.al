table 32000000 "Reference File Setup"
{
    Caption = 'Reference File Setup';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Bank Account"."No.";
        }
        field(2; "Export Reference Payments"; Text[250])
        {
            Caption = 'Export Reference Payments';
            ObsoleteReason = 'This field is obsolete after refactoring.';
            ObsoleteState = Removed;
        }
        field(3; "Export Foreign Payments"; Text[250])
        {
            Caption = 'Export Foreign Payments';
            ObsoleteReason = 'This field is obsolete after refactoring.';
            ObsoleteState = Removed;
        }
        field(4; "Import Reference Payments"; Text[250])
        {
            Caption = 'Import Reference Payments';
            ObsoleteReason = 'This field is obsolete after refactoring.';
            ObsoleteState = Removed;
        }
        field(8; "Exchange Rate Contract No."; Code[14])
        {
            Caption = 'Exchange Rate Contract No.';
        }
        field(9; "Due Date Handling"; Option)
        {
            Caption = 'Due Date Handling';
            OptionCaption = 'Batch,Transaction';
            OptionMembers = Batch,Transaction;
        }
        field(11; "Batch by Payment Date"; Boolean)
        {
            Caption = 'Batch by Payment Date';
        }
        field(13; "Currency Exchange Rate File"; Text[250])
        {
            Caption = 'Currency Exchange Rate File';
            ObsoleteReason = 'This field is obsolete after refactoring.';
            ObsoleteState = Removed;
        }
        field(14; "Default Payment Method"; Code[1])
        {
            Caption = 'Default Payment Method';
            TableRelation = "Foreign Payment Types".Code WHERE("Code Type" = CONST("Payment Method"));
        }
        field(15; "Default Service Fee Code"; Code[1])
        {
            Caption = 'Default Service Fee Code';
            TableRelation = "Foreign Payment Types".Code WHERE("Code Type" = CONST("Service Fee"));
        }
        field(16; "Inform. of Appl. Cr. Memos"; Boolean)
        {
            Caption = 'Inform. of Appl. Cr. Memos';
        }
        field(17; "Allow Comb. Domestic Pmts."; Boolean)
        {
            Caption = 'Allow Comb. Domestic Pmts.';
            Editable = false;

            trigger OnValidate()
            begin
                RefFileSetup.SetFilter("No.", '<>%1', "No.");
                RefFileSetup.ModifyAll(RefFileSetup."Allow Comb. Domestic Pmts.", "Allow Comb. Domestic Pmts.")
            end;
        }
        field(18; "Allow Comb. Foreign Pmts."; Boolean)
        {
            Caption = 'Allow Comb. Foreign Pmts.';

            trigger OnValidate()
            begin
                RefFileSetup.SetFilter("No.", '<>%1', "No.");
                RefFileSetup.ModifyAll(RefFileSetup."Allow Comb. Foreign Pmts.", "Allow Comb. Foreign Pmts.")
            end;
        }
        field(19; "Payment Journal Template"; Code[10])
        {
            Caption = 'Payment Journal Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(20; "Payment Journal Batch"; Code[10])
        {
            Caption = 'Payment Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template"));
        }
        field(21; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(22; "Bank Party ID"; Code[20])
        {
            Caption = 'Bank Party ID';

            trigger OnValidate()
            begin
                if "Bank Party ID" <> '' then
                    if not (StrLen("Bank Party ID") in [8 .. 13]) then
                        FieldError("Bank Party ID", Text13400);
            end;
        }
        field(23; "Allow Comb. SEPA Pmts."; Boolean)
        {
            Caption = 'Allow Comb. SEPA Pmts.';

            trigger OnValidate()
            begin
                RefFileSetup.SetFilter("No.", '<>%1', "No.");
                RefFileSetup.ModifyAll("Allow Comb. SEPA Pmts.", "Allow Comb. SEPA Pmts.")
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RefFileSetup: Record "Reference File Setup";
        Text13400: Label 'is not valid with respect to minimal length 8 and maximal length 13.';
}

