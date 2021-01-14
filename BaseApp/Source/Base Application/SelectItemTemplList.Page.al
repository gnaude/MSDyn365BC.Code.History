page 1378 "Select Item Templ. List"
{
    Caption = 'Select a template for a new item';
    PageType = List;
    SourceTable = "Item Templ.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the template.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the template.';
                }
            }
        }
    }
}