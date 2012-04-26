From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2 V2] infiniband-diags: mark duplicate/lower performing
 scripts as deprecated.
Date: Wed, 25 Apr 2012 21:49:35 -0700
Message-ID: <20120425214935.1613e6ce.weiny2@llnl.gov>
References: <20120425164522.230b1f25.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120425164522.230b1f25.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Inform user of alternatives if available.

Changes since V1:
	Add set_nodedesc.sh

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/infiniband-diags.8.in   |    2 +-
 scripts/ibcheckerrors.in    |    7 ++++---
 scripts/ibcheckerrs.in      |    8 ++++++++
 scripts/ibchecknet.in       |    9 +++++----
 scripts/ibchecknode.in      |    8 ++++++++
 scripts/ibcheckport.in      |    8 ++++++++
 scripts/ibcheckportstate.in |    8 ++++++++
 scripts/ibcheckportwidth.in |    8 ++++++++
 scripts/ibcheckstate.in     |    6 ++++--
 scripts/ibcheckwidth.in     |    5 +++--
 scripts/ibclearcounters.in  |    1 +
 scripts/ibclearerrors.in    |    1 +
 scripts/ibdatacounters.in   |    8 +++++---
 scripts/ibdatacounts.in     |    8 ++++++++
 scripts/ibdiscover.pl       |    9 +++++++++
 scripts/iblinkinfo.pl.in    |    4 +++-
 scripts/ibprintca.pl        |    2 ++
 scripts/ibprintrt.pl        |    2 ++
 scripts/ibprintswitch.pl    |    2 ++
 scripts/ibqueryerrors.pl.in |    5 +++--
 scripts/set_nodedesc.sh     |    3 +++
 21 files changed, 96 insertions(+), 18 deletions(-)

diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
index f0671ca..c1e9995 100644
--- a/man/infiniband-diags.8.in
+++ b/man/infiniband-diags.8.in
@@ -183,7 +183,7 @@ perform the lookup.
 .TP
 \fBLocal HCA info\fR
 
-	See: ibstat, ibstatus,
+	See: ibstat, ibstatus
 
 .TP
 \fBConnectivity check\fR
