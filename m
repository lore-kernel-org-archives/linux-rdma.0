From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 2/3] infiniband-diags: add dump_fts tool
Date: Wed, 6 Feb 2013 15:46:19 -0800
Message-ID: <20130206154619.d16aad80ad4828e9b6067440@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




dump_fts adds a faster version of the functionality of dump_[l|m]fts.sh.  This
code is based off of the ibroute code and simply uses libibnetdisc to scan the
fabric instead of using ibnetdiscover and letting ibroute requery all that data
over again.  This improves things in 3 ways.

1) performance improves by nearly 2 orders of magnitude.
2) this version greatly reduces the mads required and thus reduces the
   impact on the fabric.
3) Everything is queried with DR paths which ensures if the routing tables are
   bad on the cluster the query will still complete and give you the
   information you were looking for.  (To be fair dump_lft.sh has the DR option
   but it is currently buggy.)

Example runs on the ~1400 nodes of the Hyperion test cluster show:

13:45:46 > time ./dump_lfts.sh > /dev/null

real    4m58.175s
user    0m6.407s
sys     0m17.983s

13:53:12 > time ./dump_fts > /dev/null
dump tables: linear forwarding table get failed

real    0m8.121s
user    0m3.032s
sys     0m3.342s

Changes from V1:
	Add status and query information to error messages.
	Add man page files which were missed in the first patch

Changes from V2:
	Additional status and address information on error messages.
	clean up error handling when fabric scan fails.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am               |    7 +-
 configure.in              |    1 +
 doc/man/dump_fts.8.in     |  236 ++++++++++++++++++++++
 doc/rst/dump_fts.8.in.rst |   85 ++++++++
 infiniband-diags.spec.in  |    2 +
 src/dump_fts.c            |  489 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 819 insertions(+), 1 deletions(-)
 create mode 100644 doc/man/dump_fts.8.in
 create mode 100644 doc/rst/dump_fts.8.in.rst
 create mode 100644 src/dump_fts.c

diff --git a/Makefile.am b/Makefile.am
index a35a432..42c2c75 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,7 +15,8 @@ sbin_PROGRAMS = src/ibaddr src/ibnetdiscover src/ibping src/ibportstate \
 	        src/perfquery src/sminfo src/smpdump src/smpquery \
 	        src/saquery src/vendstat src/iblinkinfo \
 		src/ibqueryerrors src/ibcacheedit src/ibccquery \
-		src/ibccconfig
+		src/ibccconfig \
+		src/dump_fts
 
 if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
@@ -45,6 +46,7 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/ibcacheedit.8 \
 		doc/man/ibccconfig.8 \
 		doc/man/ibccquery.8 \
+		doc/man/dump_fts.8 \
 		doc/man/dump_lfts.8 \
 		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
@@ -118,6 +120,9 @@ src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 src_ibcacheedit_SOURCES = src/ibcacheedit.c
 src_ibcacheedit_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 
+src_dump_fts_SOURCES = src/dump_fts.c
+src_dump_fts_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
+
 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
 	if [ -x $(top_srcdir)/gen_ver.sh ] ; then \
