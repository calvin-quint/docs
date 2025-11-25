$mi = Get-MgServicePrincipal -ServicePrincipalId " "
$graph = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'"

$permissions = @(
    "UserAuthenticationMethod.Read.All",
    "User.Read.All",
    "Directory.Read.All",
    "Group.ReadWrite.All"

)

foreach ($p in $permissions) {
    $role = $graph.AppRoles | Where-Object { $_.Value -eq $p -and $_.AllowedMemberTypes -contains "Application" }
    if ($role) {
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $mi.Id -PrincipalId $mi.Id -ResourceId $graph.Id -AppRoleId $role.Id
        Write-Output "Assigned: $p"
    } else {
        Write-Output "Permission not found or not assignable as application permission: $p"
    }
}