diff --git a/scripts/ibcheckerrors.in b/scripts/ibcheckerrors.in
index fef503c..ca40a68 100644
--- a/scripts/ibcheckerrors.in
+++ b/scripts/ibcheckerrors.in
@@ -80,12 +80,12 @@ BEGIN {
 }
 function check_node(lid, port)
 {
-	if (system("'$IBPATH'/ibchecknode '"$ca_info"' '$gflags' '$verbose' " lid)) {
+	if (system("'$IBPATH'/ibchecknode -S '"$ca_info"' '$gflags' '$verbose' " lid)) {
 		ne++
 		print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
 		return 1;
 	}
-	if (system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+	if (system("'$IBPATH'/ibcheckerrs -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
 		return 2;
 	return 0;
 }
@@ -115,7 +115,7 @@ function check_node(lid, port)
 			if (check_node(lid, port) == 2)
 				pcnterr++;
 		} else if (err &&
-			   system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+			   system("'$IBPATH'/ibcheckerrs -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
 			pcnterr++;
 }
 
@@ -125,6 +125,7 @@ function check_node(lid, port)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors\""
 	printf "\n## Summary: %d nodes checked, %d bad nodes found\n", nnodes, ne
 	printf "##          %d ports checked, %d ports have errors beyond threshold\n", nports, pcnterr
 	exit (ne + pcnterr)
diff --git a/scripts/ibcheckerrs.in b/scripts/ibcheckerrs.in
index 4db0929..4b34efc 100644
--- a/scripts/ibcheckerrs.in
+++ b/scripts/ibcheckerrs.in
@@ -67,6 +67,7 @@ bw=""
 verbose=""
 brief=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -96,6 +97,9 @@ while [ "$1" ]; do
 		show_thresholds
 		exit 0
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-P | -C | -t | -timeout)
 		case $2 in
 		-*)
@@ -135,6 +139,10 @@ else
 	portname=$2
 fi
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors\"\n\n" 1>&2
+fi
+
 if [ "$guid_addr" ]; then
 	if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit -1} {print $3}'`; then
 		echo -n "guid $1 address resolution: "
diff --git a/scripts/ibchecknet.in b/scripts/ibchecknet.in
index a6d5b1a..75bc45a 100644
--- a/scripts/ibchecknet.in
+++ b/scripts/ibchecknet.in
@@ -74,12 +74,12 @@ BEGIN {
 }
 function check_node(lid, port)
 {
-	if (system("'$IBPATH'/ibchecknode '"$ca_info"' '$gflags' '$verbose' " lid)) {
+	if (system("'$IBPATH'/ibchecknode -S '"$ca_info"' '$gflags' '$verbose' " lid)) {
 		ne++
 		print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
 		return 1;
 	}
-	if (system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+	if (system("'$IBPATH'/ibcheckerrs -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
 		return  2;
 	return 0;
 }
@@ -109,9 +109,9 @@ function check_node(lid, port)
 			if (check_node(lid, port) == 2)
   				pcnterr++;
 		} else if (err &&
-			   system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
+			   system("'$IBPATH'/ibcheckerrs -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port))
 			pcnterr++;
-		if (system("'$IBPATH'/ibcheckport'"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
+		if (system("'$IBPATH'/ibcheckport -S '"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
 			if (!'$v' && oldlid != lid) {
 				print "# Checked " ntype ": nodeguid 0x" nodeguid " with failure"
 				oldlid = lid
@@ -126,6 +126,7 @@ function check_node(lid, port)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors -f\""
 	printf "\n## Summary: %d nodes checked, %d bad nodes found\n", nnodes, ne
 	printf "##          %d ports checked, %d bad ports found\n", nports, pe
 	printf "##          %d ports have errors beyond threshold\n", pcnterr
diff --git a/scripts/ibchecknode.in b/scripts/ibchecknode.in
index d105430..eac8069 100644
--- a/scripts/ibchecknode.in
+++ b/scripts/ibchecknode.in
@@ -32,6 +32,7 @@ guid_addr=""
 bw=""
 verbose=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -56,6 +57,9 @@ while [ "$1" ]; do
 		ca_info="$ca_info $1 $2"
 		shift
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-*)
 		usage
 		;;
@@ -70,6 +74,10 @@ if [ -z "$1" ]; then
 	usage
 fi
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated; Please use \"smpquery nodeinfo\"\n\n" 1>&2
+fi
+
 if [ "$guid_addr" ]; then
 	if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit -1} {print $3}'`; then
 		echo -n "guid $1 address resolution: "
diff --git a/scripts/ibcheckport.in b/scripts/ibcheckport.in
index 9717288..3c8588e 100644
--- a/scripts/ibcheckport.in
+++ b/scripts/ibcheckport.in
@@ -32,6 +32,7 @@ guid_addr=""
 bw=""
 verbose=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -56,6 +57,9 @@ while [ "$1" ]; do
 		ca_info="$ca_info $1 $2"
 		shift
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-*)
 		usage
 		;;
@@ -72,6 +76,10 @@ fi
 
 portnum=$2
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated\n\n" 1>&2
+fi
+
 if [ "$guid_addr" ]; then
 	if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit -1} {print $3}'`; then
 		echo -n "guid $1 address resolution: "
diff --git a/scripts/ibcheckportstate.in b/scripts/ibcheckportstate.in
index 549d427..eb5e304 100644
--- a/scripts/ibcheckportstate.in
+++ b/scripts/ibcheckportstate.in
@@ -32,6 +32,7 @@ guid_addr=""
 bw=""
 verbose=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -44,6 +45,9 @@ while [ "$1" ]; do
 	-v)
 		verbose=yes
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-P | -C | -t | -timeout)
 		case $2 in
 		-*)
@@ -72,6 +76,10 @@ fi
 
 portnum=$2
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated\n\n" 1>&2
+fi
+
 if [ "$guid_addr" ]; then
 	if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit -1} {print $3}'`; then
 		echo -n "guid $1 address resolution: "
diff --git a/scripts/ibcheckportwidth.in b/scripts/ibcheckportwidth.in
index 3b387be..0df7a11 100644
--- a/scripts/ibcheckportwidth.in
+++ b/scripts/ibcheckportwidth.in
@@ -32,6 +32,7 @@ guid_addr=""
 bw=""
 verbose=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -44,6 +45,9 @@ while [ "$1" ]; do
 	-v)
 		verbose=yes
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-P | -C | -t | -timeout)
 		case $2 in
 		-*)
