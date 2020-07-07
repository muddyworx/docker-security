# Milestone 2

## Thoughts on security scan

* My Hugo-Builder image passed clair's scan, even when changing the version to 3.8. 
I tried clearing the build cache and using the latest clair db. I even moved the 
version back to 3, and still didn't turn up any CVE positives.
* Scanning the Fusionauth image turned up 93 vulnerabilities, 8 of them high.
* It looks like many system components are out of date, so likely the base image 
for this version of Fusionauth is too old.
* There are many unnecessary packages listed for a production build. This increases 
the attack surface. It looks like the base OS may be debian, when a smaller package 
like Alpine should be used.