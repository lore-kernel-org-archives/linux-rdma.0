From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 01/5] infiniband-diags: ibqueryerrors; add error thresholds
Date: Wed, 27 Apr 2011 18:46:47 -0700
Message-ID: <20110427184647.21203c00.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 27 Apr 2011 10:43:01 -0700
Subject: [PATCH 01/5] infiniband-diags: ibqueryerrors; add error thresholds

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am            |    3 +-
 configure.in           |   10 ++++-
 etc/error_thresholds   |   16 ++++++
 man/ibqueryerrors.8    |   99 ---------------------------------------
 man/ibqueryerrors.8.in |  120 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/ibqueryerrors.c    |  106 +++++++++++++++++++++++++++++++++++-------
 6 files changed, 235 insertions(+), 119 deletions(-)
 create mode 100644 etc/error_thresholds
 delete mode 100644 man/ibqueryerrors.8
 create mode 100644 man/ibqueryerrors.8.in

diff --git a/Makefile.am b/Makefile.am
index f9286a9..4b08635 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -94,7 +94,7 @@ ibdiag_version:
 	fi
 
 EXTRA_DIST = scripts include infiniband-diags.spec.in infiniband-diags.spec \
-	$(man_MANS) autogen.sh
+	$(man_MANS) autogen.sh etc/error_thresholds
 
 dist-hook:
 	if [ -x $(top_srcdir)/gen_chlog.sh ] ; then \
