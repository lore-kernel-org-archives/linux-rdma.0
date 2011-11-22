From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/5] infiniband-diags: iblinkinfo add "check" capabilities
 against ibfabricconf file
Date: Mon, 21 Nov 2011 16:02:58 -0800
Message-ID: <20111121160258.1bc0c66a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



This change introduces a glib dependancy to support list features

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am         |   17 +-
 configure.in        |    8 +
 man/iblinkinfo.8    |   85 ------
 man/iblinkinfo.8.in |  213 +++++++++++++
 src/checkfabric.c   |  822 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/checkfabric.h   |   60 ++++
 src/iblinkinfo.c    |  180 +++++++++---
 7 files changed, 1251 insertions(+), 134 deletions(-)
 delete mode 100644 man/iblinkinfo.8
 create mode 100644 man/iblinkinfo.8.in
 create mode 100644 src/checkfabric.c
 create mode 100644 src/checkfabric.h

diff --git a/Makefile.am b/Makefile.am
index d64bb2c..4aaa41a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -6,7 +6,8 @@ endif
 SUBDIRS = libibnetdisc $(IBFABRICCONF)
 
 INCLUDES = -I$(top_builddir)/include/ -I$(srcdir)/include -I$(includedir) \
-	-I$(includedir)/infiniband -I$(top_srcdir)/libibnetdisc/include
+	-I$(includedir)/infiniband -I$(top_srcdir)/libibnetdisc/include \
+	-I$(top_srcdir)/libibfabricconf/include
 
 if DEBUG
 DBGFLAGS = -ggdb -D_DEBUG_
@@ -64,13 +65,24 @@ src_ibsendtrap_SOURCES = src/ibsendtrap.c
 src_vendstat_SOURCES = src/vendstat.c
 src_mcm_rereg_test_SOURCES = src/mcm_rereg_test.c
 src_iblinkinfo_SOURCES = src/iblinkinfo.c
-src_ibccquery_SOURCES = src/ibccquery.c
 src_iblinkinfo_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
+src_ibccquery_SOURCES = src/ibccquery.c
 src_ibqueryerrors_SOURCES = src/ibqueryerrors.c
 src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 src_ibcacheedit_SOURCES = src/ibcacheedit.c
 src_ibcacheedit_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 
+if HAVE_XML
+src_iblinkinfo_SOURCES = src/iblinkinfo.c src/checkfabric.c src/checkfabric.h
+src_iblinkinfo_CFLAGS = $(GLIB_CFLAGS)
+src_iblinkinfo_LDFLAGS = -losmcomp -libmad \
+	-L$(top_builddir)/libibnetdisc -libnetdisc \
+	-L$(top_builddir)/libibfabricconf -libfabricconf $(GLIB_LIBS)
+else
+src_iblinkinfo_SOURCES = src/iblinkinfo.c
+src_iblinkinfo_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
+endif
+
 man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 	man/ibchecknet.8 man/ibchecknode.8 man/ibcheckport.8 \
 	man/ibcheckportstate.8 man/ibcheckportwidth.8 man/ibcheckstate.8 \
@@ -87,6 +99,7 @@ man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 	man/check_lft_balance.8 man/ibcacheedit.8 \
 	man/infiniband-diags.8 man/ibccquery.8
 
+
 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
 	if [ -x $(top_srcdir)/gen_ver.sh ] ; then \
diff --git a/configure.in b/configure.in
index 175a358..0652948 100644
--- a/configure.in
+++ b/configure.in
@@ -146,6 +146,13 @@ IBSCRIPTPATH_TMP2="`echo $IBSCRIPTPATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`
 IBSCRIPTPATH="${with_ibpath_override:-`eval echo $IBSCRIPTPATH_TMP2`}"
 AC_SUBST(IBSCRIPTPATH)
 
+dnl check for glib
+PKG_CHECK_MODULES([GLIB], [glib-2.0], ac_glib=yes, ac_glib=no)
+AM_CONDITIONAL([HAVE_GLIB], test "$ac_glib" = "yes")
+if test "$ac_glib" = "yes"; then
+   AC_DEFINE([HAVE_GLIB], 1, [Define to 1 to indicate GLIB support])
+fi
+
 dnl Begin libibfabricconf stuff
 dnl find the XML support for ibfabricconf
 PKG_CHECK_MODULES([XML], [libxml-2.0], ac_xml=yes, ac_xml=no)
@@ -199,5 +206,6 @@ AC_CONFIG_FILES([\
 	libibnetdisc/Makefile \
 	libibfabricconf/Makefile \
 	libibfabricconf/include/infiniband/ibfabricconf.h \
+	man/iblinkinfo.8 \
 ])
 AC_OUTPUT
diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
deleted file mode 100644
index 5fa2678..0000000
--- a/man/iblinkinfo.8
+++ /dev/null
@@ -1,85 +0,0 @@
-.TH IBLINKINFO 8 "Jan 24, 2008" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-iblinkinfo \- report link info for all links in the fabric
-
-.SH SYNOPSIS
-.B iblinkinfo
-   [-hcdl -C <ca_name> -P <ca_port> -p -S <port_guid> -G <port_guid> -D <direct_route> \-\-load\-cache <filename>]
-
-.SH DESCRIPTION
-.PP
-iblinkinfo reports link info for each port in an IB fabric, node by node.
-Optionally, iblinkinfo can do partial scans and limit its output to parts of a
-fabric.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-S <port_guid>\fR \fB\-G <port_guid>\fR \fB\-\-port\-guid\fR
-start partial scan at the port specified by <port_guid> (hex format)
-.TP
-\fB\-D <direct_route>\fR
-start partial scan at the port specified by the direct route path.
-.TP
-\fB\-l\fR
-Print all information for each link on one line. Default is to print a header
-with the node information and then a list for each port (useful for
-grep\'ing output).
-.TP
-\fB\-d\fR
-Print only nodes which have a port in the "Down" state.
-.TP
-\fB\-p\fR
-Print additional port settings (<LifeTime>,<HoqLife>,<VLStallCount>)
-.TP
-\fB\-C <ca_name>\fR    use the specified ca_name for the search.
-.TP
-\fB\-P <ca_port>\fR    use the specified ca_port for the search.
-.TP
-\fB\-R\fR (This option is obsolete and does nothing)
-.TP
-\fB\-\-load\-cache\fR <filename>
-Load and use the cached ibnetdiscover data stored in the specified
-filename.  May be useful for outputting and learning about other
-fabrics or a previous state of a fabric.  Cannot be used if user
-specifies a direct route path.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-diff\fR <filename>
-Load cached ibnetdiscover data and do a diff comparison to the current
-network or another cache.  A special diff output for iblinkinfo
-output will be displayed showing differences between the old and current
-fabric links.  Be default, the following are compared for differences:
-port connections and port state.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-diffcheck\fR <key(s)>
-Specify what diff checks should be done in the \fB\-\-diff\fR option above.
-Comma separate multiple diff check key(s).  The available diff checks
-are:\fIport\fR = port connections, \fIstate\fR = port state, \fIlid\fR = lids,
-\fInodedesc\fR = node descriptions.  If \fIport\fR is specified alongside \fIlid\fR
-or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
-.TP
-\fB\-\-filterdownports\fR <filename>
-Filter downports indicated in a ibnetdiscover cache.  If a port was previously
-indicated as down in the specified cache, and is still down, do not output it in the
-resulting output.  This option may be particularly useful for environments
-where switches are not fully populated, thus much of the default iblinkinfo
-info is considered unuseful.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-switches\-only\fR
-Show only switches in output.
-.TP
-\fB\-\-cas\-only\fR
-Show only CAs in output.
-
-.SH AUTHOR
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/iblinkinfo.8.in b/man/iblinkinfo.8.in
new file mode 100644
index 0000000..6e7241b
--- /dev/null
+++ b/man/iblinkinfo.8.in
@@ -0,0 +1,213 @@
+.TH IBLINKINFO 8 "Jan 24, 2008" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+iblinkinfo \- report link info for all links in the fabric
+
+.SH SYNOPSIS
+.B iblinkinfo
+   [-hcdl -C <ca_name> -P <ca_port> -p -S <port_guid> -G <port_guid> -D <direct_route> \-\-load\-cache <filename>]
+
+.SH DESCRIPTION
+.PP
+iblinkinfo reports link information for each port in an IB fabric, node by node.
+Optionally, iblinkinfo can do partial scans and limit its output to parts of a
+fabric.
+
+Alternately, in "check mode" iblinkinfo scans an attached IB fabric, reads the
+ib fabric config file, and checks the two.  Checks performed include invalid
+cabling, downed/disabled ports, invalid speed, and invalid width's.
+
+While iblinkinfo can create it's config file from a scan of an IB fabric this
+is not the intended use case.  The fabric config is intended to document the
+desired cabling and properties of an IB fabric, generated from vendor cabling
+documentation.  This document can then be verified against reality by
+iblinkinfo -c.  For simply diffing the fabric from one run to the next both
+ibnetdiscover and iblinkinfo have cache capabilities.
+
+See \fBFILES\fR for more information on the configuration file format.
+
+.SH OPTIONS
+
+.PP
+.TP
+\fB\-S <port_guid>\fR \fB\-G <port_guid>\fR \fB\-\-port\-guid\fR
+start partial scan at the port specified by <port_guid> (hex format)
+.TP
+\fB\-D <direct_route>\fR
+start partial scan at the port specified by the direct route path.
+.TP
+\fB\-l\fR
+Print all information for each link on one line. Default is to print a header
+with the node information and then a list for each port (useful for
+grep\'ing output).
+.TP
+\fB\-d\fR
+Print only nodes which have a port in the "Down" state.
+.TP
+\fB\-p\fR
+Print additional port settings (<LifeTime>,<HoqLife>,<VLStallCount>)
+.TP
+\fB\-C <ca_name>\fR    use the specified ca_name for the search.
+.TP
+\fB\-P <ca_port>\fR    use the specified ca_port for the search.
+.TP
+\fB\-R\fR (This option is obsolete and does nothing)
+.TP
+\fB\-\-load\-cache\fR <filename>
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.  Cannot be used if user
+specifies a direct route path.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
+.TP
+\fB\-\-diff\fR <filename>
+Load cached ibnetdiscover data and do a diff comparison to the current
+network or another cache.  A special diff output for iblinkinfo
+output will be displayed showing differences between the old and current
+fabric links.  Be default, the following are compared for differences:
+port connections and port state.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
+.TP
+\fB\-\-diffcheck\fR <key(s)>
+Specify what diff checks should be done in the \fB\-\-diff\fR option above.
+Comma separate multiple diff check key(s).  The available diff checks
+are:\fIport\fR = port connections, \fIstate\fR = port state, \fIlid\fR = lids,
+\fInodedesc\fR = node descriptions.  If \fIport\fR is specified alongside \fIlid\fR
+or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
+.TP
+\fB\-\-filterdownports\fR <filename>
+Filter downports indicated in a ibnetdiscover cache.  If a port was previously
+indicated as down in the specified cache, and is still down, do not output it in the
+resulting output.  This option may be particularly useful for environments
+where switches are not fully populated, thus much of the default iblinkinfo
+info is considered unuseful.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
+
+.TP
+\fB\-\-switches\-only\fR
+Show only switches in output. (does not affect "check" mode)
+.TP
+\fB\-\-cas\-only\fR
+Show only CAs in output. (does not affect "check" mode)
+
+
+.SH CHECK OPTIONS
+.TP
+"Check" and "generate" options apply only when XML support was enabled for the build.
+
+.TP
+\fB\-check, \-c\fR
+Check links against ibfabricconf.xml config.
+
+.TP
+\fB\-config <ibfabricconf>\fR
+Specify an alternate config file (default: @IBDIAG_CONFIG_PATH@/ibfabricconf.xml)
+
+.TP
+\fB\-\-downnodes <nodelist>\fR
+Specify nodes which are known to be off thus indicating that links to those
+nodes are known to be down.  "nodelist" is a comma separated list of node
+description names.
+
+.TP
+\fB\-\-smlid <lid>\fR
+Specify an smlid to verify on all active ports.
+
+.TP
+\fB\-\-addr-info <lid>\fR
+Print port GUID and LID information for the ports being reported as errors.
+
+
+.SH GENERATE OPTIONS
+
+Although not the intended use case for this utility is it understood that the
+generation of this config file from an existing fabric can be very useful.  The
+following options allow for this.
+
+.TP
+\fB\-\-generate\-config <config>\fR
+Generate a config file from a scan of the fabric.  NOTE that this config file
+is somewhat generic in nature as it does not include any link parameters such
+as speed or width.  Most fabrics are somewhat homogeneous in nature.  It is
+intended that this config file be modified with these parameters as global
+settings.
+
+.TP
+\fB\-\-ignore <regex>\fR
+when generating a config skip nodes matching <regex>
+
+.TP
+\fB\-\-missing\fR
+insert place holders for disconnected ports
+
+
+.SH EXIT STATUS
+
+0 on success, -1 on failure.
+
+If check mode is used return 1 if inconsistencies are found, otherwise 0.
+
+.SH FILES
+
+\fBibfabricconf.xml\fR is an XML file which describes all the connections in a
+fabric.  This config file has the following features:
+
+.TP
+Config entry's are "name" based.
+There are no GUID's, LIDs, etc.
+As such misnamed nodes (posibly supplied by the conf file
+"ib-node-name-map" or by miss-programmed node description fields) will show
+up as errors.  The reasoning for this is iblinkinfo is a tool used by
+admins to debug problems in a known network layout.  GUID's can change as
+bad hardware is swapped out.  Therefore a logical view of the fabric
+is much more useful and presented in ibfabricconf.xml
+
+.TP
+Ports which are not specified are assumed to be down.
+Checks during a fabric scan will report active links on those ports as errors.
+
+.TP
+Properties are inherited from parent to child in the XML.
+For example if the entire fabric is to be 4X/QDR then only the fabric XML tag needs to
+be specified as 'speed="QDR" width="4X"'.  However, any link/node
+specification can have properties set which overrides itself and it's
+children.
+
+.TP
+Ports which are listed a second time will over ride the previous entry.
+This is very useful for overriding the internal links of the large
+switches after using the "chassis" tag.  On the other hand caution should
+be used in generating your config files.
+
+.TP
+Common "chassis" configs can be included using the "chassis" tag.
+This makes defining the internal connections of large switches very easy.  Using a
+chassis tag will automatically create all the internal links for
+those switches.  The name of the chassis will be prepended to the
+internal switches found in the chassis.  For example:
+
+<chassis name="ibcore1" model="QLogic_9240"></chassis>
+
+results to the following names:
+
+"ibcore1 SP1a", "ibcore1 SP1b", etc.
+
+"ibcore1 L1a", "ibcore1 L2a", "ibcore1 Leaf 3 Chip A", etc.
+
+Internal switch names can be changed if the names used in the config file
+are not sufficient.
+
+(See @IBDIAG_CONFIG_PATH@/chassis_fabricconfs
+for a list of chassis which have alredy been defined.  Submitions of
+additional chasis config files are always welcome.)
+
+.TP
+A "subfabric" tag allows you to specify the properties for a group of entries.
+
+.SH AUTHOR
+.TP
+Ira Weiny
+.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/src/checkfabric.c b/src/checkfabric.c
new file mode 100644
index 0000000..1aa3003
--- /dev/null
+++ b/src/checkfabric.c
@@ -0,0 +1,822 @@
+/*
+ * Copyright (c) 2011 Lawrence Livermore National Security.  All rights reserved.
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
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <time.h>
+#include <string.h>
+#include <getopt.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <regex.h>
+
+#include <glib.h>
+
+/* global IB headers */
+#include <complib/cl_nodenamemap.h>
+#include <infiniband/ibnetdisc.h>
+#include <infiniband/ibfabricconf.h>
+
+/* local headers */
+#include "ibdiag_common.h"
+#include "checkfabric.h"
+
+typedef struct {
+	uint64_t guid;
+} guid_list_item_t;
+typedef struct {
+	FILE *fp;
+	char *ignore_regex;
+	int print_missing;
+	GSList * visited_nodes; /* list guid_list_item_t */
+	int vn_cnt;
+} print_node_data_t;
+
+/* list of node name strings */
+typedef struct nodelist
+{
+	int cnt;
+	GSList *list;
+} nodelist_t;
+
+/* Globals */
+static nn_map_t *node_name_map;
+static int smlid = 0;
+static ibfc_conf_t *fabricconf = NULL;
+static char *fabricconffile = NULL;
+static nodelist_t *downnodes;
+static char *fabric_name = "fabric";
+static int check_node_rc = 0;
+static int print_port_guids = 0;
+static int print_addr_info = 0;
+
+static struct {
+	int num_ports;
+	int pn_down;
+	int pn_init;
+	int pn_armed;
+	int pn_active;
+	int pn_disabled;
+	int pn_sdr;
+	int pn_ddr;
+	int pn_qdr;
+	int pn_fdr;
+	int pn_edr;
+	int pn_1x;
+	int pn_4x;
+	int pn_8x;
+	int pn_12x;
+	int pn_undef;
+} totals = {
+	num_ports   : 0,
+	pn_down     : 0,
+	pn_init     : 0,
+	pn_armed    : 0,
+	pn_active   : 0,
+	pn_disabled : 0,
+	pn_sdr      : 0,
+	pn_ddr      : 0,
+	pn_qdr      : 0,
+	pn_fdr      : 0,
+	pn_edr      : 0,
+	pn_1x       : 0,
+	pn_4x       : 0,
+	pn_8x       : 0,
+	pn_12x      : 0,
+	pn_undef    : 0
+};
+
+typedef struct port_vis {
+	struct port_vis *next;
+	uint64_t guid;
+	int pnum;
+} port_vis_t;
+
+port_vis_t *vis_head = NULL;
+
+static nodelist_t * nodelist_create(char *downnodes_str)
+{
+	char *last, *tok;
+	char *tmp_str = strdup(downnodes_str);
+	nodelist_t *rc = (nodelist_t *)calloc(1, sizeof(*rc));
+
+	if (!rc)
+		return (NULL);
+
+	tok = strtok_r(tmp_str, ",", &last);
+	while (tok) {
+		gpointer tmp = (gpointer)strdup(tok);
+		rc->list = g_slist_append(rc->list, tmp);
+		rc->cnt++;
+		tok = strtok_r(NULL, ",", &last);
+	}
+
+	free(tmp_str);
+	return (rc);
+}
+
+static void free_node(gpointer elem, gpointer user)
+{
+	free(elem);
+}
+
+static void nodelist_destroy(nodelist_t *nodelist)
+{
+	if (!nodelist)
+		return;
+
+	g_slist_foreach(nodelist->list, free_node, NULL);
+	g_slist_free(nodelist->list);
+	free(nodelist);
+}
+
+static int nodelist_find(nodelist_t *nodelist, char *target)
+{
+	int i = 0;
+	for (i = 0; i < nodelist->cnt; i++) {
+		gpointer t = g_slist_nth_data(nodelist->list, i);
+		if (t && strcmp((const char *)t, (const char *)target) == 0)
+			return (1);
+	}
+
+	return (0);
+}
+
+
+static void mark_port_seen(uint64_t guid, int pnum)
+{
+	port_vis_t *tmp = (port_vis_t *)calloc(1, sizeof *tmp);
+	if (!tmp) {
+		fprintf(stderr, "calloc failure\n");
+		exit(1);
+	}
+	tmp->guid = guid;
+	tmp->pnum = pnum;
+	tmp->next = vis_head;
+	vis_head = tmp;
+}
+
+static int port_seen(uint64_t guid, int pnum)
+{
+	port_vis_t *cur;
+	for (cur = vis_head; cur; cur = cur->next) {
+		if (guid == cur->guid && pnum == cur->pnum)
+			return (1);
+	}
+	return (0);
+}
+
+static void free_seen(void)
+{
+	port_vis_t *cur = vis_head;
+	while (cur) {
+		port_vis_t *tmp = cur;
+		cur = cur->next;
+		free(tmp);
+	}
+}
+
+void
+print_port_stats(void)
+{
+	printf("\nStats Summary: (%d total physical ports)\n", totals.num_ports);
+	if (totals.pn_down)
+		printf("   %d down ports(s)\n", totals.pn_down);
+	if (totals.pn_disabled)
+		printf("   %d disabled ports(s)\n", totals.pn_disabled);
+	if (totals.pn_1x)
+		printf("   %d link(s) at 1X\n", totals.pn_1x);
+	if (totals.pn_4x)
+		printf("   %d link(s) at 4X\n", totals.pn_4x);
+	if (totals.pn_8x)
+		printf("   %d link(s) at 8X\n", totals.pn_8x);
+	if (totals.pn_12x)
+		printf("   %d link(s) at 12X\n", totals.pn_12x);
+	if (totals.pn_sdr)
+		printf("   %d link(s) at 2.5 Gbps (SDR)\n", totals.pn_sdr);
+	if (totals.pn_ddr)
+		printf("   %d link(s) at 5.0 Gbps (DDR)\n", totals.pn_ddr);
+	if (totals.pn_qdr)
+		printf("   %d link(s) at 10.0 Gbps (QDR)\n", totals.pn_qdr);
+	if (totals.pn_fdr)
+		printf("   %d link(s) at 14.0 Gbps (FDR)\n", totals.pn_fdr);
+	if (totals.pn_edr)
+		printf("   %d link(s) at 25.0 Gbps (EDR)\n", totals.pn_edr);
+}
+
+
+static void cf_print_port(char *node_name, ibnd_node_t * node, ibnd_port_t * port,
+		   ibfc_port_t *portconf, int inc_attributes)
+{
+	char width[64], speed[64], state[64], physstate[64];
+	char remote_addr_str[256];
+	char remote_str[256];
+	char link_str[256];
+	char width_msg[256];
+	char speed_msg[256];
+	char ext_port_str[256];
+	int iwidth, ispeed, istate, iphystate;
+	int n = 0;
+
+	if (!port)
+		return;
+
+	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
+	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
+
+	remote_addr_str[0] = '\0';
+	remote_str[0] = '\0';
+	link_str[0] = '\0';
+	width_msg[0] = '\0';
+	speed_msg[0] = '\0';
+
+	if (inc_attributes)
+	{
+		/* C14-24.2.1 states that a down port allows for invalid data to be
+		 * returned for all PortInfo components except PortState and
+		 * PortPhysicalState */
+		if (istate != IB_LINK_DOWN) {
+			n = snprintf(link_str, 256, "(%s %s %6s/%8s)",
+			     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
+					  &iwidth),
+			     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
+					  &ispeed),
+			     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+			     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
+					  &iphystate));
+		} else {
+			n = snprintf(link_str, 256, "(%6s/%8s)",
+			     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+			     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
+					  &iphystate));
+		}
+	}
+
+	if (port->remoteport) {
+		char *remap =
+		    remap_node_name(node_name_map, port->remoteport->node->guid,
+				    port->remoteport->node->nodedesc);
+
+		if (port->remoteport->ext_portnum)
+			snprintf(ext_port_str, 256, "%d",
+				 port->remoteport->ext_portnum);
+		else
+			ext_port_str[0] = '\0';
+
+		get_max_msg(width_msg, speed_msg, 256, port);
+
+		if (print_addr_info) {
+			if (print_port_guids)
+				snprintf(remote_addr_str, 256,
+					" (0x%016" PRIx64 " %d)",
+					port->remoteport->guid,
+					port->remoteport->base_lid ?
+						port->remoteport->base_lid :
+						port->remoteport->node->smalid);
+			else
+				snprintf(remote_addr_str, 256,
+					" (0x%016" PRIx64 " %d)",
+					port->remoteport->node->guid,
+					port->remoteport->base_lid ?
+						port->remoteport->base_lid :
+						port->remoteport->node->smalid);
+		}
+
+		snprintf(remote_str, 256,
+			 "p:%3d[%2s] \"%s\"%s (%s %s)\n",
+			 port->remoteport->portnum, ext_port_str, remap,
+			 remote_addr_str,
+			 width_msg, speed_msg);
+		free(remap);
+	} else if (portconf) {
+		char prop[256];
+		snprintf(remote_str, 256,
+			 "p:%3d \"%s\" (Should be: %s Active)\n",
+				ibfc_port_get_port_num(portconf),
+				ibfc_port_get_name(portconf),
+				ibfc_sprintf_prop(prop, 256, portconf));
+	} else
+		snprintf(remote_str, 256, " [  ] \"\" ( )\n");
+
+	if (port->ext_portnum)
+		snprintf(ext_port_str, 256, "%d", port->ext_portnum);
+	else
+		ext_port_str[0] = '\0';
+
+	if (print_addr_info)
+		printf("(0x%016" PRIx64 " %d) ",
+			print_port_guids ? port->guid : node->guid,
+			port->base_lid ?  port->base_lid : port->node->smalid);
+
+	printf ("\"%s\" ", node_name);
+	if (link_str[0] != '\0')
+		printf("p:%3d[%2s] <==%s==>  %s",
+			port->portnum, ext_port_str, link_str, remote_str);
+	else
+		printf("p:%3d[%2s] <==>  %s",
+			port->portnum, ext_port_str, remote_str);
+}
+
+void
+print_config_port(ibfc_port_t *port)
+{
+	printf ("\"%s\" p:%3d[  ] <==>  ",
+		ibfc_port_get_name(port),
+		ibfc_port_get_port_num(port));
+
+	printf ("p:%3d[  ] ", ibfc_port_get_port_num(ibfc_port_get_remote(port)));
+
+	printf ("\"%s\"\n",
+		ibfc_port_get_name(ibfc_port_get_remote(port)));
+}
+
+void compare_port(ibfc_port_t *portconf, char *node_name, ibnd_node_t *node, ibnd_port_t *port)
+{
+	int iwidth, ispeed, istate, iphysstate;
+
+	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
+	iphysstate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
+
+	ibfc_port_t *rem_portconf = ibfc_port_get_remote(portconf);
+	char *rem_node_name = ibfc_port_get_name(rem_portconf);
+
+	if (istate != IB_LINK_ACTIVE) {
+		int print = 0;
+		int hostdown = 0;
+
+		if (downnodes &&
+		    nodelist_find(downnodes, rem_node_name)) {
+			hostdown = 1;
+		}
+
+		if (iphysstate == IB_PORT_PHYS_STATE_DISABLED) {
+			printf("ERR: port disabled");
+			if (downnodes && !hostdown)
+				printf(" (host UP): ");
+			else
+				printf(": ");
+			print = 1;
+		} else {
+			if (!downnodes || !hostdown) {
+				printf("ERR: port down: ");
+				print = 1;
+			}
+		}
+		if (print) {
+			cf_print_port(node_name, node, port, rem_portconf, 0);
+			check_node_rc = 1;
+		}
+	} else {
+		char str[64];
+		int conf_width = ibfc_prop_get_width(
+					ibfc_port_get_prop(portconf));
+		int conf_speed = ibfc_prop_get_speed(
+					ibfc_port_get_prop(portconf));
+		int rem_port_num = ibfc_port_get_port_num(rem_portconf);
+		char *rem_remap = NULL;
+		ibnd_port_t *remport = port->remoteport;
+
+		if (iwidth != conf_width) {
+			printf("ERR: width != %s: ",
+				mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
+					str, 64, &conf_width));
+			cf_print_port(node_name, node, port, NULL, 1);
+			check_node_rc = 1;
+		}
+		if (ispeed != conf_speed) {
+			printf("ERR: speed != %s: ",
+				mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
+					str, 64, &conf_speed));
+			cf_print_port(node_name, node, port, NULL, 1);
+			check_node_rc = 1;
+		}
+
+		if (remport) {
+			rem_remap = remap_node_name(node_name_map,
+					port->remoteport->node->guid,
+					port->remoteport->node->nodedesc);
+			if (strcmp(rem_node_name, rem_remap) != 0
+			    ||
+			    rem_port_num != port->remoteport->portnum) {
+				printf("ERR: invalid link : ");
+				cf_print_port(node_name, node, port, NULL, 0);
+				printf("     Should be    : ");
+				print_config_port(portconf);
+				check_node_rc = 1;
+			}
+			free(rem_remap);
+		} else {
+			fprintf(stderr, "ERR: query failure: ");
+			cf_print_port(node_name, node, port, rem_portconf, 1);
+			check_node_rc = 1;
+		}
+	}
+}
+
+void check_config(char *node_name, ibnd_node_t *node, ibnd_port_t *port)
+{
+	int istate;
+	ibfc_port_t *portconf = NULL;
+
+	portconf = ibfc_get_port(fabricconf, node_name, port->portnum);
+	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
+	if (portconf) {
+		compare_port(portconf, node_name, node, port);
+	} else if (istate == IB_LINK_ACTIVE) {
+		char *remote_name = NULL;
+		ibnd_node_t *remnode;
+		ibnd_port_t *remport = port->remoteport;
+		if (!remport) {
+			printf("ERROR: ibnd error; port ACTIVE "
+				"but no remote port! (Lights on, "
+				"nobody home?)\n");
+			check_node_rc = 1;
+			goto invalid_active;
+		}
+		remnode = remport->node;
+		remote_name = remap_node_name(node_name_map, remnode->guid,
+					remnode->nodedesc);
+		portconf = ibfc_get_port(fabricconf, remote_name, remport->portnum);
+		if (portconf) {
+			compare_port(portconf, remote_name, remnode, remport);
+		} else {
+invalid_active:
+			printf("ERR: Unconfigured active link: ");
+			cf_print_port(node_name, node, port, NULL, 1);
+			check_node_rc = 1;
+		}
+		free(remote_name); /* OK; may be null */
+	}
+}
+
+void check_port(char *node_name, ibnd_node_t * node, ibnd_port_t * port)
+{
+	int iwidth, ispeed, istate, iphysstate;
+	int n_undef = totals.pn_undef;
+
+	totals.num_ports++;
+
+	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
+	iphysstate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
+
+	switch (istate) {
+		case IB_LINK_DOWN: totals.pn_down++; break;
+		case IB_LINK_INIT: totals.pn_init++; break;
+		case IB_LINK_ARMED: totals.pn_armed++; break;
+		case IB_LINK_ACTIVE: totals.pn_active++; break;
+		default:  totals.pn_undef++; break;
+	}
+
+	switch (iphysstate) {
+		case IB_PORT_PHYS_STATE_DISABLED: totals.pn_disabled++; break;
+		default: break;
+	}
+
+	if (istate == IB_LINK_ACTIVE) {
+		switch (iwidth) {
+			case IB_LINK_WIDTH_ACTIVE_1X: totals.pn_1x++; break;
+			case IB_LINK_WIDTH_ACTIVE_4X: totals.pn_4x++; break;
+			case IB_LINK_WIDTH_ACTIVE_8X: totals.pn_8x++; break;
+			case IB_LINK_WIDTH_ACTIVE_12X: totals.pn_12x++; break;
+			default:  totals.pn_undef++; break;
+		}
+		switch (ispeed) {
+			case IB_LINK_SPEED_ACTIVE_2_5: totals.pn_sdr++; break;
+			case IB_LINK_SPEED_ACTIVE_5: totals.pn_ddr++; break;
+			case IB_LINK_SPEED_ACTIVE_10: totals.pn_qdr++; break;
+			default:  totals.pn_undef++; break;
+		}
+	}
+
+	if (totals.pn_undef > n_undef) {
+		printf("WARN: Undefined value found: ");
+		cf_print_port(node_name, node, port, NULL, 1);
+		check_node_rc = 1;
+	}
+
+	if (fabricconf)
+		check_config(node_name, node, port);
+}
+
+static void check_addrs(ibnd_port_t *port)
+{
+	int checklid = 0;
+	char *remap = NULL;
+
+	if (!port)
+		return;
+
+	if (port->node->type == IB_NODE_SWITCH) {
+		port = port->node->ports[0];
+		if (!port)
+			return;
+	}
+
+	remap = remap_node_name(node_name_map, port->node->guid,
+				    port->node->nodedesc);
+
+	checklid = mad_get_field(port->info, 0, IB_PORT_SMLID_F);
+
+	if (smlid && smlid != checklid) {
+		printf("ERROR smlid %d != %d (expected) on node %s\n", checklid,
+				smlid, remap);
+		check_node_rc = 1;
+	}
+
+	if (!port->base_lid) {
+		printf("ERROR lid == 0 found on node %s\n", remap);
+		check_node_rc = 1;
+	}
+
+	if (!port->guid) {
+		printf("ERROR guid == 0 found on node %s\n", remap);
+		check_node_rc = 1;
+	}
+
+	free(remap);
+}
+
+static void check_node(ibnd_node_t * node, void *user_data)
+{
+	int i = 0;
+	char *remap =
+	    remap_node_name(node_name_map, node->guid, node->nodedesc);
+
+	for (i = 1; i <= node->numports; i++) {
+		ibnd_port_t *port = node->ports[i];
+		if (!port)
+			continue;
+		check_addrs(port);
+		if (!port_seen(node->guid, i)) {
+			check_port(remap, node, port);
+			mark_port_seen(node->guid, i);
+			if (port->remoteport) {
+				mark_port_seen(port->remoteport->node->guid,
+					port->remoteport->portnum);
+				totals.num_ports++;
+			}
+		}
+	}
+	free(remap);
+}
+
+static int ignore_node(char *node_name, char *ignore_regex)
+{
+	static regex_t exp;
+	static int regex_compiled = 0;
+	static int regex_failed = 0;
+
+	if (!ignore_regex)
+		return 0;
+
+	if (!regex_compiled) { /* only compile it one time */
+		int rc;
+		if ((rc = regcomp(&exp, ignore_regex, REG_ICASE |
+				REG_NOSUB | REG_EXTENDED)) != 0) {
+			fprintf(stderr, "ERROR: regcomp failed on \"%s\": %d\n",
+				ignore_regex, rc);
+			regex_failed = 1;
+			return 0;
+		}
+		regex_compiled = 1;
+	}
+
+	return (regexec(&exp, node_name, 0, NULL, 0) == 0);
+}
+
+static void mark_node_seen(print_node_data_t *data, uint64_t node_guid)
+{
+	guid_list_item_t *i = malloc(sizeof(*i));
+	if (i == NULL) {
+		fprintf(stderr, "ERROR: malloc failed\n");
+		return;
+	}
+	i->guid = node_guid;
+	data->visited_nodes = g_slist_append(data->visited_nodes, (gpointer)i);
+	data->vn_cnt++;
+}
+
+static int node_seen(print_node_data_t *data, uint64_t node_guid)
+{
+	int i = 0;
+	for (i = 0; i < data->vn_cnt; i++) {
+		gpointer t = g_slist_nth_data(data->visited_nodes, i);
+		if (((guid_list_item_t *)t)->guid == node_guid)
+			return (1);
+	}
+	return (0);
+}
+
+static void free_visited_nodes(print_node_data_t *data)
+{
+	if (!data->visited_nodes)
+		return;
+
+	g_slist_foreach(data->visited_nodes, free_node, NULL);
+	g_slist_free(data->visited_nodes);
+}
+
+static void print_node_xml(ibnd_node_t *node, void *ud)
+{
+	print_node_data_t *data = (print_node_data_t *)ud;
+	FILE *fp = data->fp;
+
+	int header = 0;
+	int i = 0;
+	char * node_name = remap_node_name(node_name_map,
+					node->guid,
+					node->nodedesc);
+
+	if (ignore_node(node_name, data->ignore_regex))
+		goto ignore;
+
+	for (i = 1; i <= node->numports; i++) {
+		if (node->ports[i] && node->ports[i]->remoteport) {
+			char *rem_name = remap_node_name(node_name_map,
+					node->ports[i]->remoteport->node->guid,
+					node->ports[i]->remoteport->node->nodedesc);
+			if (!ignore_node(rem_name, data->ignore_regex)
+			    && !node_seen(data,
+					node->ports[i]->remoteport->node->guid)) {
+				if (!header) {
+					fprintf(fp, "\t<linklist name=\"%s\">\n", node_name);
+					header = 1;
+				}
+				fprintf(fp, "\t\t<port num=\"%d\">", i);
+				fprintf(fp, "<r_port>%d</r_port>",
+					node->ports[i]->remoteport->portnum);
+				fprintf(fp, "<r_node>%s</r_node>", rem_name);
+				fprintf(fp, "</port>\n");
+			}
+		} else if (data->print_missing) {
+			if (!header) {
+				fprintf(fp, "\t<linklist name=\"%s\">\n", node_name);
+				header = 1;
+			}
+			fprintf(fp, "<!--\n");
+			fprintf(fp, "\t\t<port num=\"%d\">", i);
+			fprintf(fp, "<r_port>XXXXX</r_port>");
+			fprintf(fp, "<r_node>YYYYY</r_node>");
+			fprintf(fp, "</port>\n");
+			fprintf(fp, "-->\n");
+		}
+	}
+	if (header)
+		fprintf(fp, "\t</linklist>\n");
+
+	mark_node_seen(data, node->guid);
+
+ignore:
+	free(node_name);
+}
+
+
+int generate_from_fabric(ibnd_fabric_t *fabric, char *generate_file, nn_map_t *name_map,
+			char *ignore_regex, int print_missing)
+{
+	print_node_data_t data;
+	FILE *fp = fopen(generate_file, "w+");
+	node_name_map = name_map;
+
+	memset(&data, 0, sizeof(data));
+
+	if (!fp) {
+		fprintf(stderr, "Failed to open %s: %s\n", generate_file, strerror(errno));
+		return 1;
+	}
+
+	fprintf(fp, "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n");
+	fprintf(fp, "<!DOCTYPE ibfabric SYSTEM \"ibfabric.dtd\">\n\n");
+	fprintf(fp, "<fabric name=\"%s\">\n", fabric_name);
+
+	data.fp = fp;
+	data.ignore_regex = ignore_regex;
+	data.print_missing = print_missing;
+
+	ibnd_iter_nodes_type(fabric, print_node_xml, IB_NODE_SWITCH, (void *)&data);
+	ibnd_iter_nodes_type(fabric, print_node_xml, IB_NODE_CA, (void *)&data);
+	ibnd_iter_nodes_type(fabric, print_node_xml, IB_NODE_ROUTER, (void *)&data);
+
+	fprintf(fp, "</fabric>\n");
+
+	free_visited_nodes(&data);
+
+	return 0;
+}
+
+int check_links(ib_portid_t *port_id,
+		struct ibmad_port *ibmad_port,
+		ibnd_fabric_t *fabric,
+		nn_map_t *name_map,
+		check_flags_t *flags)
+{
+	int rc = 0;
+	node_name_map = name_map;
+	ibnd_port_t *p = NULL;
+	smlid = flags->sm_lid;
+	print_addr_info = flags->print_addr_info;
+
+	if (flags->downnodes_str)
+		downnodes = nodelist_create(flags->downnodes_str);
+
+	fabricconf = ibfc_alloc_conf();
+	if (!fabricconf) {
+		fprintf(stderr, "ERROR: Failed to alloc fabricconf\n");
+		exit(1);
+	}
+	ibfc_set_warn_dup(fabricconf, 1);
+
+	printf("Reading fabric conf file... ");
+
+	if (ibfc_parse_file(flags->fabricconffile, fabricconf)) {
+		fprintf(stderr, "WARN: Failed to parse link config file...\n");
+		ibfc_free(fabricconf);
+		fabricconf = NULL;
+		check_node_rc = -1;
+	}
+
+	printf("\nEvaluating connectively...\n");
+
+	if (!flags->all && flags->guid_str) {
+		if ((p = ibnd_find_port_guid(fabric, flags->guid)) != NULL) {
+			check_node(p->node, NULL);
+			rc = check_node_rc;
+		} else {
+			fprintf(stderr, "Failed to find port: %s\n",
+				flags->guid_str);
+			rc = -1;
+		}
+	} else if (!flags->all && flags->dr_path) {
+		uint64_t guid;
+		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
+
+		if (!smp_query_via(ni, port_id, IB_ATTR_NODE_INFO, 0,
+				   ibd_timeout, ibmad_port)){
+			rc = -1;
+			goto Exit;
+		}
+		mad_decode_field(ni, IB_NODE_GUID_F, &guid);
+
+		if ((p = ibnd_find_port_guid(fabric, guid)) != NULL) {
+			check_node(p->node, NULL);
+			rc = check_node_rc;
+		} else {
+			fprintf(stderr, "Failed to find node: %s\n",
+				flags->dr_path);
+			rc = -1;
+		}
+	} else {
+		ibnd_iter_nodes(fabric, check_node, NULL);
+		rc = check_node_rc;
+	}
+	print_port_stats();
+
+Exit:
+	nodelist_destroy(downnodes);
+	free_seen();
+	return rc;
+}
+
diff --git a/src/checkfabric.h b/src/checkfabric.h
new file mode 100644
index 0000000..bffa876
--- /dev/null
+++ b/src/checkfabric.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2011 Lawrence Livermore National Security.  All rights reserved.
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
+#ifndef __CHECK_FABRIC_H_
+#define __CHECK_FABRIC_H_
+
+/* check flags */
+typedef struct {
+	int all;
+	char *guid_str;
+	uint64_t guid;
+	char *dr_path;
+	char *downnodes_str;
+	char *fabricconffile;
+	uint16_t sm_lid;
+	int print_addr_info;
+} check_flags_t;
+
+int generate_from_fabric(ibnd_fabric_t *fabric, char *generate_file,
+			nn_map_t *name_map, char *ignore_regex,
+			int print_missing);
+
+int check_links(ib_portid_t *port_id,
+		struct ibmad_port *ibmad_port,
+		ibnd_fabric_t *fabric,
+		nn_map_t *name_map,
+		check_flags_t *flags);
+
+#endif /* __CHECK_FABRIC_H_ */
+
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 00c7bc0..d23102a 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -48,6 +48,7 @@
 #include <getopt.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <limits.h>
 
 #include <complib/cl_nodenamemap.h>
 #include <infiniband/ibnetdisc.h>
