page 31021 "Purch. Advance Letter Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purch. Advance Letter Line";

    layout
    {
        area(content)
        {
            repeater(Control1220019)
            {
                ShowCaption = false;
                field("Advance G/L Account No."; "Advance G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies G/L account number for advance. It is automatically setup from vendor posting group.';
                }
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the purchase advance letter.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a VAT business posting group code.';
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a VAT product posting group code for the VAT Statement.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies description for purchase advance.';
                }
                field("VAT %"; "VAT %")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the VAT percentage used to calculate Amount Including VAT on this line.';
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ShowMandatory = NOT AmountsIncludingVAT;
                    ToolTip = 'Specifies the amount for the entry.';
                    Visible = false;
                }
                field("VAT Amount"; "VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies VAT amount of advance.';
                    Visible = false;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ShowMandatory = AmountsIncludingVAT;
                    ToolTip = 'Specifies whether the unit price on the line should be displayed including or excluding VAT.';
                }
                field("Amount To Link"; "Amount To Link")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount not yet paid by customer.';
                }
                field("Amount Linked"; "Amount Linked")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount paid by customer.';
                }
                field("Amount To Invoice"; "Amount To Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the paid amount for advance VAT document.';
                }
                field("Amount Invoiced"; "Amount Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount with advance VAT document.';
                }
                field("Amount To Deduct"; "Amount To Deduct")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the maximum advance value for use in final sales invoice.';
                }
                field("Amount Deducted"; "Amount Deducted")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount that was used in final sales invoice.';
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 1, which is defined in the Shortcut Dimension 1 Code field in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 2, which is defined in the Shortcut Dimension 2 Code field in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 3 of line';
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 4 of line';
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 5 of line';
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 6 of line';
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 7 of line';
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    ToolTip = 'Specifies shortcut dimension code No. 8 of line';
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Advance Due Date"; "Advance Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AdvDueDateFieldEditable;
                    ToolTip = 'Specifies when the advance must be paid.';
                    Visible = false;
                }
                field("Amount on Payment Order (LCY)"; "Amount on Payment Order (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount on payment order.';
                    Visible = false;
                }
            }
            group(Control1220023)
            {
                ShowCaption = false;
                field("TotalPurchAdvanceLetterLine.Amount"; TotalPurchAdvanceLetterLine.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = TotalPurchAdvanceLetterHeader."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalPurchAdvanceLetterHeader."Currency Code");
                    Caption = 'Total Amount Excl. VAT';
                    Editable = false;
                    ToolTip = 'Specifies the total amout excl. VAT.';
                }
                field("TotalPurchAdvanceLetterLine.""VAT Amount"""; TotalPurchAdvanceLetterLine."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = TotalPurchAdvanceLetterHeader."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(TotalPurchAdvanceLetterHeader."Currency Code");
                    Caption = 'Total VAT';
                    Editable = false;
                    ToolTip = 'Specifies the total amout of VAT.';
                }
                field("TotalPurchAdvanceLetterLine.""Amount Including VAT"""; TotalPurchAdvanceLetterLine."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = TotalPurchAdvanceLetterHeader."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalPurchAdvanceLetterHeader."Currency Code");
                    Caption = 'Total Amount Incl. VAT';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the total amout incl. VAT.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("L&ine")
            {
                Caption = 'L&ine';
                action(Link)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Link';
                    Ellipsis = true;
                    Image = LinkWithExisting;
                    ToolTip = 'Allow the connection to the advance payment.';

                    trigger OnAction()
                    begin
                        SetLink;
                    end;
                }
                action(Unlink)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unlink';
                    Ellipsis = true;
                    Image = UnLinkAccount;
                    ToolTip = 'Allow the disconnection to the advance payment.';

                    trigger OnAction()
                    begin
                        RemoveLinks;
                    end;
                }
                action("Change VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change VAT Prod. Posting Group';
                    ToolTip = 'The function allows VAT product posting group to change.';

                    trigger OnAction()
                    begin
                        ChangeVATProdPostingGr;
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Specifies advance dimensions.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'Specifies advance comments.';

                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.PurchaseAdvanceUpdateTotalsControls(
          Rec, TotalPurchAdvanceLetterHeader, TotalPurchAdvanceLetterLine);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        GetAdvDueDateFieldEditable;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchAdvanceLetterHeader: Record "Purch. Advance Letter Header";
    begin
        Clear(ShortcutDimCode);
        if "Letter No." <> '' then begin
            PurchAdvanceLetterHeader.Get("Letter No.");
            SetShowMandatoryConditions(PurchAdvanceLetterHeader);
        end;
    end;

    trigger OnOpenPage()
    begin
        SetDimensionsVisibility;
    end;

    var
        TotalPurchAdvanceLetterHeader: Record "Purch. Advance Letter Header";
        TotalPurchAdvanceLetterLine: Record "Purch. Advance Letter Line";
        PurchAdvanceLetterHeaderGre: Record "Purch. Advance Letter Header";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array[8] of Code[20];
        AdvDueDateFieldEditable: Boolean;
        AmountsIncludingVAT: Boolean;
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;

    [Scope('OnPrem')]
    procedure SetLink()
    var
        PrepmtLinksMgt: Codeunit "Prepayment Links Management";
    begin
        PrepmtLinksMgt.RunPurchLetterLink(Rec);
    end;

    [Scope('OnPrem')]
    procedure RemoveLinks()
    var
        AdvanceLink: Record "Advance Link";
        PurchPostAdvances: Codeunit "Purchase-Post Advances";
        LinksToAdvanceLetter: Page "Links to Advance Letter";
    begin
        AdvanceLink.FilterGroup(0);
        AdvanceLink.SetCurrentKey("Document No.", "Line No.", "Entry Type");
        AdvanceLink.SetRange("Entry Type", AdvanceLink."Entry Type"::"Link To Letter");
        AdvanceLink.SetRange("Document No.", "Letter No.");
        AdvanceLink.SetRange("Invoice No.", '');
        AdvanceLink.SetRange(Type, AdvanceLink.Type::Purchase);
        AdvanceLink.FilterGroup(2);
        LinksToAdvanceLetter.SetTableView(AdvanceLink);
        LinksToAdvanceLetter.LookupMode(true);
        if LinksToAdvanceLetter.RunModal = ACTION::LookupOK then begin
            LinksToAdvanceLetter.GetSelection(AdvanceLink);
            PurchPostAdvances.RemoveLinks("Letter No.", AdvanceLink);
        end;
    end;

    [Scope('OnPrem')]
    procedure ChangeVATProdPostingGr()
    var
        PurchAdvanceLetterLine: Record "Purch. Advance Letter Line";
    begin
        PurchAdvanceLetterLine := Rec;
        PurchAdvanceLetterLine.Find;
        PurchAdvanceLetterLine.ChangeVATProdPostingGroup;
        CurrPage.Update(false);
    end;

    [Scope('OnPrem')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    [Scope('OnPrem')]
    procedure GetAdvDueDateFieldEditable()
    begin
        if "Letter No." <> PurchAdvanceLetterHeaderGre."No." then
            if not PurchAdvanceLetterHeaderGre.Get("Letter No.") then
                Clear(PurchAdvanceLetterHeaderGre);
        AdvDueDateFieldEditable := PurchAdvanceLetterHeaderGre."Due Date from Line";
    end;

    [Scope('OnPrem')]
    procedure SetAdvDueDateFieldEditable(SetEditable: Boolean)
    begin
        PurchAdvanceLetterHeaderGre."Due Date from Line" := SetEditable;
        AdvDueDateFieldEditable := PurchAdvanceLetterHeaderGre."Due Date from Line";
        CurrPage.Update(false);
    end;

    [Scope('OnPrem')]
    procedure SetShowMandatoryConditions(PurchAdvanceLetterHdr: Record "Purch. Advance Letter Header")
    begin
        AmountsIncludingVAT := PurchAdvanceLetterHdr."Amounts Including VAT";
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;
}