diff --git a/configure.in b/configure.in
index ca62d5b..b54222b 100644
--- a/configure.in
+++ b/configure.in
@@ -221,6 +221,7 @@ AC_CONFIG_FILES([\
 	doc/man/ibcacheedit.8 \
 	doc/man/ibccconfig.8 \
 	doc/man/ibccquery.8 \
+	doc/man/dump_fts.8 \
 	doc/man/dump_lfts.8 \
 	doc/man/dump_mfts.8 \
 	doc/man/ibhosts.8 \
diff --git a/doc/man/dump_fts.8.in b/doc/man/dump_fts.8.in
new file mode 100644
index 0000000..a64c6da
--- /dev/null
+++ b/doc/man/dump_fts.8.in
@@ -0,0 +1,236 @@
+.\" Man page generated from reStructeredText.
+.
+.TH DUMP_FTS 8 "@BUILD_DATE@" "" "OpenIB Diagnostics"
+.SH NAME
+DUMP_FTS \- dump InfiniBand forwarding tables
+.
+.nr rst2man-indent-level 0
+.
+.de1 rstReportMargin
+\\$1 \\n[an-margin]
+level \\n[rst2man-indent-level]
+level margin: \\n[rst2man-indent\\n[rst2man-indent-level]]
+-
+\\n[rst2man-indent0]
+\\n[rst2man-indent1]
+\\n[rst2man-indent2]
+..
+.de1 INDENT
+.\" .rstReportMargin pre:
+. RS \\$1
+. nr rst2man-indent\\n[rst2man-indent-level] \\n[an-margin]
+. nr rst2man-indent-level +1
+.\" .rstReportMargin post:
+..
+.de UNINDENT
+. RE
+.\" indent \\n[an-margin]
+.\" old: \\n[rst2man-indent\\n[rst2man-indent-level]]
+.nr rst2man-indent-level -1
+.\" new: \\n[rst2man-indent\\n[rst2man-indent-level]]
+.in \\n[rst2man-indent\\n[rst2man-indent-level]]u
+..
+.SH SYNOPSIS
+.sp
+dump_fts [options] [<startlid> [<endlid>]]
+.SH DESCRIPTION
+.sp
+dump_fts is similar to ibroute but dumps tables for every switch found in an
+ibnetdiscover scan of the subnet.
+.sp
+The dump file format is compatible with loading into OpenSM using
+the \-R file \-U /path/to/dump\-file syntax.
+.SH OPTIONS
+.INDENT 0.0
+.TP
+.B \fB\-a, \-\-all\fP
+.sp
+show all lids in range, even invalid entries
+.TP
+.B \fB\-n, \-\-no_dests\fP
+.sp
+do not try to resolve destinations
+.TP
+.B \fB\-M, \-\-Multicast\fP
+.sp
+show multicast forwarding tables
+In this case, the range parameters are specifying the mlid range.
+.UNINDENT
+.SS Port Selection flags
+.\" Define the common option -C
+.
+.sp
+\fB\-C, \-\-Ca <ca_name>\fP    use the specified ca_name.
+.\" Define the common option -P
+.
+.sp
+\fB\-P, \-\-Port <ca_port>\fP    use the specified ca_port.
+.\" Explanation of local port selection
+.
+.SS Local port Selection
+.sp
+Multiple port/Multiple CA support: when no IB device or port is specified
+(see the "local umad parameters" below), the libibumad library
+selects the port to use by the following criteria:
+.INDENT 0.0
+.INDENT 3.5
+.INDENT 0.0
+.IP 1. 3
+.
+the first port that is ACTIVE.
+.IP 2. 3
+.
+if not found, the first port that is UP (physical link up).
+.UNINDENT
+.sp
+If a port and/or CA name is specified, the libibumad library attempts
+to fulfill the user request, and will fail if it is not possible.
+.sp
+For example:
+.sp
+.nf
+.ft C
+ibaddr                 # use the first port (criteria #1 above)
+ibaddr \-C mthca1       # pick the best port from "mthca1" only.
+ibaddr \-P 2            # use the second (active/up) port from the first available IB device.
+ibaddr \-C mthca0 \-P 2  # use the specified port only.
+.ft P
+.fi
+.UNINDENT
+.UNINDENT
+.SS Debugging flags
+.\" Define the common option -d
+.
+.INDENT 0.0
+.TP
+.B \-d
+.
+raise the IB debugging level.
+May be used several times (\-ddd or \-d \-d \-d).
+.UNINDENT
+.\" Define the common option -e
+.
+.INDENT 0.0
+.TP
+.B \-e
+.
+show send and receive errors (timeouts and others)
+.UNINDENT
+.\" Define the common option -h
+.
+.sp
+\fB\-h, \-\-help\fP      show the usage message
+.\" Define the common option -v
+.
+.INDENT 0.0
+.TP
+.B \fB\-v, \-\-verbose\fP
+.sp
+increase the application verbosity level.
+May be used several times (\-vv or \-v \-v \-v)
+.UNINDENT
+.\" Define the common option -V
+.
+.sp
+\fB\-V, \-\-version\fP     show the version info.
+.SS Configuration flags
+.\" Define the common option -t
+.
+.sp
+\fB\-t, \-\-timeout <timeout_ms>\fP override the default timeout for the solicited mads.
+.\" Define the common option -y
+.
+.INDENT 0.0
+.TP
+.B \fB\-y, \-\-m_key <key>\fP
+.sp
+use the specified M_key for requests. If non\-numeric value (like \(aqx\(aq)
+is specified then a value will be prompted for.
+.UNINDENT
+.\" Define the common option --node-name-map
+.
+.sp
+\fB\-\-node\-name\-map <node\-name\-map>\fP Specify a node name map.
+.INDENT 0.0
+.INDENT 3.5
+.sp
+This file maps GUIDs to more user friendly names.  See FILES section.
+.UNINDENT
+.UNINDENT
+.\" Define the common option -z
+.
+.sp
+\fB\-\-config, \-z  <config_file>\fP Specify alternate config file.
+.INDENT 0.0
+.INDENT 3.5
+.sp
+Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
+.UNINDENT
+.UNINDENT
+.SH FILES
+.\" Common text for the config file
+.
+.SS CONFIG FILE
+.sp
+@IBDIAG_CONFIG_PATH@/ibdiag.conf
+.sp
+A global config file is provided to set some of the common options for all
+tools.  See supplied config file for details.
+.\" Common text to describe the node name map file.
+.
+.SS NODE NAME MAP FILE FORMAT
+.sp
+The node name map is used to specify user friendly names for nodes in the
+output.  GUIDs are used to perform the lookup.
+.sp
+This functionality is provided by the opensm\-libs package.  See \fBopensm(8)\fP
+for the file location for your installation.
+.sp
+\fBGenerically:\fP
+.sp
+.nf
+.ft C
+# comment
+<guid> "<name>"
+.ft P
+.fi
+.sp
+\fBExample:\fP
+.sp
+.nf
+.ft C
+# IB1
+# Line cards
+0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
+0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB\-24D"
+0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
+0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB\-24D"
+0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB\-24D"
+
+# Spines
+0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
+0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
+0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB\-12D"
+0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
+0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB\-12D"
+
+# GUID   Node Name
+0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
+0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
+0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
+0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
+.ft P
+.fi
+.SH SEE ALSO
+.sp
+\fBdump_lfts(8), dump_mfts(8), ibroute(8), ibswitches(8), opensm(8)\fP
+.SH AUTHORS
+.INDENT 0.0
+.TP
+.B Ira Weiny
+.
+< \fI\%weiny2-i2BcT+NCU+M@public.gmane.org\fP >
+.UNINDENT
+.\" Generated by docutils manpage writer.
+.\" 
+.
diff --git a/doc/rst/dump_fts.8.in.rst b/doc/rst/dump_fts.8.in.rst
new file mode 100644
index 0000000..dc0fe65
--- /dev/null
+++ b/doc/rst/dump_fts.8.in.rst
@@ -0,0 +1,85 @@
+========
+DUMP_FTS
+========
+
+---------------------------------
+dump InfiniBand forwarding tables
+---------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+
+SYNOPSIS
+========
+
+dump_fts [options] [<startlid> [<endlid>]]
+
+
+DESCRIPTION
+===========
+
+dump_fts is similar to ibroute but dumps tables for every switch found in an
+ibnetdiscover scan of the subnet.
+
+The dump file format is compatible with loading into OpenSM using
+the -R file -U /path/to/dump-file syntax.
+
+OPTIONS
+=======
+
+**-a, --all**
+        show all lids in range, even invalid entries
+
+**-n, --no_dests**
+        do not try to resolve destinations
+
+**-M, --Multicast**
+        show multicast forwarding tables
+        In this case, the range parameters are specifying the mlid range.
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_y.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_z-config.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+
+SEE ALSO
+========
+
+**dump_lfts(8), dump_mfts(8), ibroute(8), ibswitches(8), opensm(8)**
+
+
+AUTHORS
+=======
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index 9cd195b..1e75e4d 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -127,6 +127,8 @@ rm -rf $RPM_BUILD_ROOT
 %{_mandir}/man8/ibccquery.8.gz
 %{_sbindir}/ibccconfig
 %{_mandir}/man8/ibccconfig.8.gz
+%{_sbindir}/dump_fts
+%{_mandir}/man8/dump_fts.8.gz
 
 # scripts here
 %{_sbindir}/ibhosts
diff --git a/src/dump_fts.c b/src/dump_fts.c
new file mode 100644
index 0000000..6cf51f1
--- /dev/null
+++ b/src/dump_fts.c
@@ -0,0 +1,489 @@
+/*
+ * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2009-2011 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2013 Lawrence Livermore National Security.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <inttypes.h>
+#include <getopt.h>
+#include <netinet/in.h>
+#include <assert.h>
+
+#include <infiniband/umad.h>
+#include <infiniband/mad.h>
+#include <complib/cl_nodenamemap.h>
+
+#include <infiniband/ibnetdisc.h>
+
+#include "ibdiag_common.h"
+
+struct ibmad_port *srcport;
+
+unsigned startlid = 0, endlid = 0;
+
+static int brief, dump_all, multicast;
+
+static char *node_name_map_file = NULL;
+static nn_map_t *node_name_map = NULL;
+
+#define IB_MLIDS_IN_BLOCK	(IB_SMP_DATA_SIZE/2)
+
+int dump_mlid(char *str, int strlen, unsigned mlid, unsigned nports,
+	      uint16_t mft[16][IB_MLIDS_IN_BLOCK])
+{
+	uint16_t mask;
+	unsigned i, chunk, bit, nonzero = 0;
+
+	if (brief) {
+		int n = 0;
+		unsigned chunks = ALIGN(nports + 1, 16) / 16;
+		for (i = 0; i < chunks; i++) {
+			mask = ntohs(mft[i][mlid % IB_MLIDS_IN_BLOCK]);
+			if (mask)
+				nonzero++;
+			n += snprintf(str + n, strlen - n, "%04hx", mask);
+			if (n >= strlen) {
+				n = strlen;
+				break;
+			}
+		}
+		if (!nonzero && !dump_all) {
+			str[0] = 0;
+			return 0;
+		}
+		return n;
+	}
+	for (i = 0; i <= nports; i++) {
+		chunk = i / 16;
+		bit = i % 16;
+
+		mask = ntohs(mft[chunk][mlid % IB_MLIDS_IN_BLOCK]);
+		if (mask)
+			nonzero++;
+		str[i * 2] = (mask & (1 << bit)) ? 'x' : ' ';
+		str[i * 2 + 1] = ' ';
+	}
+	if (!nonzero && !dump_all) {
+		str[0] = 0;
+		return 0;
+	}
+	str[i * 2] = 0;
+	return i * 2;
+}
+
+uint16_t mft[16][IB_MLIDS_IN_BLOCK] = { { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0}, { 0 }, { 0 } };
+
+void dump_multicast_tables(ibnd_node_t * node, unsigned startlid,
+			    unsigned endlid, struct ibmad_port * mad_port)
+{
+	ib_portid_t *portid = &node->path_portid;
+	char nd[IB_SMP_DATA_SIZE] = { 0 };
+	char str[512];
+	char *s;
+	uint64_t nodeguid;
+	uint32_t mod;
+	unsigned block, i, j, e, nports, cap, chunks, startblock, lastblock,
+	    top;
+	char *mapnd = NULL;
+	int n = 0;
+
+	memcpy(nd, node->nodedesc, strlen(node->nodedesc));
+	nports = node->numports;
+	nodeguid = node->guid;
+
+	mad_decode_field(node->switchinfo, IB_SW_MCAST_FDB_CAP_F, &cap);
+	mad_decode_field(node->switchinfo, IB_SW_MCAST_FDB_TOP_F, &top);
+
+	if (!endlid || endlid > IB_MIN_MCAST_LID + cap - 1)
+		endlid = IB_MIN_MCAST_LID + cap - 1;
+	if (!dump_all && top && top < endlid) {
+		if (top < IB_MIN_MCAST_LID - 1)
+			IBWARN("illegal top mlid %x", top);
+		else
+			endlid = top;
+	}
+
+	if (!startlid)
+		startlid = IB_MIN_MCAST_LID;
+	else if (startlid < IB_MIN_MCAST_LID) {
+		IBWARN("illegal start mlid %x, set to %x", startlid,
+		       IB_MIN_MCAST_LID);
+		startlid = IB_MIN_MCAST_LID;
+	}
+
+	if (endlid > IB_MAX_MCAST_LID) {
+		IBWARN("illegal end mlid %x, truncate to %x", endlid,
+		       IB_MAX_MCAST_LID);
+		endlid = IB_MAX_MCAST_LID;
+	}
+
+	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+
+	printf("Multicast mlids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
+	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
+	       mapnd);
+
+	if (brief)
+		printf(" MLid       Port Mask\n");
+	else {
+		if (nports > 9) {
+			for (i = 0, s = str; i <= nports; i++) {
+				*s++ = (i % 10) ? ' ' : '0' + i / 10;
+				*s++ = ' ';
+			}
+			*s = 0;
+			printf("            %s\n", str);
+		}
+		for (i = 0, s = str; i <= nports; i++)
+			s += sprintf(s, "%d ", i % 10);
+		printf("     Ports: %s\n", str);
+		printf(" MLid\n");
+	}
+	if (ibverbose)
+		printf("Switch multicast mlid capability is %d top is 0x%x\n",
+		       cap, top);
+
+	chunks = ALIGN(nports + 1, 16) / 16;
+
+	startblock = startlid / IB_MLIDS_IN_BLOCK;
+	lastblock = endlid / IB_MLIDS_IN_BLOCK;
+	for (block = startblock; block <= lastblock; block++) {
+		for (j = 0; j < chunks; j++) {
+			int status;
+			mod = (block - IB_MIN_MCAST_LID / IB_MLIDS_IN_BLOCK)
+			    | (j << 28);
+
+			DEBUG("reading block %x chunk %d mod %x", block, j,
+			      mod);
+			if (!smp_query_status_via
+			    (mft + j, portid, IB_ATTR_MULTICASTFORWTBL, mod, 0,
+			     &status, mad_port)) {
+				fprintf(stderr, "SubnGet(MFT) failed on switch "
+						"'%s' %s Node GUID 0x%"PRIx64
+						" SMA LID %d; MAD status 0x%x "
+						"AM 0x%x\n",
+						mapnd, portid2str(portid),
+						node->guid, node->smalid,
+						status, mod);
+			}
+		}
+
+		i = block * IB_MLIDS_IN_BLOCK;
+		e = i + IB_MLIDS_IN_BLOCK;
+		if (i < startlid)
+			i = startlid;
+		if (e > endlid + 1)
+			e = endlid + 1;
+
+		for (; i < e; i++) {
+			if (dump_mlid(str, sizeof str, i, nports, mft) == 0)
+				continue;
+			printf("0x%04x      %s\n", i, str);
+			n++;
+		}
+	}
+
+	printf("%d %smlids dumped \n", n, dump_all ? "" : "valid ");
+
+	free(mapnd);
+}
+
+int dump_lid(char *str, int str_len, int lid, int valid,
+		ibnd_fabric_t *fabric,
+		int * last_port_lid, int * base_port_lid,
+		uint64_t * portguid)
+{
+	char nd[IB_SMP_DATA_SIZE] = { 0 };
+
+	ibnd_port_t *port = NULL;
+
+	char ntype[50], sguid[30];
+	uint64_t nodeguid;
+	int baselid, lmc, type;
+	char *mapnd = NULL;
+	int rc;
+
+	if (brief) {
+		str[0] = 0;
+		return 0;
+	}
+
+	if (lid <= *last_port_lid) {
+		if (!valid)
+			return snprintf(str, str_len,
+					": (path #%d - illegal port)",
+					lid - *base_port_lid);
+		else if (!*portguid)
+			return snprintf(str, str_len,
+					": (path #%d out of %d)",
+					lid - *base_port_lid + 1,
+					*last_port_lid - *base_port_lid + 1);
+		else {
+			return snprintf(str, str_len,
+					": (path #%d out of %d: portguid %s)",
+					lid - *base_port_lid + 1,
+					*last_port_lid - *base_port_lid + 1,
+					mad_dump_val(IB_NODE_PORT_GUID_F, sguid,
+						     sizeof sguid, portguid));
+		}
+	}
+
+	if (!valid)
+		return snprintf(str, str_len, ": (illegal port)");
+
+	*portguid = 0;
+
+	port = ibnd_find_port_lid(fabric, lid);
+	if (!port) {
+		return snprintf(str, str_len, ": (node info not available fabric scan)");
+	}
+
+	nodeguid = port->node->guid;
+	*portguid = port->guid;
+	type = port->node->type;
+
+	baselid = port->base_lid;
+	lmc = port->lmc;
+
+	memcpy(nd, port->node->nodedesc, strlen(port->node->nodedesc));
+
+	if (lmc > 0) {
+		*base_port_lid = baselid;
+		*last_port_lid = baselid + (1 << lmc) - 1;
+	}
+
+	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+ 
+	rc = snprintf(str, str_len, ": (%s portguid %s: '%s')",
+		      mad_dump_val(IB_NODE_TYPE_F, ntype, sizeof ntype,
+				   &type), mad_dump_val(IB_NODE_PORT_GUID_F,
+							sguid, sizeof sguid,
+							portguid),
+		      mapnd);
+
+	free(mapnd);
+	return rc;
+}
+
+void dump_unicast_tables(ibnd_node_t * node, int startlid, int endlid,
+			struct ibmad_port *mad_port, ibnd_fabric_t *fabric)
+{
+	ib_portid_t * portid = &node->path_portid;
+	char lft[IB_SMP_DATA_SIZE] = { 0 };
+	char nd[IB_SMP_DATA_SIZE] = { 0 };
+	char str[200];
+	uint64_t nodeguid;
+	int block, i, e, top;
+	unsigned nports;
+	int n = 0, startblock, endblock;
+	char *mapnd = NULL;
+	int last_port_lid = 0, base_port_lid = 0;
+	uint64_t portguid = 0;
+
+	mad_decode_field(node->switchinfo, IB_SW_LINEAR_FDB_TOP_F, &top);
+	nodeguid = node->guid;
+	nports = node->numports;
+	memcpy(nd, node->nodedesc, strlen(node->nodedesc));
+
+	if (!endlid || endlid > top)
+		endlid = top;
+
+	if (endlid > IB_MAX_UCAST_LID) {
+		IBWARN("illegal lft top %d, truncate to %d", endlid,
+		       IB_MAX_UCAST_LID);
+		endlid = IB_MAX_UCAST_LID;
+	}
+
+	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+
+	printf("Unicast lids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
+	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
+	       mapnd);
+
+	DEBUG("Switch top is 0x%x\n", top);
+
+	printf("  Lid  Out   Destination\n");
+	printf("       Port     Info \n");
+	startblock = startlid / IB_SMP_DATA_SIZE;
+	endblock = ALIGN(endlid, IB_SMP_DATA_SIZE) / IB_SMP_DATA_SIZE;
+	for (block = startblock; block <= endblock; block++) {
+		int status;
+		DEBUG("reading block %d", block);
+		if (!smp_query_status_via(lft, portid, IB_ATTR_LINEARFORWTBL, block,
+				   0, &status, mad_port)) {
+			fprintf(stderr, "SubnGet(LFT) failed on switch "
+					"'%s' %s Node GUID 0x%"PRIx64
+					" SMA LID %d; MAD status 0x%x AM 0x%x\n",
+					mapnd, portid2str(portid),
+					node->guid, node->smalid,
+					status, block);
+		}
+		i = block * IB_SMP_DATA_SIZE;
+		e = i + IB_SMP_DATA_SIZE;
+		if (i < startlid)
+			i = startlid;
+		if (e > endlid + 1)
+			e = endlid + 1;
+
+		for (; i < e; i++) {
+			unsigned outport = lft[i % IB_SMP_DATA_SIZE];
+			unsigned valid = (outport <= nports);
+
+			if (!valid && !dump_all)
+				continue;
+			dump_lid(str, sizeof str, i, valid, fabric,
+				&last_port_lid, &base_port_lid, &portguid);
+			printf("0x%04x %03u %s\n", i, outport & 0xff, str);
+			n++;
+		}
+	}
+
+	printf("%d %slids dumped \n", n, dump_all ? "" : "valid ");
+	free(mapnd);
+}
+
+void dump_node(ibnd_node_t *node, struct ibmad_port *mad_port,
+		ibnd_fabric_t *fabric)
+{
+	if (multicast)
+		dump_multicast_tables(node, startlid, endlid, mad_port);
+	else
+		dump_unicast_tables(node, startlid, endlid,
+						mad_port, fabric);
+}
+
+void process_switch(ibnd_node_t * node, void *fabric)
+{
+	dump_node(node, srcport, (ibnd_fabric_t *)fabric);
+}
+
+static int process_opt(void *context, int ch, char *optarg)
+{
+	switch (ch) {
+	case 'a':
+		dump_all++;
+		break;
+	case 'M':
+		multicast++;
+		break;
+	case 'n':
+		brief++;
+		break;
+	case 1:
+		node_name_map_file = strdup(optarg);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int rc = 0;
+	int mgmt_classes[3] =
+	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
+
+	struct ibnd_config config = { 0 };
+	ibnd_fabric_t *fabric = NULL;
+
+	const struct ibdiag_opt opts[] = {
+		{"all", 'a', 0, NULL, "show all lids, even invalid entries"},
+		{"no_dests", 'n', 0, NULL,
+		 "do not try to resolve destinations"},
+		{"Multicast", 'M', 0, NULL, "show multicast forwarding tables"},
+		{"node-name-map", 1, 1, "<file>", "node name map file"},
+		{0}
+	};
+	char usage_args[] = "[<dest dr_path|lid|guid> [<startlid> [<endlid>]]]";
+	const char *usage_examples[] = {
+		" -- Unicast examples:",
+		"-a\t# same, but dump all lids, even with invalid out ports",
+		"-n\t# simple dump format - no destination resolving",
+		"10\t# dump lids starting from 10",
+		"0x10 0x20\t# dump lid range",
+		" -- Multicast examples:",
+		"-M\t# dump all non empty mlids of switch with lid 4",
+		"-M 0xc010 0xc020\t# same, but with range",
+		"-M -n\t# simple dump format",
+		NULL,
+	};
+
+	ibdiag_process_opts(argc, argv, &config, "KGDLs", opts, process_opt,
+			    usage_args, usage_examples);
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc > 0)
+		startlid = strtoul(argv[0], 0, 0);
+	if (argc > 1)
+		endlid = strtoul(argv[1], 0, 0);
+
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
+	if (!srcport)
+		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+
+	node_name_map = open_node_name_map(node_name_map_file);
+
+	smp_mkey_set(srcport, ibd_mkey);
+
+	if (ibd_timeout) {
+		mad_rpc_set_timeout(srcport, ibd_timeout);
+		config.timeout_ms = ibd_timeout;
+	}
+
+	config.flags = ibd_ibnetdisc_flags;
+	config.mkey = ibd_mkey;
+
+	if ((fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL,
+						&config)) != NULL) {
+		ibnd_iter_nodes_type(fabric, process_switch, IB_NODE_SWITCH, fabric);
+	} else {
+		fprintf(stderr, "Failed to discover fabric\n");
+		rc = -1;
+	}
+
+	ibnd_destroy_fabric(fabric);
+
+	mad_rpc_close_port(srcport);
+	close_node_name_map(node_name_map);
+	exit(rc);
+}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
