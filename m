From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/5] infiniband-diags: ibqueryerrors add "check"
 capabilities against ibfabricconf file
Date: Mon, 21 Nov 2011 16:03:03 -0800
Message-ID: <20111121160303.7ce69618.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am            |   11 ++++++---
 man/ibqueryerrors.8.in |   29 ++++++++++++++++++++++++-
 src/ibqueryerrors.c    |   55 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 4aaa41a..b738806 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,11 +64,7 @@ src_saquery_SOURCES = src/saquery.c
 src_ibsendtrap_SOURCES = src/ibsendtrap.c
 src_vendstat_SOURCES = src/vendstat.c
 src_mcm_rereg_test_SOURCES = src/mcm_rereg_test.c
-src_iblinkinfo_SOURCES = src/iblinkinfo.c
-src_iblinkinfo_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 src_ibccquery_SOURCES = src/ibccquery.c
-src_ibqueryerrors_SOURCES = src/ibqueryerrors.c
-src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 src_ibcacheedit_SOURCES = src/ibcacheedit.c
 src_ibcacheedit_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 
@@ -78,9 +74,16 @@ src_iblinkinfo_CFLAGS = $(GLIB_CFLAGS)
 src_iblinkinfo_LDFLAGS = -losmcomp -libmad \
 	-L$(top_builddir)/libibnetdisc -libnetdisc \
 	-L$(top_builddir)/libibfabricconf -libfabricconf $(GLIB_LIBS)
+src_ibqueryerrors_SOURCES = src/ibqueryerrors.c src/checkfabric.c src/checkfabric.h
+src_ibqueryerrors_CFLAGS = $(GLIB_CFLAGS)
+src_ibqueryerrors_LDFLAGS = -losmcomp -libmad \
+	-L$(top_builddir)/libibnetdisc -libnetdisc \
+	-L$(top_builddir)/libibfabricconf -libfabricconf $(GLIB_LIBS)
 else
 src_iblinkinfo_SOURCES = src/iblinkinfo.c
 src_iblinkinfo_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
+src_ibqueryerrors_SOURCES = src/ibqueryerrors.c
+src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 endif
 
 man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
index 372b0e4..bb5dd15 100644
--- a/man/ibqueryerrors.8.in
+++ b/man/ibqueryerrors.8.in
@@ -75,6 +75,33 @@ for information on caching ibnetdiscover output.
 .TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
+.SH CHECK OPTIONS
+.TP
+"Check" options apply only when XML support was enabled for the build.
+
+.TP
+\fB\-check, \-f\fR
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
 .SH COMMON OPTIONS
 .PP
 \-d      raise the IB debugging level.
@@ -101,7 +128,7 @@ for information on caching ibnetdiscover output.
 
 If a failure to scan the fabric occurs return -1.  If the scan succeeds without
 errors beyond thresholds return 0.  If errors are found on ports beyond
-thresholds return 1.
+thresholds or if check mode is used and inconsistencies are found, return 1.
 
 .SH FILES
 
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index e070baf..1ea123c 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -73,6 +73,14 @@ char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
 unsigned clear_errors = 0, clear_counts = 0, details = 0;
 
+#ifdef HAVE_XML
+#include <infiniband/ibfabricconf.h>
+#include "checkfabric.h"
+
+static int check_mode = 0;
+check_flags_t check_flags;
+#endif
+
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
 #define PRINT_ROUTER 0x4
@@ -822,6 +830,23 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 9:
 		data_counters_only = 1;
 		break;
+#ifdef HAVE_XML
+	case 'f': /* check */
+		check_mode = 1;
+		break;
+	case 10: /* config */
+		check_flags.fabricconffile = strdup(optarg);
+		break;
+	case 11: /* downnodes */
+		check_flags.downnodes_str = strdup(optarg);
+		break;
+	case 12: /* smlid */
+		check_flags.sm_lid = (uint16_t)strtoul(optarg, NULL, 0);
+		break;
+	case 13: /* addr-info */
+		check_flags.print_addr_info = 1;
+		break;
+#endif /* HAVE_XML */
 	case 'G':
 	case 'S':
 		port_guid_str = optarg;
@@ -879,8 +904,6 @@ int main(int argc, char **argv)
 		 "report port link information"},
 		{"threshold-file", 8, 1, NULL,
 		 "specify an alternate threshold file, default: " DEF_THRES_FILE},
-		{"GNDN", 'R', 0, NULL,
-		 "(This option is obsolete and does nothing)"},
 		{"data", 2, 0, NULL, "include data counters for ports with errors"},
 		{"switch", 3, 0, NULL, "print data for switches only"},
 		{"ca", 4, 0, NULL, "print data for CA's only"},
@@ -896,6 +919,23 @@ int main(int argc, char **argv)
 		{"outstanding_smps", 'o', 1, NULL,
 		 "specify the number of outstanding SMP's which should be "
 		 "issued during the scan"},
+#ifdef HAVE_XML
+		{"\nCheck Fabric options:\n", 255, 0, NULL, ""}, /* dummy option */
+		{"check", 'f', 0, NULL,
+		 "check fabric; against ibfabricconf.xml"},
+		{"config", 10, 1, "<ibfabricconf>",
+		 "with '-f': specify an alternate config file default: "IBFC_DEF_CONFIG},
+		{"downnodes", 11, 1, "<nodelist>",
+		 "with '-f': specify nodes which are known to be off.  "
+		 "Suppreses \"down port\" errors on links connected to those nodes"},
+		{"smlid", 12, 1, "<smlid>",
+		 "with '-f': specify an smlid to verify on all active ports\n"},
+		{"addr-info", 13, 0, "",
+		 "with '-f': print node/port GUID and LID information \n"},
+#endif /* HAVE_XML */
+		{"GNDN", 'R', 0, NULL,
+		 "(This option is obsolete and does nothing)\n"
+		"Common Options:\n"},
 		{0}
 	};
 	char usage_args[] = "";
@@ -996,6 +1036,17 @@ int main(int argc, char **argv)
 		ibnd_iter_nodes(fabric, print_node, NULL);
 
 	rc = print_summary();
+#ifdef HAVE_XML
+	if (check_mode) {
+		printf("\n");
+		check_flags.all = 0;
+		check_flags.guid_str = port_guid_str;
+		check_flags.guid = port_guid;
+		check_flags.dr_path = dr_path;
+		rc |= check_links(&portid, ibmad_port, fabric, node_name_map,
+				&check_flags);
+	}
+#endif /* HAVE_XML */
 	if (rc)
 		rc = 1;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
