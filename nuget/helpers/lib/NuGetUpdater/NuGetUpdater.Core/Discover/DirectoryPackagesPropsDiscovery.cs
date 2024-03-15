using System.Collections.Immutable;

namespace NuGetUpdater.Core.Discover;

internal static class DirectoryPackagesPropsDiscovery
{
    public static DirectoryPackagesPropsDiscoveryResult? Discover(string repoRootPath, string workspacePath, ImmutableArray<ProjectDiscoveryResult> projectResults, Logger logger)
    {
        var projectResult = projectResults.FirstOrDefault(
            p => p.Properties.TryGetValue("ManagePackageVersionsCentrally", out var property)
                && string.Equals(property.Value, "true", StringComparison.OrdinalIgnoreCase));
        if (projectResult is null)
        {
            logger.Log("  Central Package Management is not enabled.");
            return null;
        }

        var projectFilePath = Path.GetFullPath(projectResult.FilePath, workspacePath);
        if (!MSBuildHelper.TryGetDirectoryPackagesPropsPath(repoRootPath, projectFilePath, out var directoryPackagesPropsPath))
        {
            logger.Log("  No Directory.Packages.props file found.");
            return null;
        }

        var relativeDirectoryPackagesPropsPath = Path.GetRelativePath(workspacePath, directoryPackagesPropsPath);
        var directoryPackagesPropsFile = projectResults.FirstOrDefault(p => p.FilePath == relativeDirectoryPackagesPropsPath);
        if (directoryPackagesPropsFile is null)
        {
            logger.Log($"  No project file found for [{relativeDirectoryPackagesPropsPath}].");
            return null;
        }

        logger.Log($"  Discovered [{directoryPackagesPropsFile.FilePath}] file.");

        var isTransitivePinningEnabled = projectResult.Properties.TryGetValue("EnableTransitivePinning", out var property)
            && string.Equals(property.Value, "true", StringComparison.OrdinalIgnoreCase);

        return new()
        {
            FilePath = directoryPackagesPropsFile.FilePath,
            IsTransitivePinningEnabled = isTransitivePinningEnabled,
            Dependencies = directoryPackagesPropsFile.Dependencies,
        };
    }
}
