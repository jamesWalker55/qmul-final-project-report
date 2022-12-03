Write-Output "Building HTML..."
pandoc --defaults config/pandoc/html.yml
Write-Output "Building PDF..."
pandoc --defaults config/pandoc/pdf.yml
Write-Output "Building presentation..."
pandoc --defaults config/pandoc/presentation.yml
Write-Output "Done."
