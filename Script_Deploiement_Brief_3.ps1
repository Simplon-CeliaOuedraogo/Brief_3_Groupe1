try {

az group create -l francecentral -n GiteaFirst
    if ($? -eq $false) {
        $erreur = "la création du groupe de ressource GiteaFirst a échoué"
        throw ''
    }

az network vnet create `
    -g GiteaFirst `
    -n GiteaVnet `
    --address-prefix 10.0.1.0/24
    if ($? -eq $false) {
        $erreur = "la création du Vnet GiteaVnet a échoué"
        throw ''
    }

az network vnet subnet create `
    -g GiteaFirst `
    --vnet-name GiteaVnet `
    --name AzureBastionSubnet `
    --address-prefixes 10.0.1.64/26
    if ($? -eq $false) {
        $erreur = "la création du Subnet SubnetBastion a échoué"
        throw ''
    }

az network vnet subnet create `
    -g GiteaFirst `
    --vnet-name GiteaVnet `
    --name GiteaSubnet `
    --address-prefixes 10.0.1.0/29
    if ($? -eq $false) {
        $erreur = "la création du Subnet GiteaSubnet a échoué"
        throw ''
    }

az network public-ip create `
    -g GiteaFirst -n MyFirstPublicIpBastion --sku Standard -z 1
     if ($? -eq $false) {
        $erreur = "la création de l'IP public Bastion a échoué"
        throw ''
    }

    az network bastion create --only-show-errors -l francecentral `
     -n Bastion `
	--public-ip-address MyFirstPublicIpBastion `
	-g GiteaFirst `
    --vnet-name GiteaVnet
     if ($? -eq $false) {
        $erreur = "la création du service Bastion a échoué"
        throw ''
    }
    az mysql server create -l francecentral `
    -g GiteaFirst `
    -n GiteaSQLsvr `
    -u Gitea `
     -p $Env:passwdSQL `
     --sku-name B_Gen5_1 `
     --ssl-enforcement Enabled `
     --minimal-tls-version TLS1_0 `
     --public-network-access Disabled `
	--backup-retention 14 `
    --geo-redundant-backup Enabled `
    --storage-size 51200 `
    --tags "key=value" `
    --version 5.7
    if ($? -eq $false) {
        $erreur = "la création du serveur MYSQL a échoué"
        throw ''
    }
}

catch {
    Write-Host "In CATCH"
    Write-Host $ErrorView
    write-host $Erreur
    #az group delete -n GiteaFirst -y
}
