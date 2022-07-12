function Check-Branch-Remote{
    $branchesRemotes = git ls-remote
    $branchesLocais = git branch
    $branchAtual = git rev-parse --abbrev-ref HEAD
    $branchesFixos = "develop", "master", "qa"
    $branchesParaRemover = @()

    ForEach ($branchLocal in $branchesLocais) {
        $branchLocal = $branchLocal.Trim().replace("* ", "")
        $contemBranch = 0
        ForEach($branchRemoto in $branchesRemotes){            
            if ($branchRemoto.contains($branchLocal)){
                $contemBranch = 1;
            }
        }

        if ($contemBranch.Equals(0) -And $branchLocal -notcontains $branchAtual.Trim() -And $branchesFixos -notcontains $branchLocal){
            $branchesParaRemover += $branchLocal.Trim()
        }
    }

    echo "======================================================"
    echo "Foram encontrados $($branchesParaRemover.Length) branches para remover localmente."
    echo "======================================================"

    ForEach($branchRemover in $branchesParaRemover){
        $resposta = Read-Host "Deseja remover localmente o branch $($branchRemover)? (S\N)"
        if ($resposta.ToUpper().Equals("S")){
            git branch --delete $branchRemover
            echo ""
        }
    }
}
Set-Alias -Name clean-branches -Value Check-Branch-Remote
