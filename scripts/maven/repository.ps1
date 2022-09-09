param([Parameter(Mandatory)][String] $settings, [Parameter(Mandatory)][String] $dir)
$CONST = Get-Content $settings
$CONST[54] = "`n  <localRepository>`"$dir\\data\\repository`"</localRepository>`n"
Set-Content -LiteralPath $settings -Value $CONST
