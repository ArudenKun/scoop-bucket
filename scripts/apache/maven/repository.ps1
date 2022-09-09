param([Parameter(Mandatory)][String] $settings)

$settings[54] = "`n  <localRepository>`"data\`"</localRepository>`n"
Set-Content settings.xml -Value $settings
