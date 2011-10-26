From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: add a general config file
Date: Wed, 26 Oct 2011 14:30:16 -0700
Message-ID: <20111026143016.80253d50.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



This supports the common options for CA, Port, and timeout.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am               |    1 +
 configure.in              |    1 +
 etc/ibdiag.conf           |   13 +++
 man/infiniband-diags.8    |  198 -------------------------------------------
 man/infiniband-diags.8.in |  205 +++++++++++++++++++++++++++++++++++++++++++++
 src/ibdiag_common.c       |   55 +++++++++++-
 6 files changed, 271 insertions(+), 202 deletions(-)
 create mode 100644 etc/ibdiag.conf
 delete mode 100644 man/infiniband-diags.8
 create mode 100644 man/infiniband-diags.8.in

diff --git a/Makefile.am b/Makefile.am
index ea85280..b793fb4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -110,3 +110,4 @@ install-data-hook:
 	fi
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
+	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
diff --git a/configure.in b/configure.in
index 41e3f53..0237c99 100644
--- a/configure.in
+++ b/configure.in
@@ -179,6 +179,7 @@ AC_CONFIG_FILES([\
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
 	man/ibqueryerrors.8 \
+	man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
new file mode 100644
index 0000000..1668a90
--- /dev/null
+++ b/etc/ibdiag.conf
@@ -0,0 +1,13 @@
+# Define different defaults for all infiniband-diag tools.  These can be
+# defined on the command line but this offers a more global config.
+
+# Defaults are to find the first port with Physical state == "LinkUp"
+#CA=mlx4_0
+
+# NOTE: that using a different Port may require an altered DR path.
+#       for example -D 0,1 will not work with port 2
+#Port=1
+
+# define a different default timeout
+#timeout=50
+
diff --git a/man/infiniband-diags.8 b/man/infiniband-diags.8
deleted file mode 100644
index 26bc98c..0000000
--- a/man/infiniband-diags.8
+++ /dev/null
@@ -1,198 +0,0 @@
-.TH INFINIBAND-DIAGS 8 "Aug 15, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH SYNOPSIS
-.B infiniband-diags
-
-.SH DESCRIPTION
-.PP
-infiniband-diags is a set of utilities designed to help configure, debug, and
-maintain infiniband fabrics.  Many tools and utilities are provided.  Some with
-similar functionality.
-
-The base utilities use directed route MAD's to perform their operations.  They
-may therefore work even in unconfigured subnets.  Other, higher level
-utilities, require LID routed MAD's and to some extent SA/SM access.
-
-Multiple port/Multiple CA support: when no IB device or port is specified
-(see the "local umad parameters" below), the libibumad library
-selects the port to use by the following criteria:
-
-	1. the first port that is ACTIVE.
-.br
-	2. if not found, the first port that is UP (physical link up).
-.br
-
-.br
-	If a port and/or CA name is specified, the libibumad library attempts to fulfill the user request, and will fail if it is not possible.
-.br
-
-.br
-	For example:
-.br
-	ibaddr 			# use the 'best port'
-.br
-	ibaddr -C mthca1	# pick the best port from mthca1 only.
-.br
-	ibaddr -P 2		# use the second (active/up) port from the first available IB device.
-.br
-	ibaddr -C mthca0 -P 2	# use the specified port only.
-
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using "<util_name> -h".
-
-.TP
-\fB# Addressing Flags\fR
-.PP
-\-D      use the directed route specified.
-.br
-		Examples:
-.br
-		"0" 		# self port
-.br
-		"0,1,2,1,4"	# out via port 1, then 2, ...
-
-.PP
-\-G <guid>     use the PortGuid specified.
-.PP
-\-s <smlid>     use 'smlid' as the target lid for SA queries.
-
-.TP
-\fB# Local HCA/port flags:\fR
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-
-.TP
-\fB# Debugging flags\fR
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-.SH NODE NAME MAP FILE FORMAT
-Most utilities use the optional node name map file supported by libosmcomp to
-specify user friendly names for nodes in the output.  Node GUIDs are used to
-perform the lookup.
-
-.TP
-\fBGenerically:\fR
-
-# comment
-.br
-<guid> "<name>"
-
-.TP
-\fBExample:\fR
-
-# IB1
-.br
-# Line cards
-.br
-0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-.br
-# Spines
-.br
-0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-.br
-# GUID   Node Name
-.br
-0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-
-.SH Utilities list
-
-.TP
-\fBBasic fabric conectivity\fR
-
-	See: ibnetdiscover, iblinkinfo, ibidsverify
-
-.TP
-\fBNode information\fR
-
-	See: ibnodes, ibswitches, ibhosts, ibrouters
-
-.TP
-\fBPort information\fR
-
-	See: ibportstate, ibaddr
-
-.TP
-\fBSwitch Forwarding Table info\fR
-
-	See: ibtracert, ibroute, dump_lfts, dump_mfts, check_lft_balance, ibfindnodesusing
-
-.TP
-\fBPeformance counters\fR
-
-	See: ibqueryerrors, perfquery
-
-.TP
-\fBLocal HCA info\fR
-
-	See: ibstat, ibstatus,
-
-.TP
-\fBConnectivity check\fR
-
-	See: ibping, ibsysstat
-
-.TP
-\fBLow level query tools\fR
-
-	See: smpquery, smpdump, saquery, sminfo
-
-
-.SH Backwards compatibility scripts
-
-The following scripts have been identified as redundant and/or lower performing
-as compared to the above scripts.  They are provided as legacy scripts.
-
-ibcheckerrors, ibclearcounters, ibclearerrors, ibdatacounters
-ibchecknet, ibchecknode, ibcheckport, ibcheckportstate,
-ibcheckportwidth, ibcheckstate, ibcheckwidth, ibswportwatch,
-ibprintca, ibprintrt, ibprintswitch
-
-
-.SH AUTHORS
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
new file mode 100644
index 0000000..80773cd
--- /dev/null
+++ b/man/infiniband-diags.8.in
@@ -0,0 +1,205 @@
+.TH INFINIBAND-DIAGS 8 "Aug 15, 2011" "OpenIB" "OpenIB Diagnostics"
+
+.SH SYNOPSIS
+.B infiniband-diags
+
+.SH DESCRIPTION
+.PP
+infiniband-diags is a set of utilities designed to help configure, debug, and
+maintain infiniband fabrics.  Many tools and utilities are provided.  Some with
+similar functionality.
+
+The base utilities use directed route MAD's to perform their operations.  They
+may therefore work even in unconfigured subnets.  Other, higher level
+utilities, require LID routed MAD's and to some extent SA/SM access.
+
+Multiple port/Multiple CA support: when no IB device or port is specified
+(see the "local umad parameters" below), the libibumad library
+selects the port to use by the following criteria:
+
+	1. the first port that is ACTIVE.
+.br
+	2. if not found, the first port that is UP (physical link up).
+.br
+
+.br
+	If a port and/or CA name is specified, the libibumad library attempts to fulfill the user request, and will fail if it is not possible.
+.br
+
+.br
+	For example:
+.br
+	ibaddr 			# use the 'best port'
+.br
+	ibaddr -C mthca1	# pick the best port from mthca1 only.
+.br
+	ibaddr -P 2		# use the second (active/up) port from the first available IB device.
+.br
+	ibaddr -C mthca0 -P 2	# use the specified port only.
+
+
+.SH COMMON OPTIONS
+
+Most OpenIB diagnostics take the following common flags. The exact list of
+supported flags per utility can be found in the usage message and can be shown
+using "<util_name> -h".
+
+.TP
+\fB# Addressing Flags\fR
+.PP
+\-D      use the directed route specified.
+.br
+		Examples:
+.br
+		"0" 		# self port
+.br
+		"0,1,2,1,4"	# out via port 1, then 2, ...
+
+.PP
+\-G <guid>     use the PortGuid specified.
+.PP
+\-s <smlid>     use 'smlid' as the target lid for SA queries.
+
+.TP
+\fB# Local HCA/port flags:\fR
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+
+.TP
+\fB# Debugging flags\fR
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
+.PP
+\-d      raise the IB debugging level.
+        May be used several times (-ddd or -d -d -d).
+.PP
+\-e      show send and receive errors (timeouts and others)
+.PP
+\-h      show the usage message
+.PP
+\-v      increase the application verbosity level.
+        May be used several times (-vv or -v -v -v)
+.PP
+\-V      show the version info.
+
+.SH FILES
+
+@IBDIAG_CONFIG_PATH@/ibdiag.conf
+
+A global config file is provided to set some of the common options for all
+tools.
+
+.SH NODE NAME MAP FILE FORMAT
+Most utilities use the optional node name map file supported by libosmcomp to
+specify user friendly names for nodes in the output.  Node GUIDs are used to
+perform the lookup.
+
+.TP
+\fBGenerically:\fR
+
+# comment
+.br
+<guid> "<name>"
+
+.TP
+\fBExample:\fR
+
+# IB1
+.br
+# Line cards
+.br
+0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
+.br
+0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
+.br
+0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
+.br
+0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
+.br
+0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB-24D"
+.br
+.br
+# Spines
+.br
+0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+.br
+0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+.br
+0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+.br
+0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
+.br
+0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
+.br
+.br
+# GUID   Node Name
+.br
+0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
+.br
+0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
+.br
+0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
+.br
+0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
+.br
+
+.SH Utilities list
+
+.TP
+\fBBasic fabric conectivity\fR
+
+	See: ibnetdiscover, iblinkinfo, ibidsverify
+
+.TP
+\fBNode information\fR
+
+	See: ibnodes, ibswitches, ibhosts, ibrouters
+
+.TP
+\fBPort information\fR
+
+	See: ibportstate, ibaddr
+
+.TP
+\fBSwitch Forwarding Table info\fR
+
+	See: ibtracert, ibroute, dump_lfts, dump_mfts, check_lft_balance, ibfindnodesusing
+
+.TP
+\fBPeformance counters\fR
+
+	See: ibqueryerrors, perfquery
+
+.TP
+\fBLocal HCA info\fR
+
+	See: ibstat, ibstatus,
+
+.TP
+\fBConnectivity check\fR
+
+	See: ibping, ibsysstat
+
+.TP
+\fBLow level query tools\fR
+
+	See: smpquery, smpdump, saquery, sminfo
+
+
+.SH Backwards compatibility scripts
+
+The following scripts have been identified as redundant and/or lower performing
+as compared to the above scripts.  They are provided as legacy scripts.
+
+ibcheckerrors, ibclearcounters, ibclearerrors, ibdatacounters
+ibchecknet, ibchecknode, ibcheckport, ibcheckportstate,
+ibcheckportwidth, ibcheckstate, ibcheckwidth, ibswportwatch,
+ibprintca, ibprintrt, ibprintswitch
+
+
+.SH AUTHORS
+.TP
+Ira Weiny
+.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 049b72b..81d7878 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -52,6 +52,7 @@
 #include <config.h>
 #include <getopt.h>
 #include <limits.h>
+#include <sys/stat.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -59,14 +60,18 @@
 #include <ibdiag_version.h>
 
 int ibverbose;
-char *ibd_ca;
-int ibd_ca_port;
 enum MAD_DEST ibd_dest_type = IB_DEST_LID;
 ib_portid_t *ibd_sm_id;
-int ibd_timeout;
-
 static ib_portid_t sm_portid = { 0 };
 
+/* general config options */
+#define IBDIAG_CONFIG_GENERAL IBDIAG_CONFIG_PATH"/ibdiag.conf"
+static char *ibdiag_config_general = IBDIAG_CONFIG_GENERAL;
+char *ibd_ca = NULL;
+int ibd_ca_port = 0;
+int ibd_timeout = 0;
+
+
 static const char *prog_name;
 static const char *prog_args;
 static const char **prog_examples;
@@ -281,6 +286,46 @@ static void make_str_opts(const struct option *o, char *p, unsigned size)
 	p[n] = '\0';
 }
 
+void read_ibdiag_config(void)
+{
+	char buf[1024];
+	FILE *config_fd = NULL;
+	char *p_prefix, *p_last;
+	char *name;
+	char *val_str;
+	struct stat statbuf;
+
+	/* silently ignore missing config file */
+	if (stat(ibdiag_config_general, &statbuf))
+		return;
+
+	config_fd = fopen(ibdiag_config_general, "r");
+	if (!config_fd)
+		return;
+
+	while (fgets(buf, sizeof buf, config_fd) != NULL) {
+		p_prefix = strtok_r(buf, "\n", &p_last);
+		if (!p_prefix)
+			continue; /* ignore blank lines */
+
+		if (*p_prefix == '#')
+			continue; /* ignore comment lines */
+
+		name = strtok_r(p_prefix, "=", &p_last);
+		val_str = strtok_r(NULL, "\n", &p_last);
+
+		if (strncmp(name, "CA", strlen("CA")) == 0) {
+			ibd_ca = strdup(val_str);
+		} else if (strncmp(name, "Port", strlen("Port")) == 0) {
+			ibd_ca_port = strtoul(val_str, NULL, 0);
+		} else if (strncmp(name, "timeout", strlen("timeout")) == 0) {
+			ibd_timeout = strtoul(val_str, NULL, 0);
+		}
+	}
+
+	fclose(config_fd);
+}
+
 int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 			const char *exclude_common_str,
 			const struct ibdiag_opt custom_opts[],
@@ -299,6 +344,8 @@ int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 	if (!long_opts)
 		return -1;
 
+	read_ibdiag_config();
+
 	make_str_opts(long_opts, str_opts, sizeof(str_opts));
 
 	while (1) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
