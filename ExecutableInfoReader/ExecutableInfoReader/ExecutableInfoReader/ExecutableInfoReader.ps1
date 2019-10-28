function CreateVariable([string]$name, [string]$value) {
	Write-Host("Creating variable " + $name);
	Set-VstsTaskVariable -Name $name -Value $value;
}

$fileName = Get-VstsInput -Name "fileName" -Require;
$variableRoot = Get-VstsInput -Name "variableRoot" -Require;
$loadProductVersion = Get-VstsInput -Name "loadProductVersion" -Require -AsBool;
$loadAssemblyVersion = Get-VstsInput -Name "loadAssemblyVersion" -Require -AsBool;

$file = Get-Item "$fileName";
$fileVersion = [Version]([System.Diagnostics.FileVersionInfo]::GetVersionInfo($file).FileVersion.split(' ')[0]);

Write-Host("File Version is " + $fileVersion);
CreateVariable "$variableRoot.FileVersionInfo.Version" $fileVersion;
CreateVariable "$variableRoot.FileVersionInfo.Verson.Major" $fileVersion.Major;
CreateVariable "$variableRoot.FileVersionInfo.Verson.Minor" $fileVersion.Minor;
CreateVariable "$variableRoot.FileVersionInfo.Verson.Build" $fileVersion.Build;
CreateVariable "$variableRoot.FileVersionInfo.Verson.Revision" $fileVersion.Revision;


if($loadProductVersion) {
	$productVersion = [Version]([System.Diagnostics.FileVersionInfo]::GetVersionInfo($file)).ProductVersion;

	Write-Host("Product Version is " + $productVersion);
	CreateVariable "$variableRoot.ProductVersionInfo.Version" $productVersion;
	CreateVariable "$variableRoot.ProductVersionInfo.Version.Major" $productVersion.Major;
	CreateVariable "$variableRoot.ProductVersionInfo.Version.Minor" $productVersion.Minor;
	CreateVariable "$variableRoot.ProductVersionInfo.Version.Build" $productVersion.Build;
	CreateVariable "$variableRoot.ProductVersionInfo.Version.Revision" $productVersion.Revision;
}

if($loadAssemblyVersion) {
	try {
		$assemblyVersion = [Version]([System.Reflection.AssemblyName]::GetAssemblyName($file).Version);

		Write-Host("Assembly Version is " + $assemblyVersion);
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version" $assemblyVersion;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Major" $assemblyVersion.Major;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Minor" $assemblyVersion.Minor;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Build" $assemblyVersion.Build;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Revision" $assemblyVersion.Revision;
	}
	catch {
		Write-Warning("Could not load assembly information - likely because the executable does not contain a manifest");
		Write-Warning("Writing empty values for assembly variables");
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Major" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Minor" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Build" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version.Revision" "";
	}
}