From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: combine common alias option processing
Date: Tue, 24 Jul 2012 10:50:52 -0700
Message-ID: <20120724105052.0bd049d050f10d2027b760d8@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |   16 ++++++++++++++++
 src/ibccconfig.c        |   21 +--------------------
 src/ibccquery.c         |   38 ++++++++++----------------------------
 src/ibdiag_common.c     |   10 ++++++++++
 src/smpquery.c          |   38 ++++++++++----------------------------
 5 files changed, 47 insertions(+), 76 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 7e6d5c1..c297c4d 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -161,4 +161,20 @@ int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
 int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
 		  const char *format, ...);
 void dump_portinfo(void *pi, int pisize, int tabs);
+
+
+/**
+ * Some common command line parsing
+ */
+typedef char *(op_fn_t) (ib_portid_t * dest, char **argv, int argc);
+
+typedef struct match_rec {
+	const char *name, *alias;
+	op_fn_t *fn;
+	unsigned opt_portnum;
+	char *ops_extra;
+} match_rec_t;
+
+op_fn_t *match_op(const match_rec_t match_tbl[], char *name);
+
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index 6dd6b0b..79a0e71 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -56,15 +56,6 @@
 
 struct ibmad_port *srcport;
 
-typedef char *(op_fn_t) (ib_portid_t * dest, char **argv, int argc);
-
-typedef struct match_rec {
-	const char *name, *alias;
-	op_fn_t *fn;
-	unsigned opt_portnum;
-	char *ops_extra;
-} match_rec_t;
-
 static op_fn_t congestion_key_info;
 static op_fn_t switch_congestion_setting;
 static op_fn_t switch_port_congestion_setting;
@@ -553,16 +544,6 @@ static char *congestion_control_table(ib_portid_t * dest, char **argv, int argc)
 	return NULL;
 }
 
-static op_fn_t *match_op(char *name)
-{
-	const match_rec_t *r;
-	for (r = match_tbl; r->name; r++)
-		if (!strcasecmp(r->name, name) ||
-		    (r->alias && !strcasecmp(r->alias, name)))
-			return r->fn;
-	return NULL;
-}
-
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
@@ -623,7 +604,7 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		ibdiag_show_usage();
 
-	if (!(fn = match_op(argv[0])))
+	if (!(fn = match_op(match_tbl, argv[0])))
 		IBERROR("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 476436f..5e0e283 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -53,14 +53,6 @@
 
 struct ibmad_port *srcport;
 
-typedef char *(op_fn_t) (ib_portid_t * dest, char **argv, int argc);
-
-typedef struct match_rec {
-	const char *name, *alias;
-	op_fn_t *fn;
-	unsigned opt_portnum;
-} match_rec_t;
-
 static op_fn_t class_port_info;
 static op_fn_t congestion_info;
 static op_fn_t congestion_key_info;
@@ -72,15 +64,15 @@ static op_fn_t congestion_control_table;
 static op_fn_t timestamp_dump;
 
 static const match_rec_t match_tbl[] = {
-	{"ClassPortInfo", "CP", class_port_info, 0},
-	{"CongestionInfo", "CI", congestion_info, 0},
-	{"CongestionKeyInfo", "CK", congestion_key_info, 0},
-	{"CongestionLog", "CL", congestion_log, 0},
-	{"SwitchCongestionSetting", "SS", switch_congestion_setting, 0},
-	{"SwitchPortCongestionSetting", "SP", switch_port_congestion_setting, 1},
-	{"CACongestionSetting", "CS", ca_congestion_setting, 0},
-	{"CongestionControlTable", "CT", congestion_control_table, 0},
-	{"Timestamp", "TI", timestamp_dump, 0},
+	{"ClassPortInfo", "CP", class_port_info, 0, ""},
+	{"CongestionInfo", "CI", congestion_info, 0, ""},
+	{"CongestionKeyInfo", "CK", congestion_key_info, 0, ""},
+	{"CongestionLog", "CL", congestion_log, 0, ""},
+	{"SwitchCongestionSetting", "SS", switch_congestion_setting, 0, ""},
+	{"SwitchPortCongestionSetting", "SP", switch_port_congestion_setting, 1, ""},
+	{"CACongestionSetting", "CS", ca_congestion_setting, 0, ""},
+	{"CongestionControlTable", "CT", congestion_control_table, 0, ""},
+	{"Timestamp", "TI", timestamp_dump, 0, ""},
 	{0}
 };
 
@@ -344,16 +336,6 @@ static char *timestamp_dump(ib_portid_t * dest, char **argv, int argc)
 	return NULL;
 }
 
