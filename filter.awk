BEGIN {
	FS=";";
	includeCount=0;
	excludeCount=0;
	if (length(include) > 0) {
		includeCount=split(include, inclusions, ",");
	} else if (length(exclude) > 0) {
		excludeCount=split(exclude, exclusions, ",");
	}
}

# returns 1 (true), if app is listed in inclusions or not listed in exclusions.
function shouldIncludeApp(appId) {
	if (includeCount == 0 && excludeCount == 0) {
		return 1;
	} else if (includeCount > 0) {
		for (i in inclusions) {
			if (inclusions[i] == appId) {
				return 1;
			}
		}
		return 0;
	} else if (excludeCount > 0) {
		for (e in exclusions) {
			if (exclusions[e] == appId) {
				return 0;
			}
		}
		return 1;
	} else {
		return 0;
	}
}
# first row is header
(FNR==1) {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency)
	print $0;
}

# further rows
(FNR>1) {
	appId=$3
	if (shouldIncludeApp(appId)) {
		print $0;
	}
}