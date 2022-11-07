Write-Output "Building HTML..."
pandoc --defaults config/pandoc/html.yml
Write-Output "Building PDF..."
pandoc --defaults config/pandoc/pdf.yml
Write-Output "Done."