@@ -61,8 +62,9 @@
 
 #define DIFF_FLAG_DEFAULT (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE)
 
+nn_map_t *node_name_map = NULL;
+
 static char *node_name_map_file = NULL;
-static nn_map_t *node_name_map = NULL;
 static char *load_cache_file = NULL;
 static char *diff_cache_file = NULL;
 static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
@@ -80,6 +82,18 @@ static int add_sw_settings = 0;
 static int only_flag = 0;
 static int only_type = 0;
 
+#ifdef HAVE_XML
+#include <infiniband/ibfabricconf.h>
+#include "checkfabric.h"
+
+static int check_mode = 0;
+static char *generate_config = NULL;
+static char *ignore_regex = NULL;
+static int print_missing = 0;
+
+check_flags_t check_flags;
+#endif
+
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
 {
 	ibnd_node_t *fsw;
@@ -488,6 +502,57 @@ int diff_node(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	return 0;
 }
 
+static int print_links(ib_portid_t *port_id,
+		       struct ibmad_port *ibmad_port,
+		       ibnd_fabric_t *fabric,
+		       ibnd_fabric_t *diff_fabric)
+{
+	int rc = 0;
+
+	if (!all && guid_str) {
+		ibnd_port_t *p = ibnd_find_port_guid(fabric, guid);
+		if (p && (!only_flag || p->node->type == only_type)) {
+			ibnd_node_t *n = p->node;
+			if (diff_fabric)
+				diff_node(n, diff_fabric, fabric);
+			else
+				print_node(n, NULL);
+		}
+		else
+			fprintf(stderr, "Failed to find port: %s\n", guid_str);
+	} else if (!all && dr_path) {
+		ibnd_port_t *p = NULL;
+		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
+
+		if (!smp_query_via(ni, port_id, IB_ATTR_NODE_INFO, 0,
+				   ibd_timeout, ibmad_port))
+			return -1;
+		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
+
+		p = ibnd_find_port_guid(fabric, guid);
+		if (p && (!only_flag || p->node->type == only_type)) {
+			ibnd_node_t *n = p->node;
+			if (diff_fabric)
+				diff_node(n, diff_fabric, fabric);
+			else
+				print_node(n, NULL);
+		}
+		else
+			fprintf(stderr, "Failed to find port: %s\n", dr_path);
+	} else {
+		if (diff_fabric)
+			diff_node(NULL, diff_fabric, fabric);
+		else {
+			if (only_flag)
+				ibnd_iter_nodes_type(fabric, print_node,
+						     only_type, NULL);
+			else
+				ibnd_iter_nodes(fabric, print_node, NULL);
+		}
+	}
+	return rc;
+}
+
 static int process_opt(void *context, int ch, char *optarg)
 {
 	struct ibnd_config *cfg = context;
@@ -534,6 +599,32 @@ static int process_opt(void *context, int ch, char *optarg)
 		only_flag = 1;
 		only_type = IB_NODE_CA;
 		break;
+#ifdef HAVE_XML
+	case 'c': /* check */
+		check_mode = 1;
+		break;
+	case 8: /* config */
+		check_flags.fabricconffile = strdup(optarg);
+		break;
+	case 9: /* downnodes */
+		check_flags.downnodes_str = strdup(optarg);
+		break;
+	case 10: /* smlid */
+		check_flags.sm_lid = (uint16_t)strtoul(optarg, NULL, 0);
+		break;
+	case 11: /* addr-info */
+		check_flags.print_addr_info = 1;
+		break;
+	case 12: /* generate-config */
+		generate_config = strdup(optarg);
+		break;
+	case 13: /* ignore */
+		ignore_regex = strdup(optarg);
+		break;
+	case 14: /* missing */
+		print_missing = 1;
+		break;
+#endif /* HAVE_XML */
 	case 'S':
 	case 'G':
 		guid_str = optarg;
@@ -613,8 +704,30 @@ int main(int argc, char **argv)
 		 "Output only switches"},
 		{"cas-only", 7, 0, NULL,
 		 "Output only CAs"},
+#ifdef HAVE_XML
+		{"\nCheck Fabric options:\n", 255, 0, NULL, ""}, /* dummy option */
+		{"check", 'c', 0, NULL,
+		 "check fabric; against ibfabricconf.xml"},
+		{"config", 8, 1, "<ibfabricconf>",
+		 "with '-c': specify an alternate config file default: "IBFC_DEF_CONFIG},
+		{"downnodes", 9, 1, "<nodelist>",
+		 "with '-c': specify nodes which are known to be off.  "
+		 "Suppreses \"down port\" errors on links connected to those nodes"},
+		{"smlid", 10, 1, "<smlid>",
+		 "with '-c': specify an smlid to verify on all active ports\n"},
+		{"addr-info", 11, 0, "",
+		 "with '-c': print node/port GUID and LID information \n"},
+
+		{"generate-config", 12, 1, "<config>",
+		 "generate a config file"},
+		{"ignore", 13, 1, "<regex>",
+		 "with '--generate-config': skip nodes matching regex"},
+		{"missing", 14, 0, NULL,
+		 "with '--generate-config': insert place holders for dissconnected ports\n"},
+#endif
 		{"GNDN", 'R', 0, NULL,
-		 "(This option is obsolete and does nothing)"},
+		 "(This option is obsolete and does nothing)\n"
+		"Common Options:\n"},
 		{0}
 	};
 	char usage_args[] = "";
