Write-Output "Building..."
pandoc --defaults config/pandoc/html.yml
pandoc --defaults config/pandoc/pdf.yml
Write-Output "Done."