@@ -104,3 +104,4 @@ dist-hook:
 # install this to a default location.
 install-data-hook:
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
+	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
diff --git a/configure.in b/configure.in
index 8461a37..350a11e 100644
--- a/configure.in
+++ b/configure.in
@@ -71,6 +71,13 @@ AC_CHECK_FUNCS([strchr strrchr strtol strtoul memset strtoull])
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 
+dnl Define a configure directory
+IBDIAG_CONFIG_PATH_TMP1="`eval echo ${sysconfdir}`"
+IBDIAG_CONFIG_PATH_TMP2="`echo $IBDIAG_CONFIG_PATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`"
+IBDIAG_CONFIG_PATH="`eval echo $IBDIAG_CONFIG_PATH_TMP2`/infiniband-diags"
+AC_SUBST(IBDIAG_CONFIG_PATH)
+AC_DEFINE_UNQUOTED([IBDIAG_CONFIG_PATH], "$IBDIAG_CONFIG_PATH", [Define the path to configuratios])
+
 dnl Check if we should include test utilities
 AC_MSG_CHECKING(for --enable-test-utils)
 AC_ARG_ENABLE(test-utils,
@@ -176,6 +183,7 @@ AC_CONFIG_FILES([\
 	scripts/ibrouters \
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
-   libibnetdisc/Makefile
+	man/ibqueryerrors.8 \
+	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
diff --git a/etc/error_thresholds b/etc/error_thresholds
new file mode 100644
index 0000000..28cd295
--- /dev/null
+++ b/etc/error_thresholds
@@ -0,0 +1,16 @@
+# Define error thresholds here
+
+#SymbolErrorCounter=10
+#LinkErrorRecoveryCounter=10
+#LinkDownedCounter=10
+#PortRcvErrors=10
+#PortRcvRemotePhysicalErrors=100
+#PortRcvSwitchRelayErrors=100
+#PortXmitDiscards=100
+#PortXmitConstraintErrors=100
+#PortRcvConstraintErrors=100
+#LocalLinkIntegrityErrors=10
+#ExcessiveBufferOverrunErrors=10
+#VL15Dropped=100
+#PortXmitWait=1000
+
diff --git a/man/ibqueryerrors.8 b/man/ibqueryerrors.8
deleted file mode 100644
index a7af20a..0000000
--- a/man/ibqueryerrors.8
+++ /dev/null
@@ -1,99 +0,0 @@
-.TH IBQUERYERRORS 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibqueryerrors \- query and report non-zero IB port counters
-
-.SH SYNOPSIS
-.B ibqueryerrors
-[-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -G <node_guid>
--D <direct_route> -d -k -K \-\-load\-cache <filename>]
-
-.SH DESCRIPTION
-.PP
-ibqueryerrors reports port counters.  This is similar to ibcheckerrors with
-the additional ability to filter out selected errors, include the optional
-transmit and receive data counters, and report full link information for the
-link reported.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-s <err1,err2,...>\fR
-Suppress the errors listed in the comma separated list provided.
-.TP
-\fB\-c\fR
-Suppress some of the common "side effect" counters.  These counters usually do
-not indicate an error condition and can be usually be safely ignored.
-.TP
-\fB\-G <node_guid>\fR
-Report results only for the node guid specified.
-.TP
-\fB\-S <node_guid>\fR
-\-S is provided only for backward compatibility and works the same as "-G"
-.TP
-\fB\-D <direct_route>\fR
-Report results only for the switch specified by the direct route path.
-.TP
-\fB\-r\fR
-Report the port information.  This includes LID, port, external port (if
-applicable), link speed setting, remote GUID, remote port, remote external port
-(if applicable), and remote node description information.
-.TP
-\fB\-\-data\fR
-Include the optional transmit and receive data counters.
-.TP
-\fB\-\-switch\fR  print data for switches only
-.TP
-\fB\-\-ca\fR  print data for CA's only
-.TP
-\fB\-\-router\fR  print data for routers only
-.TP
-\fB\-\-clear\-errors\fR \fB\-k\fR Clear error counters after read.
-\-k and \-K can be used together to clear both errors and counters.
-.TP
-\fB\-\-clear\-counts\fR \fB\-K\fR Clear data counters after read.
-\fBCAUTION\fR clearing data counters will occur regardless of if they are
-printed or not.  This is because data counters are only \fBprinted\fR on ports
-which have errors.  This means if a port has 0 errors and the \-K option is
-specified the data counters will be cleared without any printed output.
-.TP
-\fB\-\-details\fR include receive error and transmit discard details
-.TP
-\fB\-\-load\-cache\fR <filename>
-Load and use the cached ibnetdiscover data stored in the specified
-filename.  May be useful for outputting and learning about other
-fabrics or a previous state of a fabric.  Cannot be used if user
-specifies a directo route path.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-R\fR  (This option is obsolete and does nothing)
-
-.SH COMMON OPTIONS
-.PP
-\-d      raise the IB debugging level.
-	May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-	May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-
-.SH AUTHOR
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
new file mode 100644
index 0000000..4e9c7a1
--- /dev/null
+++ b/man/ibqueryerrors.8.in
@@ -0,0 +1,120 @@
+.TH IBQUERYERRORS 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+ibqueryerrors \- query and report non-zero IB port counters
+
+.SH SYNOPSIS
+.B ibqueryerrors [options]
+
+.SH DESCRIPTION
+.PP
+The default behavior is to report the port error counters which exceed a
+threshold for each port in the fabric.  The default threshold is zero (0).
+Error fields can also be suppressed entirely.
+
+In addition to reporting errors on every port.  ibqueryerrors can report the
+port transmit and receive data as well as report full link information to the
+remote port if available.
+
+.SH OPTIONS
+
+.PP
+.TP
+\fB\-s <err1,err2,...>\fR
+Suppress the errors listed in the comma separated list provided.
+.TP
+\fB\-c\fR
+Suppress some of the common "side effect" counters.  These counters usually do
+not indicate an error condition and can be usually be safely ignored.
+.TP
+\fB\-G <node_guid>\fR
+Report results only for the node guid specified.
+.TP
+\fB\-S <node_guid>\fR
+\-S is provided only for backward compatibility and works the same as "-G"
+.TP
+\fB\-D <direct_route>\fR
+Report results only for the switch specified by the direct route path.
+.TP
+\fB\-r\fR
+Report the port information.  This includes LID, port, external port (if
+applicable), link speed setting, remote GUID, remote port, remote external port
+(if applicable), and remote node description information.
+.TP
+\fB\-\-data\fR
+Include the optional transmit and receive data counters.
+.TP
+\fB\-\-threshold-file\fR
+Specify an alternate threshold file.  The default is @IBDIAG_CONFIG_PATH@/error_thresholds
+.TP
+\fB\-\-switch\fR  print data for switches only
+.TP
+\fB\-\-ca\fR  print data for CA's only
+.TP
+\fB\-\-router\fR  print data for routers only
+.TP
+\fB\-\-clear\-errors\fR \fB\-k\fR Clear error counters after read.
+\-k and \-K can be used together to clear both errors and counters.
+.TP
+\fB\-\-clear\-counts\fR \fB\-K\fR Clear data counters after read.
+\fBCAUTION\fR clearing data counters will occur regardless of if they are
+printed or not.  This is because data counters are only \fBprinted\fR on ports
+which have errors.  This means if a port has 0 errors and the \-K option is
+specified the data counters will be cleared without any printed output.
+.TP
+\fB\-\-details\fR include receive error and transmit discard details
+.TP
+\fB\-\-load\-cache\fR <filename>
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.  Cannot be used if user
+specifies a directo route path.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
+.TP
+\fB\-R\fR  (This option is obsolete and does nothing)
+
+.SH COMMON OPTIONS
+.PP
+\-d      raise the IB debugging level.
+	May be used several times (-ddd or -d -d -d).
+.PP
+\-e      show send and receive errors (timeouts and others)
+.PP
+\-h      show the usage message
+.PP
+\-v      increase the application verbosity level.
+	May be used several times (-vv or -v -v -v)
+.PP
+\-V      show the version info.
+
+# Other common flags:
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
+
+.SH FILES
+
+@IBDIAG_CONFIG_PATH@/error_thresholds
+
+Define threshold values for errors.  File format is simple "name=val".
+Comments begin with '#'
+
+Example:
+
+	# Define thresholds for error counters
+.br
+	SymbolErrorCounter=10
+.br
+	LinkErrorRecoveryCounter=10
+.br
+	VL15Dropped=100
+
+
+.SH AUTHOR
+.TP
+Ira Weiny
+.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 295b398..68957fe 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -77,6 +77,69 @@ unsigned clear_errors = 0, clear_counts = 0, details = 0;
 #define PRINT_ROUTER 0x4
 #define PRINT_ALL 0xFF		/* all nodes default flag */
 
+struct {
+	int nodes_checked;
+	int bad_nodes;
+	int ports_checked;
+	int bad_ports;
+} summary = { 0 };
+
+#define DEF_THRES_FILE IBDIAG_CONFIG_PATH"/error_thresholds"
+static char *threshold_file = DEF_THRES_FILE;
+
+/* define a "packet" with threshold values in it */
+uint8_t thresholds[1204] = { 0 };
+
+static void set_thres(char *name, uint32_t val)
+{
+	int f;
+	for (f = IB_PC_FIRST_F; f <= IB_PC_LAST_F; f++) {
+		if (strcmp(name, mad_field_name(f)) == 0) {
+			mad_encode_field(thresholds, f, &val);
+			printf("[%s = %u]", name, val);
+		}
+	}
+}
+
+static void set_thresholds(char *threshold_file)
+{
+	char buf[1024];
+	int val = 0;
+	FILE *thresf = fopen(threshold_file, "r");
+	char *p_prefix, *p_last;
+	char *name;
+	char *val_str;
+
+	if (!thresf)
+		return;
+
+	printf("Thresholds: ");
+	while (fgets(buf, sizeof buf, thresf) != NULL) {
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
+		val = strtoul(val_str, NULL, 0);
+		set_thres(name, val);
+	}
+	printf("\n");
+
+	fclose(thresf);
+}
+
+static int exceeds_threshold(int field, unsigned val)
+{
+	uint32_t thres = 0;
+	mad_decode_field(thresholds, field, &thres);
+	return (val > thres);
+}
+
 static unsigned int get_max(unsigned int num)
 {
 	unsigned r = 0;		// r will be lg(num)
@@ -264,32 +327,33 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			continue;
 
 		mad_decode_field(pc, i, (void *)&val);
-		if (val)
+		if (exceeds_threshold(i, val)) {
 			n += snprintf(str + n, 1024 - n, " [%s == %u]",
 				      mad_field_name(i), val);
 
-		/* If there are PortXmitDiscards, get details (if supported) */
-		if (i == IB_PC_XMT_DISCARDS_F && details && val) {
-			n += query_and_dump(str + n, sizeof(buf) - n, portid,
-					    node, node_name, portnum,
-					    "PortXmitDiscardDetails",
-					    IB_GSI_PORT_XMIT_DISCARD_DETAILS,
-					    IB_PC_RCV_LOCAL_PHY_ERR_F,
-					    IB_PC_RCV_ERR_LAST_F);
-			/* If there are PortRcvErrors, get details (if supported) */
-		} else if (i == IB_PC_ERR_RCV_F && details && val) {
-			n += query_and_dump(str + n, sizeof(buf) - n, portid,
-					    node, node_name, portnum,
-					    "PortRcvErrorDetails",
-					    IB_GSI_PORT_RCV_ERROR_DETAILS,
-					    IB_PC_XMT_INACT_DISC_F,
-					    IB_PC_XMT_DISC_LAST_F);
+			/* If there are PortXmitDiscards, get details (if supported) */
+			if (i == IB_PC_XMT_DISCARDS_F && details) {
+				n += query_and_dump(str + n, sizeof(buf) - n, portid,
+						    node, node_name, portnum,
+						    "PortXmitDiscardDetails",
+						    IB_GSI_PORT_XMIT_DISCARD_DETAILS,
+						    IB_PC_RCV_LOCAL_PHY_ERR_F,
+						    IB_PC_RCV_ERR_LAST_F);
+				/* If there are PortRcvErrors, get details (if supported) */
+			} else if (i == IB_PC_ERR_RCV_F && details) {
+				n += query_and_dump(str + n, sizeof(buf) - n, portid,
+						    node, node_name, portnum,
+						    "PortRcvErrorDetails",
+						    IB_GSI_PORT_RCV_ERROR_DETAILS,
+						    IB_PC_XMT_INACT_DISC_F,
+						    IB_PC_XMT_DISC_LAST_F);
+			}
 		}
 	}
 
 	if (!suppress(IB_PC_XMT_WAIT_F)) {
 		mad_decode_field(pc, IB_PC_XMT_WAIT_F, (void *)&val);
-		if (val)
+		if (exceeds_threshold(IB_PC_XMT_WAIT_F, val))
 			n += snprintf(str + n, 1024 - n, " [%s == %u]",
 				      mad_field_name(IB_PC_XMT_WAIT_F), val);
 	}
@@ -536,6 +600,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 7:
 		load_cache_file = strdup(optarg);
 		break;
+	case 8:
+		threshold_file = strdup(optarg);
+		break;
 	case 'G':
 	case 'S':
 		node_guid_str = optarg;
@@ -590,6 +657,8 @@ int main(int argc, char **argv)
 		 "query only switch specified by <dr_path>"},
 		{"report-port", 'r', 0, NULL,
 		 "report port configuration information"},
+		{"threshold-file", 8, 1, NULL,
+		 "specify an alternate thresold file, default: " DEF_THRES_FILE},
 		{"GNDN", 'R', 0, NULL,
 		 "(This option is obsolete and does nothing)"},
 		{"data", 2, 0, NULL, "include the data counters in the output"},
@@ -678,6 +747,7 @@ int main(int argc, char **argv)
 	}
 
 	report_suppressed();
+	set_thresholds(threshold_file);
 
 	if (node_guid_str) {
 		ibnd_node_t *node = ibnd_find_node_guid(fabric, node_guid);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
