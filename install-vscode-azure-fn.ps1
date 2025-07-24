# install-vscode-azure-fn.ps1
# PowerShell script to install VS Code, Azure CLI, Azure Functions Core Tools,
# and recommended tools for Azure Functions development

Write-Host "🔧 Starting Azure Functions development environment setup..." -ForegroundColor Cyan

# Helper: Install if not already installed
function Install-App {
    param (
        [string]$PackageId,
        [string]$DisplayName = $PackageId
    )

    if (-not (winget list --id $PackageId | Select-String $PackageId)) {
        Write-Host "📦 Installing $DisplayName..." -ForegroundColor Yellow
        winget install --id $PackageId --source winget --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "✅ $DisplayName already installed." -ForegroundColor Green
    }
}

# Install Visual Studio Code
Install-App -PackageId "Microsoft.VisualStudioCode" -DisplayName "Visual Studio Code"

# Install Azure CLI
Install-App -PackageId "Microsoft.AzureCLI" -DisplayName "Azure CLI"

# Install Azure Functions Core Tools v4
Install-App -PackageId "Microsoft.AzureFunctionsCoreTools" -DisplayName "Azure Functions Core Tools"

# Install Node.js LTS (required for JavaScript/TypeScript Functions)
Install-App -PackageId "OpenJS.NodeJS.LTS" -DisplayName "Node.js LTS"

# Install Git (useful for source control)
Install-App -PackageId "Git.Git" -DisplayName "Git"

# Optional: Python (used in some Azure extensions)
Install-App -PackageId "Python.Python.3" -DisplayName "Python 3"

# Optional: .NET 8 SDK (for C# Azure Functions)
Install-App -PackageId "Microsoft.DotNet.SDK.8" -DisplayName ".NET SDK 8"

# Wrapper: Call Azure CLI in a scriptable way
function Invoke-AzCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        Write-Warning "Azure CLI not found in PATH. Is it installed correctly?"
        return
    }

    Write-Host "`n💻 Executing: az $Command`n" -ForegroundColor Cyan
    az $Command
}

# Example usage (disabled by default):
# Invoke-AzCommand -Command "version"

Write-Host "`n🎉 Setup complete. You’re ready to build Azure Functions in VS Code!" -ForegroundColor Cyan
