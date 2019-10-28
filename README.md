# ExecutableInfoReader
Azure DevOps extension that reads file, program, and optionally assembly info from executables (and dlls). Inspired by [Paul Appeldoorn's AssemblyVersionLoader Extension](https://github.com/appiepau/AssemblyVersionLoader), however this focuses first on reading from executables instead of dlls.

# Usage
Set the Variable Root Prefix to the value that you want the generated variables to be prefixed by. For instance, if you set the Variable Root Prefix to "Foo" then the variables would be:

|Variable Name|Description|
|-------------|-----------|
|Foo.FileVersionInfo.Version|The full version string from the File Version property|
|Foo.FileVersionInfo.Version.Major|The major version from the File Version property|
|Foo.FileVersionInfo.Version.Minor|The minor version from the File Version property|
|Foo.FileVersionInfo.Version.Build|The build version from the File Version property|
|Foo.FileVersionInfo.Version.Revision|The revision version from the File Version property|
|Foo.ProductVersionInfo.Version|The full version string from the Product Version property|
|Foo.ProductVersionInfo.Version.Major|The major version from the Product Version property|
|Foo.ProductVersionInfo.Version.Minor|The minor version from the Product Version property|
|Foo.ProductVersionInfo.Version.Build|The build version from the Product Version property|
|Foo.ProductVersionInfo.Version.Revision|The revision version from the Product Version property|
|Foo.AssemblyVersionInfo.Version|The full version string from the Assembly Version property|
|Foo.AssemblyVersionInfo.Version.Major|The major version from the Assembly Version property|
|Foo.AssemblyVersionInfo.Version.Minor|The minor version from the Assembly Version property|
|Foo.AssemblyVersionInfo.Version.Build|The build version from the Assembly Version property|
|Foo.AssemblyVersionInfo.Version.Revision|The revision version from the Assembly Version property|

## Important Notes:
* File Version can occassionally have extra text outside of just the version information (for instance, take a look at iexplore.exe on Windows 10). Any extra information is stripped off by this utility. 
* Many executables do not have Assembly Version information because they do not contain readable manifests. When that occurs and the option to output Assembly Version information is enabled, a warning will be emitted and empty strings will be written to the AssemblyVersionInfo variables.
