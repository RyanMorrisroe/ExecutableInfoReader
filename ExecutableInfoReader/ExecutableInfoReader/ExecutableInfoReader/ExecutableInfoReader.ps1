Param (
	[string]$fileName,
	[string]$variableRoot = "",
	[string]$strLoadProductVersion = "false",
	[string]$strLoadAssemblyVersion = "false"
)

function CreateVariable([string]$name, [string]$value) {
	Write-Host("Creating variable " + $name);
	Set-VstsTaskVariable -Name $name -Value $value;
}

$loadProductVersion = [System.Convert]::ToBoolean($strLoadProductVersion);
$loadAssemblyVersion = [System.Convert]::ToBoolean($strLoadAssemblyVersion);

$file = Get-Item "$fileName";
$fileVersion = [Version]([System.Diagnostics.FileVersionInfo]::GetVersionInfo($file).FileVersion.split(';')[0]);

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
	CreateVariable "$variableRoot.ProductVersionInfo.Verson.Major" $productVersion.Major;
	CreateVariable "$variableRoot.ProductVersionInfo.Verson.Minor" $productVersion.Minor;
	CreateVariable "$variableRoot.ProductVersionInfo.Verson.Build" $productVersion.Build;
	CreateVariable "$variableRoot.ProductVersionInfo.Verson.Revision" $productVersion.Revision;
}

if($loadAssemblyVersion) {
	try {
		$assemblyVersion = [Version]([System.Reflection.AssemblyName]::GetAssemblyName($file).Version);

		Write-Host("Assembly Version is " + $assemblyVersion);
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version" $assemblyVersion;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Major" $assemblyVersion.Major;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Minor" $assemblyVersion.Minor;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Build" $assemblyVersion.Build;
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Revision" $assemblyVersion.Revision;
	}
	catch {
		Write-Warning("Could not load assembly information - likely because the executable does not contain a manifest");
		Write-Warning("Writing empty values for assembly variables");
		CreateVariable "$variableRoot.AssemblyVersionInfo.Version" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Major" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Minor" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Build" "";
		CreateVariable "$variableRoot.AssemblyVersionInfo.Verson.Revision" "";
	}
}