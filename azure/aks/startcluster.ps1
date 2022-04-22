function startCluster {
    param (
        [string]$clusterName,
        [string]$resourceGroupName
    )

    begin {
        $azShow = az account show

        if ($azShow -like $null) {
            Write-Error "you are not logged into the AZ CLI."
            $option = Read-Host "Would you like to log in? 1 for yes or 2 for no"
        }

        switch ($option) {
            '1' { az login }
            '2' {exit}
        }
    }

    process {
        az aks start `
        --name $clusterName `
        --resource-group $resourceGroupName
    }

    end {

    }
}