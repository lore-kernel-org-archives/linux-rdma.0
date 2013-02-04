From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags: deprecate dump_[m|l]fts.sh scripts
Date: Sun, 3 Feb 2013 22:19:58 -0800
Message-ID: <20130203221958.fb3e01fa11a226830f46289f@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                |    6 +-
 configure.in               |    4 +-
 doc/man/dump_lfts.8.in     |  177 --------------------------------------------
 doc/man/dump_mfts.8.in     |  170 ------------------------------------------
 doc/rst/dump_lfts.8.in.rst |   73 ------------------
 doc/rst/dump_mfts.8.in.rst |   64 ----------------
 man/dump_lfts.8            |    2 +
 man/dump_mfts.8            |    2 +
 scripts/dump_lfts.sh       |   72 ------------------
 scripts/dump_lfts.sh.in    |   12 +++
 scripts/dump_mfts.sh       |   72 ------------------
 scripts/dump_mfts.sh.in    |   12 +++
 12 files changed, 33 insertions(+), 633 deletions(-)
 delete mode 100644 doc/man/dump_lfts.8.in
 delete mode 100644 doc/man/dump_mfts.8.in
 delete mode 100644 doc/rst/dump_lfts.8.in.rst
 delete mode 100644 doc/rst/dump_mfts.8.in.rst
 create mode 100644 man/dump_lfts.8
 create mode 100644 man/dump_mfts.8
 delete mode 100755 scripts/dump_lfts.sh
 create mode 100755 scripts/dump_lfts.sh.in
 delete mode 100755 scripts/dump_mfts.sh
 create mode 100755 scripts/dump_mfts.sh.in

diff --git a/Makefile.am b/Makefile.am
index 42c2c75..f44b4d6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -47,8 +47,6 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/ibccconfig.8 \
 		doc/man/ibccquery.8 \
 		doc/man/dump_fts.8 \
-		doc/man/dump_lfts.8 \
-		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
 		doc/man/ibfindnodesusing.8 \
 		doc/man/ibhosts.8 \
@@ -71,7 +69,9 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/smpdump.8 \
 		doc/man/smpquery.8 \
 		doc/man/vendstat.8 \
-		doc/man/infiniband-diags.8
+		doc/man/infiniband-diags.8 \
+		man/dump_lfts.8 \
+		man/dump_mfts.8
 
 # define this for the dist target
 compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
