param([Parameter(Mandatory)][String] $dir, [Parameter(Mandatory)][String] $persist_dir)

if (!(Test-Path "$persist_dir\conf\settings.xml")) {

    $current = (Split-Path $dir | Join-Path -ChildPath 'current') -replace '\\', '/'

    $repository = Get-Content "$dir\conf\settings.xml"
    $repository[54] = "`n  <localRepository>`"`$1$current\\data\\repository`"</localRepository>`n"
    Set-Content -LiteralPath $repository -Value $repository
}
