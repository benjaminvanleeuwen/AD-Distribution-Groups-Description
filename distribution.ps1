#region create variables
$distributionGroups = $null
$managedBy = $null
$description = $null
$distinguishedName = $null
$distributionGroup = $null
$i = $null
$nochanges = 0
$changes = 0
#endregion

#region Get All The Groups In AD Which Are Distribution
$distributionGroups = Get-ADGroup -Filter 'groupcategory -eq "Distribution"' -Properties ManagedBy, Description
#endregion 

#region Loop Through $distributionGroups
foreach ($i in $distributionGroups)
{

    $distinguishedName = $i.ManagedBy
    #Try to get the user information
    try {
        $managedBy = Get-ADUser -Identity $distinguishedName
        $description = "Managed by: " + $managedBy.name
    }

    #If any exeption, try to get group information
    catch [Exception] 
    { 
        $managedBy = Get-ADGroup -Identity $distinguishedName
        $description = "Managed by: " + $managedBy.name
    }
   
   #See if description is up-to-date 
   $distributionGroup = $i.Name 
   if ($i.Description -eq $description)
   {
    $nochanges++
   }
   else
   {
    Set-ADGroup -Identity $distributionGroup -Description $description
    $changes++
   }
   
}
#endregion

Write-Warning "$nochanges unchanged"
Write-Warning "$changes changed"


