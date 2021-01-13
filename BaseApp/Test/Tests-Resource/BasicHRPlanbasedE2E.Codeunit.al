codeunit 135400 "Basic HR Plan-based E2E"
{
    Subtype = Test;

    trigger OnRun()
    begin
        // [FEATURE] [HR] [UI] [User Group Plan]
    end;

    var
        Assert: Codeunit Assert;
        LibraryUtility: Codeunit "Library - Utility";
        LibraryHumanResource: Codeunit "Library - Human Resource";
        IsInitialized: Boolean;
        MissingPermissionsErr: Label 'You do not have the following permissions on TableData';

    local procedure Initialize()
    var
        ExperienceTierSetup: Record "Experience Tier Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        LibraryHumanResource: Codeunit "Library - Human Resource";
        LibraryNotificationMgt: Codeunit "Library - Notification Mgt.";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        AzureADPlanTestLibrary: Codeunit "Azure AD Plan Test Library";
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"Basic HR Plan-based E2E");

        LibraryNotificationMgt.ClearTemporaryNotificationContext;
        ApplicationAreaMgmtFacade.SaveExperienceTierCurrentCompany(ExperienceTierSetup.FieldCaption(Essential));

        // Lazy Setup
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"Basic HR Plan-based E2E");

        LibraryHumanResource.SetupEmployeeNumberSeries;

        IsInitialized := true;
        Commit;

        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"Basic HR Plan-based E2E");

        // Populate table Plan if empty
        AzureADPlanTestLibrary.PopulatePlanTable();
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsBusinessManager()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Business Manager
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        // [WHEN] Create/Modify/Delete Employee
        // Create Employee
        CreateEmployee;
        // Modify Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // Delete Employee
        Employee.Delete(true);

        // [THEN] Create/Modify/Delete are allowed
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsExternalAccountant()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Accountant
        LibraryE2EPlanPermissions.SetExternalAccountantPlan;
        // [WHEN] Create/Modify/Delete Employee
        // Create Employee
        CreateEmployee;
        // Modify Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // Delete Employee
        Employee.Delete(true);

        // [THEN] Create/Modify/Delete are allowed
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsTeamMember()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Team Member
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // Create Employee with wrong permissions and then create one with full-permissions, so that it can be modified later
        CreateEmployeeWithPermissionError;
        LibraryE2EPlanPermissions.SetBusinessManagerPlan;
        LibraryHumanResource.CreateEmployee(Employee);
        LibraryE2EPlanPermissions.SetTeamMemberPlan;
        // [WHEN] Modify existing Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // [THEN] Read and Modify are allowed
        // [WHEN] Delete Employee
        asserterror Employee.Delete(true);
        // [THEN] Error: 'Missing Permissions'
        Assert.ExpectedError(MissingPermissionsErr);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsEssentialISVEmbUser()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Essential ISV Emb User
        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        // [WHEN] Create/Modify/Delete Employee
        // Create Employee
        CreateEmployee;
        // Modify Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // Delete Employee
        Employee.Delete(true);

        // [THEN] Create/Modify/Delete are allowed
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsTeamMemberISVEmb()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Team Member
        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;

        // Create Employee with wrong permissions and then create one with full-permissions, so that it can be modified later
        CreateEmployeeWithPermissionError;

        // Check that Team Member ISV Emb cannot create Employees
        asserterror LibraryHumanResource.CreateEmployee(Employee);
        Assert.ExpectedError(MissingPermissionsErr);

        // Create employee as Essential ISV Emb User
        LibraryE2EPlanPermissions.SetEssentialISVEmbUserPlan;
        LibraryHumanResource.CreateEmployee(Employee);

        LibraryE2EPlanPermissions.SetTeamMemberISVEmbPlan;
        // [WHEN] Modify existing Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // [THEN] Read and Modify are allowed
        // [WHEN] Delete Employee
        asserterror Employee.Delete(true);
        // [THEN] Error: 'Missing Permissions'
        Assert.ExpectedError(MissingPermissionsErr);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure E2EBasicHREmployeeAsDeviceISVEmbUser()
    var
        Employee: Record Employee;
        LibraryE2EPlanPermissions: Codeunit "Library - E2E Plan Permissions";
    begin
        Initialize;

        // [GIVEN] Employee as Device ISV Emb User
        LibraryE2EPlanPermissions.SetDeviceISVEmbUserPlan;
        // [WHEN] Create/Modify/Delete Employee
        // Create Employee
        CreateEmployee;
        // Modify Employee
        Employee.FindFirst;
        ModifyEmployee(Employee."No.");
        // Delete Employee
        Employee.Delete(true);

        // [THEN] Create/Modify/Delete are allowed
    end;

    local procedure CreateEmployee()
    var
        Employee: Record Employee;
        EmployeeCard: TestPage "Employee Card";
    begin
        EmployeeCard.OpenNew;
        EmployeeCard."First Family Name".SetValue(
          CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Employee."First Family Name")),
            1, MaxStrLen(Employee."First Family Name")));
        EmployeeCard."Second Family Name".SetValue(
          CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Employee."Second Family Name")),
            1, MaxStrLen(Employee."Second Family Name")));
        EmployeeCard."E-Mail".SetValue(LibraryUtility.GenerateRandomEmail);
        EmployeeCard."Job Title".SetValue(
          CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Employee."Job Title")), 1, MaxStrLen(Employee."Job Title")));
        EmployeeCard.Address.Activate;
        EmployeeCard.OK.Invoke;
    end;

    local procedure ModifyEmployee(EmployeeNo: Code[20])
    var
        Employee: Record Employee;
        EmployeeCard: TestPage "Employee Card";
    begin
        EmployeeCard.OpenEdit;
        EmployeeCard.GotoKey(EmployeeNo);
        EmployeeCard."E-Mail".SetValue(LibraryUtility.GenerateRandomEmail);
        EmployeeCard.Address.SetValue(
          CopyStr(LibraryUtility.GenerateRandomText(MaxStrLen(Employee.Address)), 1, MaxStrLen(Employee.Address)));
        EmployeeCard.OK.Invoke;
    end;

    local procedure CreateEmployeeWithPermissionError()
    var
        EmployeeCard: TestPage "Employee Card";
    begin
        asserterror EmployeeCard.OpenNew;
        Assert.ExpectedErrorCode('DB:ClientInsertDenied');
    end;
}

