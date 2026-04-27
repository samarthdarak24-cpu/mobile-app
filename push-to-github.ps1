Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  GitHub Deployment Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "I need your GitHub credentials to deploy:`n" -ForegroundColor Yellow

$username = Read-Host "Enter your GitHub username"
$reponame = Read-Host "Enter repository name (e.g., ai-micro-learning)"

Write-Host "`n" -ForegroundColor Green
Write-Host "Perfect! Now let's deploy...`n" -ForegroundColor Green

# Remove existing remote if any
git remote remove origin 2>$null

# Add new remote
Write-Host "→ Adding GitHub remote..." -ForegroundColor Cyan
git remote add origin "https://github.com/$username/$reponame.git"

Write-Host "→ Pushing code to GitHub..." -ForegroundColor Cyan
Write-Host "`nNote: You'll need to enter your GitHub Personal Access Token" -ForegroundColor Yellow
Write-Host "Get one at: https://github.com/settings/tokens`n" -ForegroundColor Yellow

# Push to GitHub
git push -u origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  ✓ DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
    
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://github.com/$username/$reponame" -ForegroundColor White
    Write-Host "2. Click 'Actions' tab" -ForegroundColor White
    Write-Host "3. Wait 3-5 minutes for build" -ForegroundColor White
    Write-Host "4. Download APK from Artifacts`n" -ForegroundColor White
    
    Write-Host "Web app will be at:" -ForegroundColor Yellow
    Write-Host "https://$username.github.io/$reponame/`n" -ForegroundColor Cyan
    
    $open = Read-Host "Open GitHub repository now? (Y/N)"
    if ($open -eq "Y" -or $open -eq "y") {
        Start-Process "https://github.com/$username/$reponame"
    }
} else {
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "  Push Failed" -ForegroundColor Red
    Write-Host "========================================`n" -ForegroundColor Red
    
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "1. Repository does not exist - Create it at: https://github.com/new" -ForegroundColor White
    Write-Host "2. Need Personal Access Token - Get at: https://github.com/settings/tokens" -ForegroundColor White
    Write-Host "3. Wrong credentials - Double check username and repo name`n" -ForegroundColor White
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
