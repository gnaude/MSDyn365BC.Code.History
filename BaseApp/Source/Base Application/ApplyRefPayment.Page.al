page 32000002 "Apply Ref. Payment"
{
    Caption = 'Apply Ref. Payment';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Ref. Payment - Imported";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Posted to G/L" = CONST(false),
                            "Record ID" = FILTER(3 .. 5));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Banks Posting Date"; "Banks Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date that is used by the bank.';
                }
                field("Banks Payment Date"; "Banks Payment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment date used by the bank.';
                    Visible = false;
                }
                field("Bank Account Code"; "Bank Account Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a bank account code for the reference payment.';
                }
                field("Filing Code"; "Filing Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a filing code for the reference payment.';
                }
                field("Reference No."; "Reference No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reference number that is calculated from a reference number sequence.';
                }
                field("Payers Name"; "Payers Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer name that is associated with the reference payment.';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment amount for the reference payment.';
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a customer number for the reference payment.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description for the reference payment.';
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an entry number for the reference payment.';

                    trigger OnValidate()
                    begin
                        if "Entry No." <> 0 then begin
                            "Matched Date" := Today;
                            "Matched Time" := Time;
                            Matched := true;
                        end else begin
                            "Matched Date" := 0D;
                            "Matched Time" := 0T;
                            Matched := false;
                        end
                    end;
                }
                field(Matched; Matched)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if you want to filter payments according to date or time.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

