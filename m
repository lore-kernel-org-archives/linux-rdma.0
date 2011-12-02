From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] infiniband-diags: add config file option for Mellanox
 ExtPortInfo queries
Date: Fri, 2 Dec 2011 12:00:17 -0800
Message-ID: <20111202120017.0e8b525e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In addition add a common option to specify an alternate config file.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 etc/ibdiag.conf                             |    4 +
 include/ibdiag_common.h                     |    1 +
 libibnetdisc/include/infiniband/ibnetdisc.h |    6 +-
 libibnetdisc/src/ibnetdisc.c                |    6 +-
 man/infiniband-diags.8.in                   |   10 ++-
 src/ibdiag_common.c                         |  113 ++++++++++++++++-----------
 src/iblinkinfo.c                            |    2 +
 src/ibqueryerrors.c                         |    2 +
 8 files changed, 93 insertions(+), 51 deletions(-)

diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
index 1668a90..77f3ce9 100644
--- a/etc/ibdiag.conf
+++ b/etc/ibdiag.conf
@@ -11,3 +11,7 @@
 # define a different default timeout
 #timeout=50
 
+# disable query of Mellanox Extended PortInfo on ibnetdiscover subnet sweeps
+# Default = true
+#MLX_EPI=false
+
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 1d8cdc7..0131193 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -49,6 +49,7 @@ extern int ibd_ca_port;
 extern enum MAD_DEST ibd_dest_type;
 extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
+extern uint32_t ibd_ibnetdisc_flags;
 
 /*========================================================*/
 /*                External interface                      */
diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index 09e9c7e..2ae2b06 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -140,6 +140,9 @@ typedef struct ibnd_chassis {
 
 #define HTSZ 137
 
+/* define config flags */
+#define IBND_CONFIG_MLX_EPI (1 << 0)
+
 typedef struct ibnd_config {
 	unsigned max_smps;
 	unsigned show_progress;
@@ -147,7 +150,8 @@ typedef struct ibnd_config {
 	unsigned debug;
 	unsigned timeout_ms;
 	unsigned retries;
-	uint8_t pad[56];
+	uint32_t flags;
+	uint8_t pad[52];
 } ibnd_config_t;
 
 /** =========================================================================
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index c93e7ad..8d38ab7 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -318,7 +318,8 @@ static int query_mlnx_ext_port_info(smp_engine_t * engine, ib_portid_t * portid,
 static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	ibnd_scan_t *scan = (ibnd_scan_t *)engine->user_data;
+	ibnd_fabric_t *fabric = scan->fabric;
 	ibnd_node_t *node = cb_data;
 	ibnd_port_t *port;
 	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
@@ -360,7 +361,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 
 	add_to_portguid_hash(port, fabric->portstbl);
 
-	if (is_mlnx_ext_port_info_supported(port)) {
+	if ((scan->cfg->flags & IBND_CONFIG_MLX_EPI)
+	    && is_mlnx_ext_port_info_supported(port)) {
 		phystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
 		ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
 		if (port->node->type == IB_NODE_SWITCH)
diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
index 80773cd..f0671ca 100644
--- a/man/infiniband-diags.8.in
+++ b/man/infiniband-diags.8.in
@@ -84,12 +84,20 @@ using "<util_name> -h".
 .PP
 \-V      show the version info.
 
+.TP
+\fB# Configuration flags\fR
+.PP
+\-\-config \-z  <config_file>
+        Specify alternate config file.
+        Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
+
 .SH FILES
 
 @IBDIAG_CONFIG_PATH@/ibdiag.conf
 
 A global config file is provided to set some of the common options for all
-tools.
+tools.  See supplied config file for details.
+
 
 .SH NODE NAME MAP FILE FORMAT
 Most utilities use the optional node name map file supported by libosmcomp to
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e7c514a..b26a5e2 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -66,11 +66,10 @@ static ib_portid_t sm_portid = { 0 };
 
 /* general config options */
 #define IBDIAG_CONFIG_GENERAL IBDIAG_CONFIG_PATH"/ibdiag.conf"
-static char *ibdiag_config_general = IBDIAG_CONFIG_GENERAL;
 char *ibd_ca = NULL;
 int ibd_ca_port = 0;
 int ibd_timeout = 0;
-
+uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
 
 static const char *prog_name;
 static const char *prog_args;
@@ -108,6 +107,60 @@ static void pretty_print(int start, int width, const char *str)
 	}
 }
 
