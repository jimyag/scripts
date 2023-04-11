find . -type f -not -name "*.md" -exec sed -i 's/yourport1/44444/g' {} +
find . -type f -not -name "*.md" -exec sed -i 's/yourport2/44445/g' {} +
find . -type f -not -name "*.md" -exec sed -i 's/yourkey/key/g' {} +