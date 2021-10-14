#!/usr/bin/gawk -f
#
# {{ ansible_managed }}
#
# Convert output of /usr/bin/check-support-status (from debian-security-support)
# to machine readable YAML
#
# Upstream script is pretty linear and the output format seems very stable,
# so AWK is a perfect fit for the parsing job
#

/^\*\s+Source:/ {
    sub(/^\*\s+Source:/, "", $0);
    len = split($0, parts, ", ");
    print "- source: " parts[1];
    if (len > 1) {
        print "  support: " parts[2];
    };
    packages_seen = 0;
}

/^\s+Details:/ {
    sub(/^\s+Details: /, "", $0);
    print "  details: " $0;
}

/^\s+-\s/ {
    if (packages_seen == 0) { print "  packages:"; };
    packages_seen++;

    sub(/^\s+-\s/, "", $0);   # remove bullet point
    sub(/\s+\(.*\)/, "", $0); # remove version info
    sub(/:.*/, "", $0);       # remove architecture
    print "  - " $0;
}