+static inline int val_str_true(const char *val_str)
+{
+	return ((strncmp(val_str, "TRUE", strlen("TRUE")) == 0) ||
+		(strncmp(val_str, "true", strlen("true")) == 0));
+}
+
+void read_ibdiag_config(const char *file)
+{
+	char buf[1024];
+	FILE *config_fd = NULL;
+	char *p_prefix, *p_last;
+	char *name;
+	char *val_str;
+	struct stat statbuf;
+
+	/* silently ignore missing config file */
+	if (stat(file, &statbuf))
+		return;
+
+	config_fd = fopen(file, "r");
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
+			free(ibd_ca);
+			ibd_ca = strdup(val_str);
+		} else if (strncmp(name, "Port", strlen("Port")) == 0) {
+			ibd_ca_port = strtoul(val_str, NULL, 0);
+		} else if (strncmp(name, "timeout", strlen("timeout")) == 0) {
+			ibd_timeout = strtoul(val_str, NULL, 0);
+		} else if (strncmp(name, "MLX_EPI", strlen("MLX_EPI")) == 0) {
+			if (val_str_true(val_str)) {
+				ibd_ibnetdisc_flags |= IBND_CONFIG_MLX_EPI;
+			} else {
+				ibd_ibnetdisc_flags &= ~IBND_CONFIG_MLX_EPI;
+			}
+		}
+	}
+
+	fclose(config_fd);
+}
+
+
 void ibdiag_show_usage()
 {
 	struct option *o = long_opts;
@@ -152,6 +205,9 @@ static int process_opt(int ch, char *optarg)
 	long val;
 
 	switch (ch) {
+	case 'z':
+		read_ibdiag_config(optarg);
+		break;
 	case 'h':
 	case 'u':
 		ibdiag_show_usage();
@@ -213,6 +269,7 @@ static int process_opt(int ch, char *optarg)
 }
 
 static const struct ibdiag_opt common_opts[] = {
+	{"config", 'z', 1, "<config>", "use config file, default: " IBDIAG_CONFIG_GENERAL},
 	{"Ca", 'C', 1, "<ca>", "Ca name to use"},
 	{"Port", 'P', 1, "<port>", "Ca port number to use"},
 	{"Direct", 'D', 0, NULL, "use Direct address argument"},
@@ -286,46 +343,6 @@ static void make_str_opts(const struct option *o, char *p, unsigned size)
 	p[n] = '\0';
 }
 
-void read_ibdiag_config(void)
-{
-	char buf[1024];
-	FILE *config_fd = NULL;
-	char *p_prefix, *p_last;
-	char *name;
-	char *val_str;
-	struct stat statbuf;
-
-	/* silently ignore missing config file */
-	if (stat(ibdiag_config_general, &statbuf))
-		return;
-
-	config_fd = fopen(ibdiag_config_general, "r");
-	if (!config_fd)
-		return;
-
-	while (fgets(buf, sizeof buf, config_fd) != NULL) {
-		p_prefix = strtok_r(buf, "\n", &p_last);
-		if (!p_prefix)
-			continue; /* ignore blank lines */
-
-		if (*p_prefix == '#')
-			continue; /* ignore comment lines */
-
-		name = strtok_r(p_prefix, "=", &p_last);
-		val_str = strtok_r(NULL, "\n", &p_last);
-
-		if (strncmp(name, "CA", strlen("CA")) == 0) {
-			ibd_ca = strdup(val_str);
-		} else if (strncmp(name, "Port", strlen("Port")) == 0) {
-			ibd_ca_port = strtoul(val_str, NULL, 0);
-		} else if (strncmp(name, "timeout", strlen("timeout")) == 0) {
-			ibd_timeout = strtoul(val_str, NULL, 0);
-		}
-	}
-
-	fclose(config_fd);
-}
-
 int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 			const char *exclude_common_str,
 			const struct ibdiag_opt custom_opts[],
@@ -344,7 +361,7 @@ int ibdiag_process_opts(int argc, char *const argv[], void *cxt,
 	if (!long_opts)
 		return -1;
 
-	read_ibdiag_config();
+	read_ibdiag_config(IBDIAG_CONFIG_GENERAL);
 
 	make_str_opts(long_opts, str_opts, sizeof(str_opts));
 
@@ -457,10 +474,12 @@ conv_cnt_human_readable(uint64_t val64, float *val, int data)
 
 int is_mlnx_ext_port_info_supported(uint32_t devid)
 {
-	if (devid == 0xc738)
-		return 1;
-	if (devid >= 0x1003 && devid <= 0x1010)
-		return 1;
+	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
+		if (devid == 0xc738)
+			return 1;
+		if (devid >= 0x1003 && devid <= 0x1010)
+			return 1;
+	}
 	return 0;
 }
 
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 00c7bc0..265086f 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -637,6 +637,8 @@ int main(int argc, char **argv)
 		config.timeout_ms = ibd_timeout;
 	}
 
+	config.flags = ibd_ibnetdisc_flags;
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (dr_path && load_cache_file) {
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index e070baf..213f11f 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -919,6 +919,8 @@ int main(int argc, char **argv)
 		config.timeout_ms = ibd_timeout;
 	}
 
+	config.flags = ibd_ibnetdisc_flags;
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (dr_path && load_cache_file) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