@@ -629,7 +742,7 @@ int main(int argc, char **argv)
 	if (!ibmad_port) {
 		fprintf(stderr, "Failed to open %s port %d\n", ibd_ca,
 			ibd_ca_port);
-		exit(1);
+		exit(-1);
 	}
 
 	if (ibd_timeout) {
@@ -641,7 +754,7 @@ int main(int argc, char **argv)
 
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
-		exit(1);
+		exit(-1);
 	}
 
 	if (dr_path) {
@@ -671,7 +784,7 @@ int main(int argc, char **argv)
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
 			fprintf(stderr, "loading cached fabric failed\n");
-			exit(1);
+			exit(-1);
 		}
 	} else {
 		if (resolved >= 0) {
@@ -686,52 +799,25 @@ int main(int argc, char **argv)
 		if (!fabric &&
 		    !(fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL, &config))) {
 			fprintf(stderr, "discover failed\n");
-			rc = 1;
+			rc = -1;
 			goto close_port;
 		}
 	}
 
-	if (!all && guid_str) {
-		ibnd_port_t *p = ibnd_find_port_guid(fabric, guid);
-		if (p && (!only_flag || p->node->type == only_type)) {
-			ibnd_node_t *n = p->node;
-			if (diff_fabric)
-				diff_node(n, diff_fabric, fabric);
-			else
-				print_node(n, NULL);
-		}
-		else
-			fprintf(stderr, "Failed to find port: %s\n", guid_str);
-	} else if (!all && dr_path) {
-		ibnd_port_t *p = NULL;
-		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
-
-		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
-				   ibd_timeout, ibmad_port))
-			return -1;
-		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
-
-		p = ibnd_find_port_guid(fabric, guid);
-		if (p && (!only_flag || p->node->type == only_type)) {
-			ibnd_node_t *n = p->node;
-			if (diff_fabric)
-				diff_node(n, diff_fabric, fabric);
-			else
-				print_node(n, NULL);
-		}
-		else
-			fprintf(stderr, "Failed to find port: %s\n", dr_path);
-	} else {
-		if (diff_fabric)
-			diff_node(NULL, diff_fabric, fabric);
-		else {
-			if (only_flag)
-				ibnd_iter_nodes_type(fabric, print_node,
-						     only_type, NULL);
-			else
-				ibnd_iter_nodes(fabric, print_node, NULL);
-		}
-	}
+#ifdef HAVE_XML
+	if (generate_config)
+		rc = generate_from_fabric(fabric, generate_config, node_name_map,
+					ignore_regex, print_missing);
+	else if (check_mode) {
+		check_flags.all = all;
+		check_flags.guid_str = guid_str;
+		check_flags.guid = guid;
+		check_flags.dr_path = dr_path;
+		rc = check_links(&port_id, ibmad_port, fabric, node_name_map,
+				&check_flags);
+	} else
+#endif
+		rc = print_links(&port_id, ibmad_port, fabric, diff_fabric);
 
 	ibnd_destroy_fabric(fabric);
 	if (diff_fabric)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