-static op_fn_t *match_op(char *name)
-{
-	const match_rec_t *r;
-	for (r = match_tbl; r->name; r++)
-		if (!strcasecmp(r->name, name) ||
-		    (r->alias && !strcasecmp(r->alias, name)))
-			return r->fn;
-	return NULL;
-}
-
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
@@ -407,7 +389,7 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		ibdiag_show_usage();
 
-	if (!(fn = match_op(argv[0])))
+	if (!(fn = match_op(match_tbl, argv[0])))
 		IBERROR("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index ebe8797..d550529 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -1016,3 +1016,13 @@ void dump_portinfo(void *pi, int pisize, int tabs)
 		printf("%s\n", buf);
 	}
 }
+
+op_fn_t *match_op(const match_rec_t match_tbl[], char *name)
+{
+	const match_rec_t *r;
+	for (r = match_tbl; r->name; r++)
+		if (!strcasecmp(r->name, name) ||
+		    (r->alias && !strcasecmp(r->alias, name)))
+			return r->fn;
+	return NULL;
+}
diff --git a/src/smpquery.c b/src/smpquery.c
index 66354e0..5ba0a05 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -54,27 +54,19 @@
 
 struct ibmad_port *srcport;
 
-typedef char *(op_fn_t) (ib_portid_t * dest, char **argv, int argc);
-
-typedef struct match_rec {
-	const char *name, *alias;
-	op_fn_t *fn;
-	unsigned opt_portnum;
-} match_rec_t;
-
 static op_fn_t node_desc, node_info, port_info, switch_info, pkey_table,
     sl2vl_table, vlarb_table, guid_info, mlnx_ext_port_info;
 
 static const match_rec_t match_tbl[] = {
-	{"NodeInfo", "NI", node_info},
-	{"NodeDesc", "ND", node_desc},
-	{"PortInfo", "PI", port_info, 1},
-	{"SwitchInfo", "SI", switch_info},
-	{"PKeyTable", "PKeys", pkey_table, 1},
-	{"SL2VLTable", "SL2VL", sl2vl_table, 1},
-	{"VLArbitration", "VLArb", vlarb_table, 1},
-	{"GUIDInfo", "GI", guid_info},
-	{"MlnxExtPortInfo", "MEPI", mlnx_ext_port_info, 1},
+	{"NodeInfo", "NI", node_info, 0, ""},
+	{"NodeDesc", "ND", node_desc, 0, ""},
+	{"PortInfo", "PI", port_info, 1, ""},
+	{"SwitchInfo", "SI", switch_info, 0, ""},
+	{"PKeyTable", "PKeys", pkey_table, 1, ""},
+	{"SL2VLTable", "SL2VL", sl2vl_table, 1, ""},
+	{"VLArbitration", "VLArb", vlarb_table, 1, ""},
+	{"GUIDInfo", "GI", guid_info, 0, ""},
+	{"MlnxExtPortInfo", "MEPI", mlnx_ext_port_info, 1, ""},
 	{0}
 };
 
@@ -396,16 +388,6 @@ static char *guid_info(ib_portid_t * dest, char **argv, int argc)
 	return 0;
 }
 
-static op_fn_t *match_op(char *name)
-{
-	const match_rec_t *r;
-	for (r = match_tbl; r->name; r++)
-		if (!strcasecmp(r->name, name) ||
-		    (r->alias && !strcasecmp(r->alias, name)))
-			return r->fn;
-	return NULL;
-}
-
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
@@ -470,7 +452,7 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		ibdiag_show_usage();
 
-	if (!(fn = match_op(argv[0])))
+	if (!(fn = match_op(match_tbl, argv[0])))
 		IBERROR("operation '%s' not supported", argv[0]);
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