@@ -72,6 +76,10 @@ fi
 
 portnum=$2
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated\n\n" 1>&2
+fi
+
 if [ "$guid_addr" ]; then
 	if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit -1} {print $3}'`; then
 		echo -n "guid $1 address resolution: "
diff --git a/scripts/ibcheckstate.in b/scripts/ibcheckstate.in
index 78359d8..8f85f7b 100644
--- a/scripts/ibcheckstate.in
+++ b/scripts/ibcheckstate.in
@@ -77,13 +77,14 @@ BEGIN {
 function check_node(lid)
 {
 	nodechecked=1
-	if (system("'$IBPATH'/ibchecknode'"$ca_info"' '$gflags' '$verbose' " lid)) {
+	if (system("'$IBPATH'/ibchecknode -S '"$ca_info"' '$gflags' '$verbose' " lid)) {
 		ne++
 		badnode=1
 		return
 	}
 }
 
+
 /^Ca/ || /^Switch/ || /^Rt/ {
 			nnodes++
 			ntype=$1; nodeguid=substr($3, 4, 16); ports=$2
@@ -113,7 +114,7 @@ function check_node(lid)
 		}
 		sub("\\(.*\\)", "", port)
 		gsub("[\\[\\]]", "", port)
-		if (system("'$IBPATH'/ibcheckportstate'"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
+		if (system("'$IBPATH'/ibcheckportstate -S '"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
 			if (!'$v' && oldlid != lid) {
 				print "# Checked " ntype ": nodeguid 0x" nodeguid " with failure"
 				oldlid = lid
@@ -128,6 +129,7 @@ function check_node(lid)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated\n"
 	printf "\n## Summary: %d nodes checked, %d bad nodes found\n", nnodes, ne
 	printf "##          %d ports checked, %d ports with bad state found\n", nports, pe
 }
diff --git a/scripts/ibcheckwidth.in b/scripts/ibcheckwidth.in
index 49e8d1d..bf917fb 100644
--- a/scripts/ibcheckwidth.in
+++ b/scripts/ibcheckwidth.in
@@ -77,7 +77,7 @@ BEGIN {
 function check_node(lid)
 {
 	nodechecked=1
-	if (system("'$IBPATH'/ibchecknode '"$ca_info"' '$gflags' '$verbose' " lid)) {
+	if (system("'$IBPATH'/ibchecknode -S '"$ca_info"' '$gflags' '$verbose' " lid)) {
 		ne++
 		badnode=1
 		return
@@ -113,7 +113,7 @@ function check_node(lid)
 		}
 		sub("\\(.*\\)", "", port)
 		gsub("[\\[\\]]", "", port)
-		if (system("'$IBPATH'/ibcheckportwidth '"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
+		if (system("'$IBPATH'/ibcheckportwidth -S '"$ca_info"' '$gflags' '$verbose' " lid " " port)) {
 			if (!'$v' && oldlid != lid) {
 				print "# Checked " ntype ": nodeguid 0x" nodeguid " with failure"
 				oldlid = lid
@@ -128,6 +128,7 @@ function check_node(lid)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated\n"
 	printf "\n## Summary: %d nodes checked, %d bad nodes found\n", nnodes, ne
 	printf "##          %d ports checked, %d ports with 1x width in error found\n", nports, pe
 }
diff --git a/scripts/ibclearcounters.in b/scripts/ibclearcounters.in
index 429018a..318fa84 100644
--- a/scripts/ibclearcounters.in
+++ b/scripts/ibclearcounters.in
@@ -101,6 +101,7 @@ function clear_port_counters(lid, port)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors -K\"\n"
 	printf "\n## Summary: %d nodes cleared %d errors\n", nnodes, nodeerr
 }
 '
diff --git a/scripts/ibclearerrors.in b/scripts/ibclearerrors.in
index f7f1ccc..4329ae6 100644
--- a/scripts/ibclearerrors.in
+++ b/scripts/ibclearerrors.in
@@ -105,6 +105,7 @@ function clear_errors(lid, port)
 /iberror:/	{print $0}
 
 END {
+	printf "\n*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors -k\"\n"
 	printf "\n## Summary: %d nodes cleared %d errors\n", nnodes, nodeerr
 }
 '
diff --git a/scripts/ibdatacounters.in b/scripts/ibdatacounters.in
index 8fad62e..d7bf185 100644
--- a/scripts/ibdatacounters.in
+++ b/scripts/ibdatacounters.in
@@ -80,12 +80,12 @@ BEGIN {
 }
 function check_node(lid, port)
 {
-	if (system("'$IBPATH'/ibchecknode '"$ca_info"' '$gflags' '$verbose' " lid)) {
+	if (system("'$IBPATH'/ibchecknode -S '"$ca_info"' '$gflags' '$verbose' " lid)) {
 		ne++
 		print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
 		return 1;
 	}
-	return system("'$IBPATH'/ibdatacounts '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
+	return system("'$IBPATH'/ibdatacounts -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
 }
 
 /^Ca/ || /^Switch/ || /^Rt/ {
@@ -112,7 +112,7 @@ function check_node(lid, port)
 			lid = substr(lid, 1, index(lid, " ") - 1)
 			check_node(lid, port)
 		} else if (err)
-			system("'$IBPATH'/ibdatacounts '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
+			system("'$IBPATH'/ibdatacounts -S '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
 }
 
 /^ib/	{print $0; next}
@@ -121,9 +121,11 @@ function check_node(lid, port)
 /iberror:/	{print $0}
 
 END {
+   printf "*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors --counters\n"
 	printf "\n## Summary: %d nodes checked, %d bad nodes found\n", nnodes, ne
 	printf "##          %d ports checked\n", nports
 	exit (ne )
 }
 '
+
 exit $rv
diff --git a/scripts/ibdatacounts.in b/scripts/ibdatacounts.in
index b64547b..ed5f85d 100644
--- a/scripts/ibdatacounts.in
+++ b/scripts/ibdatacounts.in
@@ -34,6 +34,7 @@ bw=""
 verbose=""
 brief=""
 ca_info=""
+suppress_deprecated="no"
 
 while [ "$1" ]; do
 	case $1 in
@@ -63,6 +64,9 @@ while [ "$1" ]; do
 		ca_info="$ca_info $1 $2"
 		shift
 		;;
+	-S)
+		suppress_deprecated="yes"
+		;;
 	-*)
 		usage
 		;;
@@ -108,6 +112,10 @@ fi
 
 nodename=`$IBPATH/smpquery $ca_info nodedesc $lid | sed -e "s/^Node Description:\.*\(.*\)/\1/"`
 
+if [ "$suppress_deprecated" = "no" ]; then
+echo "*** WARNING ***: this command is deprecated; Please use \"ibqueryerrors --counters\"\n\n" 1>&2
+fi
+
 text="`eval $IBPATH/perfquery $ca_info $lid $portnum`"
 rv=$?
 if echo "$text" | awk -v mono=$bw -v brief=$brief -F '[.:]*' '
diff --git a/scripts/ibdiscover.pl b/scripts/ibdiscover.pl
index 8606919..1462584 100755
--- a/scripts/ibdiscover.pl
+++ b/scripts/ibdiscover.pl
@@ -1,5 +1,9 @@
 #!/usr/bin/perl
 
+printf (STDERR "*** WARNING ***; this command is deprecated;\n");
+printf (STDERR "                 see ibnetdiscover cache features\n");
+printf (STDERR "                 and/or iblinkinfo \"check\" features\n\n");
+
 #
 # Read mapfile
 #
@@ -84,3 +88,8 @@ foreach $el (keys %topo) {
 			$val{$lg}, $val{$rg});
 	}
 }
+
+printf (STDERR "*** WARNING ***; this command is deprecated;\n");
+printf (STDERR "                 see ibnetdiscover cache features\n");
+printf (STDERR "                 and/or iblinkinfo \"check\" features\n\n");
+
diff --git a/scripts/iblinkinfo.pl.in b/scripts/iblinkinfo.pl.in
index 0ce33ab..865be49 100755
--- a/scripts/iblinkinfo.pl.in
+++ b/scripts/iblinkinfo.pl.in
@@ -37,4 +37,6 @@
 
 # this is now just a wrapper for the C based utility
 $str = join " ",@ARGV;
-exec "@IBSCRIPTPATH@/iblinkinfo $str";
+system "@IBSCRIPTPATH@/iblinkinfo $str";
+printf (STDERR "\n*** WARNING ***: this command has been replaced by iblinkinfo\n\n");
+
diff --git a/scripts/ibprintca.pl b/scripts/ibprintca.pl
index 9832ac0..598229d 100755
--- a/scripts/ibprintca.pl
+++ b/scripts/ibprintca.pl
@@ -40,6 +40,8 @@ use strict;
 use Getopt::Std;
 use IBswcountlimits;
 
+printf (STDERR "*** WARNING ***: this command is deprecated; Please use \"ibhosts\"\n\n");
+
 # =========================================================================
 #
 sub usage_and_exit
diff --git a/scripts/ibprintrt.pl b/scripts/ibprintrt.pl
index 48c20f8..616be88 100755
--- a/scripts/ibprintrt.pl
+++ b/scripts/ibprintrt.pl
@@ -40,6 +40,8 @@ use strict;
 use Getopt::Std;
 use IBswcountlimits;
 
+printf (STDERR "*** WARNING ***: this command is deprecated; Please use \"ibrouters\"\n\n");
+
 # =========================================================================
 #
 sub usage_and_exit
diff --git a/scripts/ibprintswitch.pl b/scripts/ibprintswitch.pl
index f20bd4b..69d506a 100755
--- a/scripts/ibprintswitch.pl
+++ b/scripts/ibprintswitch.pl
@@ -40,6 +40,8 @@ use strict;
 use Getopt::Std;
 use IBswcountlimits;
 
+printf (STDERR "*** WARNING ***: this command is deprecated; Please use \"ibswitches\"\n\n");
+
 # =========================================================================
 #
 sub usage_and_exit
diff --git a/scripts/ibqueryerrors.pl.in b/scripts/ibqueryerrors.pl.in
index 30e610c..3d48751 100644
--- a/scripts/ibqueryerrors.pl.in
+++ b/scripts/ibqueryerrors.pl.in
@@ -34,7 +34,8 @@
 # SOFTWARE.
 #
 
-
 # this is now just a wrapper for the C based utility
 $str = join " ",@ARGV;
-exec "@IBSCRIPTPATH@/ibqueryerrors $str";
+system "@IBSCRIPTPATH@/ibqueryerrors $str";
+printf (STDERR "\n*** WARNING ***: this command has been replaced by ibqueryerrors\n\n");
+
diff --git a/scripts/set_nodedesc.sh b/scripts/set_nodedesc.sh
index 4ec0c43..1f08a54 100755
--- a/scripts/set_nodedesc.sh
+++ b/scripts/set_nodedesc.sh
@@ -7,6 +7,9 @@ fi
 ib_sysfs="/sys/class/infiniband"
 newname="$HOSTNAME"
 
+echo ""
+echo "*** WARNING ***: this command is deprecated."
+echo ""
 
 function usage
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