diff --git a/configure.in b/configure.in
index b54222b..edac1e3 100644
--- a/configure.in
+++ b/configure.in
@@ -216,14 +216,14 @@ AC_CONFIG_FILES([\
 	scripts/ibrouters \
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
+	scripts/dump_lfts.sh \
+	scripts/dump_mfts.sh \
 	doc/man/ibaddr.8 \
 	doc/man/check_lft_balance.8 \
 	doc/man/ibcacheedit.8 \
 	doc/man/ibccconfig.8 \
 	doc/man/ibccquery.8 \
 	doc/man/dump_fts.8 \
-	doc/man/dump_lfts.8 \
-	doc/man/dump_mfts.8 \
 	doc/man/ibhosts.8 \
 	doc/man/ibidsverify.8 \
 	doc/man/iblinkinfo.8 \
diff --git a/doc/man/dump_lfts.8.in b/doc/man/dump_lfts.8.in
deleted file mode 100644
index a75a425..0000000
--- a/doc/man/dump_lfts.8.in
+++ /dev/null
@@ -1,177 +0,0 @@
-.\" Man page generated from reStructeredText.
-.
-.TH DUMP_LFTS.SH 8 "@BUILD_DATE@" "" "OpenIB Diagnostics"
-.SH NAME
-DUMP_LFTS.SH \- dump InfiniBand unicast forwarding tables
-.
-.nr rst2man-indent-level 0
-.
-.de1 rstReportMargin
-\\$1 \\n[an-margin]
-level \\n[rst2man-indent-level]
-level margin: \\n[rst2man-indent\\n[rst2man-indent-level]]
--
-\\n[rst2man-indent0]
-\\n[rst2man-indent1]
-\\n[rst2man-indent2]
-..
-.de1 INDENT
-.\" .rstReportMargin pre:
-. RS \\$1
-. nr rst2man-indent\\n[rst2man-indent-level] \\n[an-margin]
-. nr rst2man-indent-level +1
-.\" .rstReportMargin post:
-..
-.de UNINDENT
-. RE
-.\" indent \\n[an-margin]
-.\" old: \\n[rst2man-indent\\n[rst2man-indent-level]]
-.nr rst2man-indent-level -1
-.\" new: \\n[rst2man-indent\\n[rst2man-indent-level]]
-.in \\n[rst2man-indent\\n[rst2man-indent-level]]u
-..
-.SH SYNOPSIS
-.sp
-dump_lfts.sh [\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [>/path/to/dump\-file]
-.SH DESCRIPTION
-.sp
-dump_lfts.sh is a script which dumps the InfiniBand unciast forwarding
-tables (MFTs) in the switch nodes in the subnet.
-.sp
-The dump file format is compatible with loading into OpenSM using
-the \-R file \-U /path/to/dump\-file syntax.
-.SH OPTIONS
-.sp
-\fB\-D\fP
-dump forwarding tables using direct routed rather than LID routed SMPs
-.sp
-\fB\-h\fP
-show help
-.SS Port Selection flags
-.\" Define the common option -C
-.
-.sp
-\fB\-C, \-\-Ca <ca_name>\fP    use the specified ca_name.
-.\" Define the common option -P
-.
-.sp
-\fB\-P, \-\-Port <ca_port>\fP    use the specified ca_port.
-.\" Explanation of local port selection
-.
-.SS Local port Selection
-.sp
-Multiple port/Multiple CA support: when no IB device or port is specified
-(see the "local umad parameters" below), the libibumad library
-selects the port to use by the following criteria:
-.INDENT 0.0
-.INDENT 3.5
-.INDENT 0.0
-.IP 1. 3
-.
-the first port that is ACTIVE.
-.IP 2. 3
-.
-if not found, the first port that is UP (physical link up).
-.UNINDENT
-.sp
-If a port and/or CA name is specified, the libibumad library attempts
-to fulfill the user request, and will fail if it is not possible.
-.sp
-For example:
-.sp
-.nf
-.ft C
-ibaddr                 # use the first port (criteria #1 above)
-ibaddr \-C mthca1       # pick the best port from "mthca1" only.
-ibaddr \-P 2            # use the second (active/up) port from the first available IB device.
-ibaddr \-C mthca0 \-P 2  # use the specified port only.
-.ft P
-.fi
-.UNINDENT
-.UNINDENT
-.SS Configuration flags
-.\" Define the common option -z
-.
-.sp
-\fB\-\-config, \-z  <config_file>\fP Specify alternate config file.
-.INDENT 0.0
-.INDENT 3.5
-.sp
-Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
-.UNINDENT
-.UNINDENT
-.\" Define the common option -t
-.
-.sp
-\fB\-t, \-\-timeout <timeout_ms>\fP override the default timeout for the solicited mads.
-.SH FILES
-.\" Common text for the config file
-.
-.SS CONFIG FILE
-.sp
-@IBDIAG_CONFIG_PATH@/ibdiag.conf
-.sp
-A global config file is provided to set some of the common options for all
-tools.  See supplied config file for details.
-.\" Common text to describe the node name map file.
-.
-.SS NODE NAME MAP FILE FORMAT
-.sp
-The node name map is used to specify user friendly names for nodes in the
-output.  GUIDs are used to perform the lookup.
-.sp
-This functionality is provided by the opensm\-libs package.  See \fBopensm(8)\fP
-for the file location for your installation.
-.sp
-\fBGenerically:\fP
-.sp
-.nf
-.ft C
-# comment
-<guid> "<name>"
-.ft P
-.fi
-.sp
-\fBExample:\fP
-.sp
-.nf
-.ft C
-# IB1
-# Line cards
-0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB\-24D"
-
-# Spines
-0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
-
-# GUID   Node Name
-0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
-.ft P
-.fi
-.SH SEE ALSO
-.sp
-\fBdump_mfts(8), ibroute(8), ibswitches(8), opensm(8)\fP
-.SH AUTHORS
-.INDENT 0.0
-.TP
-.B Sasha Khapyorsky
-.
-< \fI\%sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org\fP >
-.TP
-.B Hal Rosenstock
-.
-< \fI\%halr-smomgflXvOZWk0Htik3J/w@public.gmane.org\fP >
-.UNINDENT
-.\" Generated by docutils manpage writer.
-.\" 
-.
diff --git a/doc/man/dump_mfts.8.in b/doc/man/dump_mfts.8.in
deleted file mode 100644
index 0e5f4b9..0000000
--- a/doc/man/dump_mfts.8.in
+++ /dev/null
@@ -1,170 +0,0 @@
-.\" Man page generated from reStructeredText.
-.
-.TH DUMP_MFTS.SH 8 "@BUILD_DATE@" "" "OpenIB Diagnostics"
-.SH NAME
-DUMP_MFTS.SH \- dump InfiniBand multicast forwarding tables
-.
-.nr rst2man-indent-level 0
-.
-.de1 rstReportMargin
-\\$1 \\n[an-margin]
-level \\n[rst2man-indent-level]
-level margin: \\n[rst2man-indent\\n[rst2man-indent-level]]
--
-\\n[rst2man-indent0]
-\\n[rst2man-indent1]
-\\n[rst2man-indent2]
-..
-.de1 INDENT
-.\" .rstReportMargin pre:
-. RS \\$1
-. nr rst2man-indent\\n[rst2man-indent-level] \\n[an-margin]
-. nr rst2man-indent-level +1
-.\" .rstReportMargin post:
-..
-.de UNINDENT
-. RE
-.\" indent \\n[an-margin]
-.\" old: \\n[rst2man-indent\\n[rst2man-indent-level]]
-.nr rst2man-indent-level -1
-.\" new: \\n[rst2man-indent\\n[rst2man-indent-level]]
-.in \\n[rst2man-indent\\n[rst2man-indent-level]]u
-..
-.SH SYNOPSIS
-.sp
-dump_mfts.sh [\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [>/path/to/file]
-.SH DESCRIPTION
-.sp
-dump_mfts.sh is a script which dumps the InfiniBand multicast
-forwarding tables (MFTs) in the switch nodes in the subnet.
-.SH OPTIONS
-.sp
-\fB\-D\fP
-dump forwarding tables using direct routed rather than LID routed SMPs
-.sp
-\fB\-h\fP
-show help
-.SS Port Selection flags
-.\" Define the common option -C
-.
-.sp
-\fB\-C, \-\-Ca <ca_name>\fP    use the specified ca_name.
-.\" Define the common option -P
-.
-.sp
-\fB\-P, \-\-Port <ca_port>\fP    use the specified ca_port.
-.\" Explanation of local port selection
-.
-.SS Local port Selection
-.sp
-Multiple port/Multiple CA support: when no IB device or port is specified
-(see the "local umad parameters" below), the libibumad library
-selects the port to use by the following criteria:
-.INDENT 0.0
-.INDENT 3.5
-.INDENT 0.0
-.IP 1. 3
-.
-the first port that is ACTIVE.
-.IP 2. 3
-.
-if not found, the first port that is UP (physical link up).
-.UNINDENT
-.sp
-If a port and/or CA name is specified, the libibumad library attempts
-to fulfill the user request, and will fail if it is not possible.
-.sp
-For example:
-.sp
-.nf
-.ft C
-ibaddr                 # use the first port (criteria #1 above)
-ibaddr \-C mthca1       # pick the best port from "mthca1" only.
-ibaddr \-P 2            # use the second (active/up) port from the first available IB device.
-ibaddr \-C mthca0 \-P 2  # use the specified port only.
-.ft P
-.fi
-.UNINDENT
-.UNINDENT
-.SS Configuration flags
-.\" Define the common option -z
-.
-.sp
-\fB\-\-config, \-z  <config_file>\fP Specify alternate config file.
-.INDENT 0.0
-.INDENT 3.5
-.sp
-Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
-.UNINDENT
-.UNINDENT
-.\" Define the common option -t
-.
-.sp
-\fB\-t, \-\-timeout <timeout_ms>\fP override the default timeout for the solicited mads.
-.SH FILES
-.\" Common text for the config file
-.
-.SS CONFIG FILE
-.sp
-@IBDIAG_CONFIG_PATH@/ibdiag.conf
-.sp
-A global config file is provided to set some of the common options for all
-tools.  See supplied config file for details.
-.\" Common text to describe the node name map file.
-.
-.SS NODE NAME MAP FILE FORMAT
-.sp
-The node name map is used to specify user friendly names for nodes in the
-output.  GUIDs are used to perform the lookup.
-.sp
-This functionality is provided by the opensm\-libs package.  See \fBopensm(8)\fP
-for the file location for your installation.
-.sp
-\fBGenerically:\fP
-.sp
-.nf
-.ft C
-# comment
-<guid> "<name>"
-.ft P
-.fi
-.sp
-\fBExample:\fP
-.sp
-.nf
-.ft C
-# IB1
-# Line cards
-0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
-0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB\-24D"
-
-# Spines
-0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
-0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
-
-# GUID   Node Name
-0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
-0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
-.ft P
-.fi
-.SH SEE ALSO
-.sp
-\fBdump_lfts(8), ibroute(8), ibswitches(8), opensm(8)\fP
-.SH AUTHOR
-.INDENT 0.0
-.TP
-.B Hal Rosenstock
-.
-< \fI\%halr-smomgflXvOZWk0Htik3J/w@public.gmane.org\fP >
-.UNINDENT
-.\" Generated by docutils manpage writer.
-.\" 
-.
diff --git a/doc/rst/dump_lfts.8.in.rst b/doc/rst/dump_lfts.8.in.rst
deleted file mode 100644
index 9b9ded2..0000000
--- a/doc/rst/dump_lfts.8.in.rst
+++ /dev/null
@@ -1,73 +0,0 @@
-============
-DUMP_LFTS.SH
-============
-
------------------------------------------
-dump InfiniBand unicast forwarding tables
------------------------------------------
-
-:Date: @BUILD_DATE@
-:Manual section: 8
-:Manual group: OpenIB Diagnostics
-
-
-
-SYNOPSIS
-========
-
-dump_lfts.sh [-h] [-D] [-C ca_name] [-P ca_port] [-t(imeout) timeout_ms] [>/path/to/dump-file]
-
-
-DESCRIPTION
-===========
-
-dump_lfts.sh is a script which dumps the InfiniBand unciast forwarding
-tables (MFTs) in the switch nodes in the subnet.
-
-The dump file format is compatible with loading into OpenSM using
-the -R file -U /path/to/dump-file syntax.
-
-OPTIONS
-=======
-
-**-D**
-dump forwarding tables using direct routed rather than LID routed SMPs
-
-**-h**
-show help
-
-
-Port Selection flags
---------------------
-
-.. include:: common/opt_C.rst
-.. include:: common/opt_P.rst
-.. include:: common/sec_portselection.rst
-
-Configuration flags
--------------------
-
-.. include:: common/opt_z-config.rst
-.. include:: common/opt_t.rst
-
-FILES
-=====
-
-.. include:: common/sec_config-file.rst
-.. include:: common/sec_node-name-map.rst
-
-
-SEE ALSO
-========
-
-**dump_mfts(8), ibroute(8), ibswitches(8), opensm(8)**
-
-
-AUTHORS
-=======
-
-Sasha Khapyorsky
-        < sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org >
-
-Hal Rosenstock
-        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/dump_mfts.8.in.rst b/doc/rst/dump_mfts.8.in.rst
deleted file mode 100644
index 551effc..0000000
--- a/doc/rst/dump_mfts.8.in.rst
+++ /dev/null
@@ -1,64 +0,0 @@
-============
-DUMP_MFTS.SH
-============
-
--------------------------------------------
-dump InfiniBand multicast forwarding tables
--------------------------------------------
-
-:Date: @BUILD_DATE@
-:Manual section: 8
-:Manual group: OpenIB Diagnostics
-
-
-SYNOPSIS
-========
-
-dump_mfts.sh [\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [>/path/to/file]
-
-DESCRIPTION
-===========
-
-dump_mfts.sh is a script which dumps the InfiniBand multicast
-forwarding tables (MFTs) in the switch nodes in the subnet.
-
-OPTIONS
-=======
-
-**-D**
-dump forwarding tables using direct routed rather than LID routed SMPs
-
-**-h**
-show help
-
-
-Port Selection flags
---------------------
-
-.. include:: common/opt_C.rst
-.. include:: common/opt_P.rst
-.. include:: common/sec_portselection.rst
-
-Configuration flags
--------------------
-
-.. include:: common/opt_z-config.rst
-.. include:: common/opt_t.rst
-
-FILES
-=====
-
-.. include:: common/sec_config-file.rst
-.. include:: common/sec_node-name-map.rst
-
-
-SEE ALSO
-========
-
-**dump_lfts(8), ibroute(8), ibswitches(8), opensm(8)**
-
-AUTHOR
-======
-
-Hal Rosenstock
-        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/dump_lfts.8 b/man/dump_lfts.8
new file mode 100644
index 0000000..a3d1fdd
--- /dev/null
+++ b/man/dump_lfts.8
@@ -0,0 +1,2 @@
+.\".TH DUMP_LFTS.SH 8  "Feb 03, 2013" "OpenIB" "OpenIB Programmer's Manual"
+.so man8/dump_fts.8
diff --git a/man/dump_mfts.8 b/man/dump_mfts.8
new file mode 100644
index 0000000..0566aa9
--- /dev/null
+++ b/man/dump_mfts.8
@@ -0,0 +1,2 @@
+.\".TH DUMP_MFTS.SH 8  "Feb 03, 2013" "OpenIB" "OpenIB Programmer's Manual"
+.so man8/dump_fts.8
diff --git a/scripts/dump_lfts.sh b/scripts/dump_lfts.sh
deleted file mode 100755
index a07c211..0000000
--- a/scripts/dump_lfts.sh
+++ /dev/null
@@ -1,72 +0,0 @@
-#!/bin/sh
-#
-# This simple script will collect outputs of ibroute for all switches
-# on the subnet and drop it on stdout. It can be used for LFTs dump
-# generation.
-#
-
-usage ()
-{
-	echo Usage: `basename $0` "[-h] [-D] [-C ca_name]" \
-	    "[-P ca_port] [-t(imeout) timeout_ms]"
-	exit 2
-}
-
-dump_by_lid ()
-{
-for sw_lid in `ibswitches $ca_info \
-		| sed -ne 's/^.* lid \([0-9a-f]*\) .*$/\1/p'` ; do
-	ibroute $ca_info $sw_lid
-done
-}
-
-dump_by_dr_path ()
-{
-for sw_dr in `ibnetdiscover $ca_info -s \
-	| sed -ne '/^DR path .* switch /s/^DR path .*; \([,|0-9]\+\) ->.*{\([0-9|a-f]\+\)}.*$/\2 \1/p' \
-	| sort -u \
-	| awk 'BEGIN {guid=0;} {if ($1 != guid) { guid=$1; print $2; }}'` ; do
-	ibroute $ca_info -D ${sw_dr}
-done
-}
-
-use_d=""
-ca_info=""
-
-while [ "$1" ]; do
-	case $1 in
-	-D)
-		use_d="-D"
-		;;
-	-h)
-		usage
-		;;
-	-P | -C | -t | -timeout)
-		case $2 in
-		-*)
-			usage
-			;;
-		esac
-		if [ x$2 = x ] ; then
-			usage
-		fi
-		ca_info="$ca_info $1 $2"
-		shift
-		;;
-	-*)
-		usage
-		;;
-	*)
-		usage
-		;;
-	esac
-	shift
-done
-
-if [ "$use_d" = "-D" ] ; then
-	dump_by_dr_path
-else
-	dump_by_lid
-fi
-
-exit
diff --git a/scripts/dump_lfts.sh.in b/scripts/dump_lfts.sh.in
new file mode 100755
index 0000000..ac2c0fc
--- /dev/null
+++ b/scripts/dump_lfts.sh.in
@@ -0,0 +1,12 @@
+#!/bin/sh
+#
+# This simple script will collect outputs of ibroute for all switches
+# on the subnet and drop it on stdout. It can be used for LFTs dump
+# generation.
+#
+
+@IBSCRIPTPATH@/dump_fts $@
+echo ""
+echo "*** WARNING ***: this command has been replaced by dump_fts"
+echo ""
+echo ""
diff --git a/scripts/dump_mfts.sh b/scripts/dump_mfts.sh
deleted file mode 100755
index cdadba2..0000000
--- a/scripts/dump_mfts.sh
+++ /dev/null
@@ -1,72 +0,0 @@
-#!/bin/sh
-#
-# This simple script will collect outputs of ibroute for all switches
-# on the subnet and drop it on stdout. It can be used for MFTs dump
-# generation.
-#
-
-usage ()
-{
-	echo Usage: `basename $0` "[-h] [-D] [-C ca_name]" \
-	    "[-P ca_port] [-t(imeout) timeout_ms]"
-	exit 2
-}
-
-dump_by_lid ()
-{
-for sw_lid in `ibswitches $ca_info \
-		| sed -ne 's/^.* lid \([0-9a-f]*\) .*$/\1/p'` ; do
-	ibroute $ca_info -M $sw_lid
-done
-}
-
-dump_by_dr_path ()
-{
-for sw_dr in `ibnetdiscover $ca_info -s \
-	| sed -ne '/^DR path .* switch /s/^DR path .*; \([,|0-9]\+\) ->.*{\([0-9|a-f]\+\)}.*$/\2 \1/p' \
-	| sort -u \
-	| awk 'BEGIN {guid=0;} {if ($1 != guid) { guid=$1; print $2; }}'` ; do
-	ibroute $ca_info -M -D ${sw_dr}
-done
-}
-
-use_d=""
-ca_info=""
-
-while [ "$1" ]; do
-	case $1 in
-	-D)
-		use_d="-D"
-		;;
-	-h)
-		usage
-		;;
-	-P | -C | -t | -timeout)
-		case $2 in
-		-*)
-			usage
-			;;
-		esac
-		if [ x$2 = x ] ; then
-			usage
-		fi
-		ca_info="$ca_info $1 $2"
-		shift
-		;;
-	-*)
-		usage
-		;;
-	*)
-		usage
-		;;
-	esac
-	shift
-done
-
-if [ "$use_d" = "-D" ] ; then
-	dump_by_dr_path
-else
-	dump_by_lid
-fi
-
-exit
diff --git a/scripts/dump_mfts.sh.in b/scripts/dump_mfts.sh.in
new file mode 100755
index 0000000..652b567
--- /dev/null
+++ b/scripts/dump_mfts.sh.in
@@ -0,0 +1,12 @@
+#!/bin/sh
+#
+# This simple script will collect outputs of ibroute for all switches
+# on the subnet and drop it on stdout. It can be used for MFTs dump
+# generation.
+#
+
+@IBSCRIPTPATH@/dump_fts -M $@
+echo ""
+echo "*** WARNING ***: this command has been replaced by dump_fts -M"
+echo ""
+echo ""
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
