From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: remove SMI class registration where
 possible
Date: Mon, 30 Apr 2012 14:07:09 -0700
Message-ID: <20120430140709.fe2db290.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibccconfig.c    |    5 ++---
 src/ibccquery.c     |    5 ++---
 src/ibdiag_common.c |    4 ++++
 src/ibping.c        |    5 ++---
 src/perfquery.c     |    6 ++----
 src/vendstat.c      |    6 ++----
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index 71d408a..0aae5c5 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -584,8 +584,7 @@ static int process_opt(void *context, int ch, char *optarg)
 int main(int argc, char **argv)
 {
 	char usage_args[1024];
-	int mgmt_classes[4] =
-	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS, IB_CC_CLASS };
+	int mgmt_classes[3] = { IB_SMI_CLASS, IB_SA_CLASS, IB_CC_CLASS };
 	ib_portid_t portid = { 0 };
 	char *err;
 	op_fn_t *fn;
@@ -632,7 +631,7 @@ int main(int argc, char **argv)
 	if (!(fn = match_op(argv[0])))
 		IBERROR("operation '%s' not supported", argv[0]);
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 2bf62fa..acdfe46 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -370,8 +370,7 @@ static int process_opt(void *context, int ch, char *optarg)
 int main(int argc, char **argv)
 {
 	char usage_args[1024];
-	int mgmt_classes[4] =
-	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS, IB_CC_CLASS };
+	int mgmt_classes[3] = { IB_SMI_CLASS, IB_SA_CLASS, IB_CC_CLASS };
 	ib_portid_t portid = { 0 };
 	char *err;
 	op_fn_t *fn;
@@ -412,7 +411,7 @@ int main(int argc, char **argv)
 	if (!(fn = match_op(argv[0])))
 		IBERROR("operation '%s' not supported", argv[0]);
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index d53398b..a4e8cfa 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -598,6 +598,10 @@ int resolve_guid(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
 	return 0;
 }
 
+/*
+ * Callers of this function should ensure their ibmad_port has been opened with
+ * IB_SA_CLASS as this function may require the SA to resolve addresses.
+ */
 int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
 		       char *addr_str, enum MAD_DEST dest_type,
 		       ib_portid_t *sm_id, const struct ibmad_port *srcport)
diff --git a/src/ibping.c b/src/ibping.c
index 9d5c54b..205aa82 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -188,8 +188,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
-	int mgmt_classes[3] =
-	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
+	int mgmt_classes[1] = { IB_SA_CLASS };
 	int ping_class = IB_VENDOR_OPENIB_PING_CLASS;
 	uint64_t rtt;
 	char *err;
@@ -212,7 +211,7 @@ int main(int argc, char **argv)
 	if (!argc && !server)
 		ibdiag_show_usage();
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 1);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
diff --git a/src/perfquery.c b/src/perfquery.c
index 8835d3d..b58ad70 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -656,9 +656,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
-	int mgmt_classes[4] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS,
-		IB_PERFORMANCE_CLASS
-	};
+	int mgmt_classes[2] = { IB_SA_CLASS, IB_PERFORMANCE_CLASS };
 	ib_portid_t portid = { 0 };
 	int mask = 0xffff;
 	uint64_t ext_mask = 0xffffffffffffffff;
@@ -725,7 +723,7 @@ int main(int argc, char **argv)
 		mask = ext_mask;
 	}
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
diff --git a/src/vendstat.c b/src/vendstat.c
index 413d202..78f6d7d 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -303,9 +303,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
-	int mgmt_classes[4] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS,
-		IB_MLX_VENDOR_CLASS
-	};
+	int mgmt_classes[2] = { IB_SA_CLASS, IB_MLX_VENDOR_CLASS };
 	ib_portid_t portid = { 0 };
 	int port = 0;
 	char buf[1024];
@@ -343,7 +341,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		port = strtoul(argv[1], 0, 0);
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
