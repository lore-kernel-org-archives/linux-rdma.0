From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Subject: [ofa-general] [PATCH] Added 'ibcheckspeed', Fix 'ibcheckportwidth'
Date: Thu, 10 Sep 2009 15:15:52 +0530
Message-ID: <829ded920909100245r1dfabe03k57b2088843c0a136@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <general-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: OFED mailing list <linux-rdma@vger.kernel.org>
Cc: OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

- Added 'ibcheckspeed': Similar to 'ibcheckwidth' in operation and usage.
                      Reports error/warning messages if the LinkSpeedActive is
                      2.5 Gbps when the LinkSpeedSupported is more
than 2.5 Gbps.
- Fix 'ibcheckportwidth': Exit if the maximum LinkWidthSupported is 1X
instead of
processing next line of output.

Signed-off-by: Keshetti Mahesh <keshetti.mahesh@gmail.com>
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
