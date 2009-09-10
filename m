From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] infiniband-diags/scripts: Add 'ibcheckspeed' and
	'ibcheckportspeed' to scripts
Date: Thu, 10 Sep 2009 18:32:08 +0530
Message-ID: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
Reports error/warning messages if the LinkSpeedActive is configured as
2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.

Signed-off-by: Keshetti Mahesh < keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/scripts/ibcheckportspeed.in |  146 ++++++++++++++++++++++++++
 infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
 infiniband-diags/scripts/ibcheckspeed.in     |  135 ++++++++++++++++++++++++
 3 files changed, 282 insertions(+), 1 deletions(-)
 create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
 create mode 100644 infiniband-diags/scripts/ibcheckspeed.in

diff --git a/infiniband-diags/scripts/ibcheckportspeed.in
b/infiniband-diags/scripts/ibcheckportspeed.in
new file mode 100644
index 0000000..538a7a7
--- /dev/null
+++ b/infiniband-diags/scripts/ibcheckportspeed.in
@@ -0,0 +1,146 @@
+#!/bin/sh
+
+IBPATH=${IBPATH:-@IBSCRIPTPATH@}
+
+function usage() {
+    echo Usage: `basename $0` "[-h] [-v] [-N | -nocolor] [-G]" \
+    "[-C ca_name] [-P ca_port] [-t(imeout) timeout_ms] <lid|guid> <port>"
+    exit -1
+}
+
+function green() {
+    if [ "$bw" = "yes" ]; then
+        if [ "$verbose" = "yes" ]; then
+            echo $1
+        fi
+        return
+    fi
+    if [ "$verbose" = "yes" ]; then
+        echo -e "\\033[1;032m" $1 "\\033[0;39m"
+    fi
+}
+
+function red() {
+    if [ "$bw" = "yes" ]; then
+        echo $1
+        return
+    fi
+    echo -e "\\033[1;031m" $1 "\\033[0;39m"
+}
+
+function blue()
+{
+    if [ "$bw" = "yes" ]; then
+        echo $1
+        return
+    fi
+    echo -e "\033[1;034m" $1 "\033[0;39m"
+}
+
+guid_addr=""
+bw=""
+verbose=""
+ca_info=""
+
+while [ "$1" ]; do
+    case $1 in
+        -G)
+        guid_addr=yes
+        ;;
+        -nocolor|-N)
+        bw=yes
+        ;;
+        -v)
+        verbose=yes
+        ;;
+        -P | -C | -t | -timeout)
+        case $2 in
+            -*)
+            usage
+            ;;
+        esac
+        if [ x$2 = x ] ; then
+            usage
+        fi
+        ca_info="$ca_info $1 $2"
+        shift
+        ;;
+        -*)
+        usage
+        ;;
+        *)
+        break
+        ;;
+    esac
+    shift
+done
+
+if [ $# -lt 2 ]
+then
+    usage
+fi
+
+portnum=$2
+
+if [ "$guid_addr" ]
+then
+    if ! lid=`$IBPATH/ibaddr $ca_info -G -L $1 | awk '/failed/{exit
-1} {print $3}'`
+    then
+        echo -n "guid $1 address resolution: "
+        red "FAILED"
+        exit -1
+    fi
+    guid=$1
+else
+    lid=$1
+    if ! temp=`$IBPATH/ibaddr $ca_info -L $1 | awk '/failed/{exit -1}
{print $3}'`
+    then
+        echo -n "lid $1 address resolution: "
+        red "FAILED"
+        exit -1
+    fi
+fi
+
+text="`eval $IBPATH/smpquery $ca_info portinfo $lid $portnum`"
+rv=$?
+if echo "$text" | sed 's/[0-9]/#&/;s/ Gbps//g' | awk -v mono=$bw -F '#' '
+function blue(s)
+{
+       if (mono)
+               printf s
+       else if (!quiet) {
+               printf "\033[1;034m" s
+               printf "\033[0;39m"
+       }
+}
+
+# Only check LinkSpeedActive if LinkSpeedSupported is not 2.5 Gbps
+/^LinkSpeedSupported/{ if ($2 == "2.5") { exit } }
+/^LinkSpeedActive/{ if ($2 == "2.5") warn = warn "#warn: Link
configured as 2.5 Gbps  lid '$lid' port '$portnum'\n"}
+
+/^ib/  {print $0; next}
+/ibpanic:/     {print $0}
+/ibwarn:/      {print $0}
+/iberror:/     {print $0}
+
+END {
+       if (err != "") {
+               blue(err)
+               exit -1
+       }
+       if (warn != "") {
+               blue(warn)
+               exit -1
+       }
+       exit 0
+}' 2>&1 && test $rv -eq 0 ; then
+       if [ "$verbose" = "yes" ]; then
+               echo -n "Port check lid $lid port $portnum: "
+               green "OK"
+       fi
+       exit 0
+else
+       echo -n "Port check lid $lid port $portnum: "
+       red "FAILED"
+       exit -1
+fi
diff --git a/infiniband-diags/scripts/ibcheckportwidth.in
b/infiniband-diags/scripts/ibcheckportwidth.in
index 32c5c5e..60a0892 100644
--- a/infiniband-diags/scripts/ibcheckportwidth.in
+++ b/infiniband-diags/scripts/ibcheckportwidth.in
@@ -103,7 +103,7 @@ function blue(s)
 }

 # Only check LinkWidthActive if LinkWidthSupported is not 1X
-/^LinkWidthSupported/{ if ($2 != "1X") { next } }
+/^LinkWidthSupported/{ if ($2 == "1X") { exit } }
 /^LinkWidthActive/{ if ($2 == "1X") warn = warn "#warn: Link
configured as 1X  lid '$lid' port '$portnum'\n"}

 /^ib/  {print $0; next}
diff --git a/infiniband-diags/scripts/ibcheckspeed.in
b/infiniband-diags/scripts/ibcheckspeed.in
new file mode 100644
index 0000000..25c2201
--- /dev/null
+++ b/infiniband-diags/scripts/ibcheckspeed.in
@@ -0,0 +1,135 @@
+#!/bin/sh
+
+IBPATH=${IBPATH:-@IBSCRIPTPATH@}
+
+function usage() {
+       echo Usage: `basename $0` "[-h] [-v] [-N | -nocolor]" \
+           "[<topology-file> \| -C ca_name -P ca_port -t(imeout) timeout_ms]"
+       exit -1
+}
+
+function user_abort() {
+       echo "Aborted"
+       exit 1
+}
+
+trap user_abort SIGINT
+
+gflags=""
+verbose=""
+v=0
+ntype=""
+nodeguid=""
+oldlid=""
+topofile=""
+ca_info=""
+
+while [ "$1" ]; do
+       case $1 in
+       -h)
+               usage
+               ;;
+       -N|-nocolor)
+               gflags=-N
+               ;;
+       -v)
+               verbose="-v"
+               v=1
+               ;;
+       -P | -C | -t | -timeout)
+               case $2 in
+               -*)
+                       usage
+                       ;;
+               esac
+               if [ x$2 = x ] ; then
+                       usage
+               fi
+               ca_info="$ca_info $1 $2"
+               shift
+               ;;
+       -*)
+               usage
+               ;;
+       *)
+               if [ "$topofile" ]; then
+                       usage
+               fi
+               topofile="$1"
+               ;;
+       esac
+       shift
+done
+
+if [ "$topofile" ]; then
+       netcmd="cat $topofile"
+else
+       netcmd="$IBPATH/ibnetdiscover $ca_info"
+fi
+
+text="`eval $netcmd`"
+rv=$?
+echo "$text" | awk '
+BEGIN {
+       ne=0
+       pe=0
+}
+function check_node(lid)
+{
+       nodechecked=1
+       if (system("'$IBPATH'/ibchecknode'"$ca_info"' '$gflags'
'$verbose' " lid)) {
+               ne++
+               badnode=1
+               return
+       }
+}
+
+/^Ca/ || /^Switch/ || /^Rt/ {
+                       nnodes++
+                       ntype=$1; nodeguid=substr($3, 4, 16); ports=$2
+                       if ('$v')
+                               print "\n# Checking " ntype ":
nodeguid 0x" nodeguid
+
+                       nodechecked=0
+                       badnode=0
+                       if (ntype != "Switch")
+                               next
+
+                       lid = substr($0, index($0, "port 0 lid ") + 11)
+                       lid = substr(lid, 1, index(lid, " ") - 1)
+                       check_node(lid)
+               }
+/^\[/  {
+               nports++
+               port = $1
+               if (!nodechecked) {
+                       lid = substr($0, index($0, " lid ") + 5)
+                       lid = substr(lid, 1, index(lid, " ") - 1)
+                       check_node(lid)
+               }
+               if (badnode) {
+                       print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
+                       next
+               }
+               sub("\\(.*\\)", "", port)
+               gsub("[\\[\\]]", "", port)
+               if (system("'$IBPATH'/ibcheckportspeed'"$ca_info"'
'$gflags' '$verbose' " lid " " port)) {
+                       if (!'$v' && oldlid != lid) {
+                               print "# Checked " ntype ": nodeguid
0x" nodeguid " with failure"
+                               oldlid = lid
+                       }
+                       pe++;
+               }
+}
+
+/^ib/  {print $0; next}
+/ibpanic:/     {print $0}
+/ibwarn:/      {print $0}
+/iberror:/     {print $0}
+
+END {
+       printf "\n## Summary: %d nodes checked, %d bad nodes found\n",
nnodes, ne
+       printf "##          %d ports checked, %d ports with 2.5 Gbps
speed in error found\n", nports, pe
+}
+'
+exit $rv
-- 
1.6.4.2


>From 76e5f441bac10dff185244139a46124ff4736d56 Mon Sep 17 00:00:00 2001
From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, 10 Sep 2009 18:24:16 +0530
Subject: [PATCH 2/2] Revert the change made to 'ibcheckportwidth'
 Add man pages of 'ibcheckportspeed' and 'ibcheckspeed'
 Integrate 'ibcheckportspeed' and 'ibcheckspeed' into the build system
Organization: OFED

---
 infiniband-diags/Makefile.am                 |    3 +-
 infiniband-diags/configure.in                |    2 +
 infiniband-diags/man/ibcheckportspeed.8      |   44 ++++++++++++++++++++++++++
 infiniband-diags/man/ibcheckportwidth.8      |    2 +-
 infiniband-diags/man/ibcheckspeed.8          |   37 +++++++++++++++++++++
 infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
 6 files changed, 87 insertions(+), 3 deletions(-)
 create mode 100644 infiniband-diags/man/ibcheckportspeed.8
 create mode 100644 infiniband-diags/man/ibcheckspeed.8

diff --git a/infiniband-diags/Makefile.am b/infiniband-diags/Makefile.am
index 1cdb60e..8c5b773 100644
--- a/infiniband-diags/Makefile.am
+++ b/infiniband-diags/Makefile.am
@@ -23,6 +23,7 @@ sbin_SCRIPTS = scripts/ibcheckerrs
scripts/ibchecknet scripts/ibchecknode \
                scripts/ibcheckport scripts/ibhosts scripts/ibstatus \
               scripts/ibswitches scripts/ibnodes scripts/ibrouters \
               scripts/ibcheckwidth scripts/ibcheckportwidth \
+              scripts/ibcheckspeed scripts/ibcheckportspeed \
               scripts/ibcheckstate scripts/ibcheckportstate \
               scripts/ibcheckerrors scripts/ibclearerrors \
               scripts/ibclearcounters scripts/ibdatacounts \
@@ -76,7 +77,7 @@ man_MANS = man/ibaddr.8 man/ibcheckerrors.8
man/ibcheckerrs.8 \
        man/ibprintswitch.8 man/ibprintca.8 man/ibfindnodesusing.8 \
        man/ibdatacounts.8 man/ibdatacounters.8 \
        man/ibrouters.8 man/ibprintrt.8 man/ibidsverify.8 \
-       man/check_lft_balance.8
+       man/check_lft_balance.8 man/ibcheckportspeed.8 man/ibcheckspeed.8

 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
index 3ef35cc..c647f40 100644
--- a/infiniband-diags/configure.in
+++ b/infiniband-diags/configure.in
@@ -156,8 +156,10 @@ AC_CONFIG_FILES([\
        scripts/ibcheckport \
        scripts/ibcheckportstate \
        scripts/ibcheckportwidth \
+       scripts/ibcheckportspeed \
        scripts/ibcheckstate \
        scripts/ibcheckwidth \
+       scripts/ibcheckspeed \
        scripts/ibclearcounters \
        scripts/ibclearerrors \
        scripts/ibdatacounts \
diff --git a/infiniband-diags/man/ibcheckportspeed.8
b/infiniband-diags/man/ibcheckportspeed.8
new file mode 100644
index 0000000..36beaac
--- /dev/null
+++ b/infiniband-diags/man/ibcheckportspeed.8
@@ -0,0 +1,44 @@
+.TH IBCHECKPORTSPEED 8 "Sep 10, 2009" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+ibcheckportspeed \- validate IB port for link speed
+
+.SH SYNOPSIS
+.B ibcheckportspeed
+[\-h] [\-v] [\-N | \-nocolor] [\-G] [\-C ca_name] [\-P ca_port]
+[\-t(imeout) timeout_ms]  <lid|guid> <port>
+
+.SH DESCRIPTION
+.PP
+Check connectivity and check the specified port for link speed.
Report warning if the LinkSpeedSupported is greater than 2.5 Gbps and
LinkSpeedActive is configured as 2.5 Gbps.
+
+Port address is a lid unless -G option is used to specify a GUID address.
+
+.SH OPTIONS
+.PP
+\-G      use GUID address argument. In most cases, it is the Port GUID.
+        Example:
+        "0x08f1040023"
+.PP
+\-v      increase the verbosity level
+.PP
+\-N | \-nocolor use mono rather than color mode
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
+
+.SH EXAMPLE
+.PP
+ibcheckportspeed 2 3         # check lid 2 port 3
+
+.SH SEE ALSO
+.BR smpquery(8),
+.BR ibaddr(8)
+
+.SH AUTHOR
+.TP
+Keshetti Mahesh
+.RI < keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/infiniband-diags/man/ibcheckportwidth.8
b/infiniband-diags/man/ibcheckportwidth.8
index 85c06fc..c368467 100644
--- a/infiniband-diags/man/ibcheckportwidth.8
+++ b/infiniband-diags/man/ibcheckportwidth.8
@@ -4,7 +4,7 @@
 ibcheckportwidth \- validate IB port for 1x link width

 .SH SYNOPSIS
-.B ibcheckport
+.B ibcheckportwidth
 [\-h] [\-v] [\-N | \-nocolor] [\-G] [\-C ca_name] [\-P ca_port]
 [\-t(imeout) timeout_ms]  <lid|guid> <port>

diff --git a/infiniband-diags/man/ibcheckspeed.8
b/infiniband-diags/man/ibcheckspeed.8
new file mode 100644
index 0000000..29aee37
--- /dev/null
+++ b/infiniband-diags/man/ibcheckspeed.8
@@ -0,0 +1,37 @@
+.TH IBCHECKSPEED 8 "Sep 10, 2009" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+ibcheckspeed \- find link speed configuration errors in IB subnet
+
+.SH SYNOPSIS
+.B ibcheckspeed
+[\-h] [\-v] [\-N | \-nocolor] [<topology-file> | \-C ca_name
+\-P ca_port \-t(imeout) timeout_ms]
+
+
+.SH DESCRIPTION
+.PP
+ibcheckspeed is a script which uses a full topology file that was created by
+ibnetdiscover, scans the network to validate the active link speeds and reports
+any links which are configured with less active link speed then the supported
+link speed.
+
+.SH OPTIONS
+.PP
+\-N | \-nocolor  use mono rather than color mode
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
+
+.SH SEE ALSO
+.BR ibnetdiscover(8),
+.BR ibchecknode(8),
+.BR ibcheckportspeed(8)
+
+.SH AUTHOR
+.TP
+Keshetti Mahesh
+.RI < keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/infiniband-diags/scripts/ibcheckportwidth.in
b/infiniband-diags/scripts/ibcheckportwidth.in
index 60a0892..32c5c5e 100644
--- a/infiniband-diags/scripts/ibcheckportwidth.in
+++ b/infiniband-diags/scripts/ibcheckportwidth.in
@@ -103,7 +103,7 @@ function blue(s)
 }

 # Only check LinkWidthActive if LinkWidthSupported is not 1X
-/^LinkWidthSupported/{ if ($2 == "1X") { exit } }
+/^LinkWidthSupported/{ if ($2 != "1X") { next } }
 /^LinkWidthActive/{ if ($2 == "1X") warn = warn "#warn: Link
configured as 1X  lid '$lid' port '$portnum'\n"}

 /^ib/  {print $0; next}
-- 
1.6.4.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
