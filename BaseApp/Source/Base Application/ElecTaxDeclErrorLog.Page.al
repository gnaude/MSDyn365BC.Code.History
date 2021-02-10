page 11415 "Elec. Tax Decl. Error Log"
{
    Caption = 'Elec. Tax Decl. Error Log';
    DataCaptionFields = "Declaration No.";
    Editable = false;
    PageType = List;
    SourceTable = "Elec. Tax Decl. Error Log";

    layout
    {
        area(content)
        {
            repeater(Control1000000)
            {
                ShowCaption = false;
                field("Error Class"; "Error Class")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the error class of the error described in the response message from the tax authority.';
                }
                field("Error Description"; "Error Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the error in the electronic declaration found by the tax authority.';

                    trigger OnDrillDown()
                    begin
                        Message("Error Description");
                    end;
                }
            }
        }
    }

    actions
    {
    }
}
