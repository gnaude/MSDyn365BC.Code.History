// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 13666 "OIOUBL-Fin Charg Memo Iss Sub"
{
    [EventSubscriber(ObjectType::Codeunit, 395, 'OnBeforeIssueFinChargeMemo', '', false, false)]
    procedure OnBeforeIssueFinChargeMemoRunCheck(var FinChargeMemoHeader: Record "Finance Charge Memo Header");
    var
        OIOUBLCheckFinChargeMemo: Codeunit "OIOUBL-Check Fin. Charge Memo";
    begin
        OIOUBLCheckFinChargeMemo.RUN(FinChargeMemoHeader);
    end;

}