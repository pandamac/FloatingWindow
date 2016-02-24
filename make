cp -r ./LatestBuild/FloatingWindow.dylib ./FloatingWindow/Package/Library/MobileSubstrate/DynamicLibraries/
dpkg-deb -b ./FloatingWindow/Package
scp ./FloatingWindow/Package.deb i5s3:/
#rm -r ./rootApp/Package/Applications/rootApp.app
#rm -r ./rootApp/Package.deb
#rm -r ./LatestBuild/rootApp.app
