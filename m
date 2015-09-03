From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 1/3] Add support for extended query device capabilities
Date: Thu,  3 Sep 2015 17:56:37 +0300
Message-ID: <1441292199-8371-2-git-send-email-haggaie@mellanox.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441292199-8371-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the verb ibv_query_device_ex which is extensible and allows following
commits to add new features to define additional properties.

Cc: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |   3 +-
 examples/devinfo.c            |  94 +++++++++++++++---------------
 include/infiniband/driver.h   |  10 ++++
 include/infiniband/kern-abi.h |  25 +++++++-
 include/infiniband/verbs.h    |  43 ++++++++++++++
 man/ibv_query_device_ex.3     |  47 +++++++++++++++
 src/cmd.c                     | 131 +++++++++++++++++++++++++++++-------------
 src/libibverbs.map            |   2 +
 8 files changed, 264 insertions(+), 91 deletions(-)
 create mode 100644 man/ibv_query_device_ex.3

diff --git a/Makefile.am b/Makefile.am
index ef4df033581d..c85e98ae0662 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -62,7 +62,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
-    man/ibv_get_srq_num.3 man/ibv_open_qp.3
+    man/ibv_get_srq_num.3 man/ibv_open_qp.3 \
+    man/ibv_query_device_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/examples/devinfo.c b/examples/devinfo.c
index afa8c853868f..f8aa9b45838a 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -207,7 +207,7 @@ static const char *link_layer_str(uint8_t link_layer)
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
-	struct ibv_device_attr device_attr;
+	struct ibv_device_attr_ex device_attr;
 	struct ibv_port_attr port_attr;
 	int rc = 0;
 	uint8_t port;
@@ -219,12 +219,12 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		rc = 1;
 		goto cleanup;
 	}
-	if (ibv_query_device(ctx, &device_attr)) {
+	if (ibv_query_device_ex(ctx, NULL, &device_attr)) {
 		fprintf(stderr, "Failed to query device props\n");
 		rc = 2;
 		goto cleanup;
 	}
-	if (ib_port && ib_port > device_attr.phys_port_cnt) {
+	if (ib_port && ib_port > device_attr.orig_attr.phys_port_cnt) {
 		fprintf(stderr, "Invalid port requested for device\n");
 		/* rc = 3 is taken by failure to clean up */
 		rc = 4;
@@ -234,63 +234,63 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 	printf("hca_id:\t%s\n", ibv_get_device_name(ib_dev));
 	printf("\ttransport:\t\t\t%s (%d)\n",
 	       transport_str(ib_dev->transport_type), ib_dev->transport_type);
-	if (strlen(device_attr.fw_ver))
-		printf("\tfw_ver:\t\t\t\t%s\n", device_attr.fw_ver);
-	printf("\tnode_guid:\t\t\t%s\n", guid_str(device_attr.node_guid, buf));
-	printf("\tsys_image_guid:\t\t\t%s\n", guid_str(device_attr.sys_image_guid, buf));
-	printf("\tvendor_id:\t\t\t0x%04x\n", device_attr.vendor_id);
-	printf("\tvendor_part_id:\t\t\t%d\n", device_attr.vendor_part_id);
-	printf("\thw_ver:\t\t\t\t0x%X\n", device_attr.hw_ver);
+	if (strlen(device_attr.orig_attr.fw_ver))
+		printf("\tfw_ver:\t\t\t\t%s\n", device_attr.orig_attr.fw_ver);
+	printf("\tnode_guid:\t\t\t%s\n", guid_str(device_attr.orig_attr.node_guid, buf));
+	printf("\tsys_image_guid:\t\t\t%s\n", guid_str(device_attr.orig_attr.sys_image_guid, buf));
+	printf("\tvendor_id:\t\t\t0x%04x\n", device_attr.orig_attr.vendor_id);
+	printf("\tvendor_part_id:\t\t\t%d\n", device_attr.orig_attr.vendor_part_id);
+	printf("\thw_ver:\t\t\t\t0x%X\n", device_attr.orig_attr.hw_ver);
 
 	if (ibv_read_sysfs_file(ib_dev->ibdev_path, "board_id", buf, sizeof buf) > 0)
 		printf("\tboard_id:\t\t\t%s\n", buf);
 
-	printf("\tphys_port_cnt:\t\t\t%d\n", device_attr.phys_port_cnt);
+	printf("\tphys_port_cnt:\t\t\t%d\n", device_attr.orig_attr.phys_port_cnt);
 
 	if (verbose) {
 		printf("\tmax_mr_size:\t\t\t0x%llx\n",
-		       (unsigned long long) device_attr.max_mr_size);
+		       (unsigned long long) device_attr.orig_attr.max_mr_size);
 		printf("\tpage_size_cap:\t\t\t0x%llx\n",
-		       (unsigned long long) device_attr.page_size_cap);
-		printf("\tmax_qp:\t\t\t\t%d\n", device_attr.max_qp);
-		printf("\tmax_qp_wr:\t\t\t%d\n", device_attr.max_qp_wr);
-		printf("\tdevice_cap_flags:\t\t0x%08x\n", device_attr.device_cap_flags);
-		printf("\tmax_sge:\t\t\t%d\n", device_attr.max_sge);
-		printf("\tmax_sge_rd:\t\t\t%d\n", device_attr.max_sge_rd);
-		printf("\tmax_cq:\t\t\t\t%d\n", device_attr.max_cq);
-		printf("\tmax_cqe:\t\t\t%d\n", device_attr.max_cqe);
-		printf("\tmax_mr:\t\t\t\t%d\n", device_attr.max_mr);
-		printf("\tmax_pd:\t\t\t\t%d\n", device_attr.max_pd);
-		printf("\tmax_qp_rd_atom:\t\t\t%d\n", device_attr.max_qp_rd_atom);
-		printf("\tmax_ee_rd_atom:\t\t\t%d\n", device_attr.max_ee_rd_atom);
-		printf("\tmax_res_rd_atom:\t\t%d\n", device_attr.max_res_rd_atom);
-		printf("\tmax_qp_init_rd_atom:\t\t%d\n", device_attr.max_qp_init_rd_atom);
-		printf("\tmax_ee_init_rd_atom:\t\t%d\n", device_attr.max_ee_init_rd_atom);
+		       (unsigned long long) device_attr.orig_attr.page_size_cap);
+		printf("\tmax_qp:\t\t\t\t%d\n", device_attr.orig_attr.max_qp);
+		printf("\tmax_qp_wr:\t\t\t%d\n", device_attr.orig_attr.max_qp_wr);
+		printf("\tdevice_cap_flags:\t\t0x%08x\n", device_attr.orig_attr.device_cap_flags);
+		printf("\tmax_sge:\t\t\t%d\n", device_attr.orig_attr.max_sge);
+		printf("\tmax_sge_rd:\t\t\t%d\n", device_attr.orig_attr.max_sge_rd);
+		printf("\tmax_cq:\t\t\t\t%d\n", device_attr.orig_attr.max_cq);
+		printf("\tmax_cqe:\t\t\t%d\n", device_attr.orig_attr.max_cqe);
+		printf("\tmax_mr:\t\t\t\t%d\n", device_attr.orig_attr.max_mr);
+		printf("\tmax_pd:\t\t\t\t%d\n", device_attr.orig_attr.max_pd);
+		printf("\tmax_qp_rd_atom:\t\t\t%d\n", device_attr.orig_attr.max_qp_rd_atom);
+		printf("\tmax_ee_rd_atom:\t\t\t%d\n", device_attr.orig_attr.max_ee_rd_atom);
+		printf("\tmax_res_rd_atom:\t\t%d\n", device_attr.orig_attr.max_res_rd_atom);
+		printf("\tmax_qp_init_rd_atom:\t\t%d\n", device_attr.orig_attr.max_qp_init_rd_atom);
+		printf("\tmax_ee_init_rd_atom:\t\t%d\n", device_attr.orig_attr.max_ee_init_rd_atom);
 		printf("\tatomic_cap:\t\t\t%s (%d)\n",
-		       atomic_cap_str(device_attr.atomic_cap), device_attr.atomic_cap);
-		printf("\tmax_ee:\t\t\t\t%d\n", device_attr.max_ee);
-		printf("\tmax_rdd:\t\t\t%d\n", device_attr.max_rdd);
-		printf("\tmax_mw:\t\t\t\t%d\n", device_attr.max_mw);
-		printf("\tmax_raw_ipv6_qp:\t\t%d\n", device_attr.max_raw_ipv6_qp);
-		printf("\tmax_raw_ethy_qp:\t\t%d\n", device_attr.max_raw_ethy_qp);
-		printf("\tmax_mcast_grp:\t\t\t%d\n", device_attr.max_mcast_grp);
-		printf("\tmax_mcast_qp_attach:\t\t%d\n", device_attr.max_mcast_qp_attach);
+		       atomic_cap_str(device_attr.orig_attr.atomic_cap), device_attr.orig_attr.atomic_cap);
+		printf("\tmax_ee:\t\t\t\t%d\n", device_attr.orig_attr.max_ee);
+		printf("\tmax_rdd:\t\t\t%d\n", device_attr.orig_attr.max_rdd);
+		printf("\tmax_mw:\t\t\t\t%d\n", device_attr.orig_attr.max_mw);
+		printf("\tmax_raw_ipv6_qp:\t\t%d\n", device_attr.orig_attr.max_raw_ipv6_qp);
+		printf("\tmax_raw_ethy_qp:\t\t%d\n", device_attr.orig_attr.max_raw_ethy_qp);
+		printf("\tmax_mcast_grp:\t\t\t%d\n", device_attr.orig_attr.max_mcast_grp);
+		printf("\tmax_mcast_qp_attach:\t\t%d\n", device_attr.orig_attr.max_mcast_qp_attach);
 		printf("\tmax_total_mcast_qp_attach:\t%d\n",
-		       device_attr.max_total_mcast_qp_attach);
-		printf("\tmax_ah:\t\t\t\t%d\n", device_attr.max_ah);
-		printf("\tmax_fmr:\t\t\t%d\n", device_attr.max_fmr);
-		if (device_attr.max_fmr)
-			printf("\tmax_map_per_fmr:\t\t%d\n", device_attr.max_map_per_fmr);
-		printf("\tmax_srq:\t\t\t%d\n", device_attr.max_srq);
-		if (device_attr.max_srq) {
-			printf("\tmax_srq_wr:\t\t\t%d\n", device_attr.max_srq_wr);
-			printf("\tmax_srq_sge:\t\t\t%d\n", device_attr.max_srq_sge);
+		       device_attr.orig_attr.max_total_mcast_qp_attach);
+		printf("\tmax_ah:\t\t\t\t%d\n", device_attr.orig_attr.max_ah);
+		printf("\tmax_fmr:\t\t\t%d\n", device_attr.orig_attr.max_fmr);
+		if (device_attr.orig_attr.max_fmr)
+			printf("\tmax_map_per_fmr:\t\t%d\n", device_attr.orig_attr.max_map_per_fmr);
+		printf("\tmax_srq:\t\t\t%d\n", device_attr.orig_attr.max_srq);
+		if (device_attr.orig_attr.max_srq) {
+			printf("\tmax_srq_wr:\t\t\t%d\n", device_attr.orig_attr.max_srq_wr);
+			printf("\tmax_srq_sge:\t\t\t%d\n", device_attr.orig_attr.max_srq_sge);
 		}
-		printf("\tmax_pkeys:\t\t\t%d\n", device_attr.max_pkeys);
-		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.local_ca_ack_delay);
+		printf("\tmax_pkeys:\t\t\t%d\n", device_attr.orig_attr.max_pkeys);
+		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.orig_attr.local_ca_ack_delay);
 	}
 
-	for (port = 1; port <= device_attr.phys_port_cnt; ++port) {
+	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
 		/* if in the command line the user didn't ask for info about this port */
 		if ((ib_port) && (port != ib_port))
 			continue;
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5cc092bf9bd5..8227df0ae649 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -105,6 +105,16 @@ int ibv_cmd_query_device(struct ibv_context *context,
 			 struct ibv_device_attr *device_attr,
 			 uint64_t *raw_fw_ver,
 			 struct ibv_query_device *cmd, size_t cmd_size);
+int ibv_cmd_query_device_ex(struct ibv_context *context,
+			    const struct ibv_query_device_ex_input *input,
+			    struct ibv_device_attr_ex *attr, size_t attr_size,
+			    uint64_t *raw_fw_ver,
+			    struct ibv_query_device_ex *cmd,
+			    size_t cmd_core_size,
+			    size_t cmd_size,
+			    struct ibv_query_device_resp_ex *resp,
+			    size_t resp_core_size,
+			    size_t resp_size);
 int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 		       struct ibv_port_attr *port_attr,
 		       struct ibv_query_port *cmd, size_t cmd_size);
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 91b45d837239..baa897c0d1bf 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -101,10 +101,16 @@ enum {
 
 #define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul
 
+/* use this mask for creating extended commands */
+#define IB_USER_VERBS_CMD_EXTENDED_MASK \
+	(IB_USER_VERBS_CMD_FLAG_EXTENDED << \
+	 IB_USER_VERBS_CMD_FLAGS_SHIFT)
+
 
 enum {
-	IB_USER_VERBS_CMD_CREATE_FLOW = (IB_USER_VERBS_CMD_FLAG_EXTENDED <<
-					 IB_USER_VERBS_CMD_FLAGS_SHIFT) +
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+					    IB_USER_VERBS_CMD_QUERY_DEVICE,
+	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW
 };
@@ -240,6 +246,18 @@ struct ibv_query_device_resp {
 	__u8  reserved[4];
 };
 
+struct ibv_query_device_ex {
+	struct ex_hdr	hdr;
+	__u32		comp_mask;
+	__u32		reserved;
+};
+
+struct ibv_query_device_resp_ex {
+	struct ibv_query_device_resp base;
+	__u32 comp_mask;
+	__u32 response_length;
+};
+
 struct ibv_query_port {
 	__u32 command;
 	__u16 in_words;
@@ -1001,7 +1019,8 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
 	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1
+	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 28e1586b0c96..a3b999eebe47 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -40,6 +40,7 @@
 #include <pthread.h>
 #include <stddef.h>
 #include <errno.h>
+#include <string.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -168,6 +169,17 @@ struct ibv_device_attr {
 	uint8_t			phys_port_cnt;
 };
 
+/* An extensible input struct for possible future extensions of the
+ * ibv_query_device_ex verb. */
+struct ibv_query_device_ex_input {
+	uint32_t		comp_mask;
+};
+
+struct ibv_device_attr_ex {
+	struct ibv_device_attr	orig_attr;
+	uint32_t		comp_mask;
+};
+
 enum ibv_mtu {
 	IBV_MTU_256  = 1,
 	IBV_MTU_512  = 2,
@@ -977,6 +989,10 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_device_ex)(struct ibv_context *context,
+			       const struct ibv_query_device_ex_input *input,
+			       struct ibv_device_attr_ex *attr,
+			       size_t attr_size);
 	int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
 	int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
 	struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
@@ -1400,6 +1416,33 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_query_device_ex - Get extended device properties
+ */
+static inline int
+ibv_query_device_ex(struct ibv_context *context,
+		    const struct ibv_query_device_ex_input *input,
+		    struct ibv_device_attr_ex *attr)
+{
+	struct verbs_context *vctx;
+	int ret;
+
+	vctx = verbs_get_ctx_op(context, query_device_ex);
+	if (!vctx)
+		goto legacy;
+
+	ret = vctx->query_device_ex(context, input, attr, sizeof(*attr));
+	if (ret == ENOSYS)
+		goto legacy;
+
+	return ret;
+
+legacy:
+	memset(attr, 0, sizeof(*attr));
+	ret = ibv_query_device(context, &attr->orig_attr);
+	return ret;
+}
+
+/**
  * ibv_open_qp - Open a shareable queue pair.
  */
 static inline struct ibv_qp *
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
new file mode 100644
index 000000000000..6b33f9f92ab1
--- /dev/null
+++ b/man/ibv_query_device_ex.3
@@ -0,0 +1,47 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_QUERY_DEVICE_EX 3 2014-12-17 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_query_device_ex \- query an RDMA device's attributes
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_query_device_ex(struct ibv_context " "*context",
+.BI "                        struct ibv_device_attr_ex " "*attr" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_query_device_ex()
+returns the attributes of the device with context
+.I context\fR.
+The argument
+.I attr
+is a pointer to an ibv_device_attr_ex struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_device_attr_ex {
+.in +8
+struct ibv_device_attr orig_attr;
+uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
+.in -8
+};
+.fi
+.SH "RETURN VALUE"
+.B ibv_query_device_ex()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+The maximum values returned by this function are the upper limits of
+supported resources by the device.  However, it may not be possible to
+use these maximum values, since the actual number of any resource that
+can be created may be limited by the machine configuration, the amount
+of host memory, user permissions, and the amount of resources already
+in use by other users/processes.
+.SH "SEE ALSO"
+.BR ibv_query_device (3),
+.BR ibv_open_device (3),
+.BR ibv_query_port (3),
+.BR ibv_query_pkey (3),
+.BR ibv_query_gid (3)
+.SH "AUTHORS"
+.TP
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/src/cmd.c b/src/cmd.c
index 45ea06ff4705..c1a6883dfd6c 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -66,6 +66,52 @@ int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd
 	return 0;
 }
 
+static void copy_query_dev_fields(struct ibv_device_attr *device_attr,
+				  struct ibv_query_device_resp *resp,
+				  uint64_t *raw_fw_ver)
+{
+	*raw_fw_ver				= resp->fw_ver;
+	device_attr->node_guid			= resp->node_guid;
+	device_attr->sys_image_guid		= resp->sys_image_guid;
+	device_attr->max_mr_size		= resp->max_mr_size;
+	device_attr->page_size_cap		= resp->page_size_cap;
+	device_attr->vendor_id			= resp->vendor_id;
+	device_attr->vendor_part_id		= resp->vendor_part_id;
+	device_attr->hw_ver			= resp->hw_ver;
+	device_attr->max_qp			= resp->max_qp;
+	device_attr->max_qp_wr			= resp->max_qp_wr;
+	device_attr->device_cap_flags		= resp->device_cap_flags;
+	device_attr->max_sge			= resp->max_sge;
+	device_attr->max_sge_rd			= resp->max_sge_rd;
+	device_attr->max_cq			= resp->max_cq;
+	device_attr->max_cqe			= resp->max_cqe;
+	device_attr->max_mr			= resp->max_mr;
+	device_attr->max_pd			= resp->max_pd;
+	device_attr->max_qp_rd_atom		= resp->max_qp_rd_atom;
+	device_attr->max_ee_rd_atom		= resp->max_ee_rd_atom;
+	device_attr->max_res_rd_atom		= resp->max_res_rd_atom;
+	device_attr->max_qp_init_rd_atom	= resp->max_qp_init_rd_atom;
+	device_attr->max_ee_init_rd_atom	= resp->max_ee_init_rd_atom;
+	device_attr->atomic_cap			= resp->atomic_cap;
+	device_attr->max_ee			= resp->max_ee;
+	device_attr->max_rdd			= resp->max_rdd;
+	device_attr->max_mw			= resp->max_mw;
+	device_attr->max_raw_ipv6_qp		= resp->max_raw_ipv6_qp;
+	device_attr->max_raw_ethy_qp		= resp->max_raw_ethy_qp;
+	device_attr->max_mcast_grp		= resp->max_mcast_grp;
+	device_attr->max_mcast_qp_attach	= resp->max_mcast_qp_attach;
+	device_attr->max_total_mcast_qp_attach	= resp->max_total_mcast_qp_attach;
+	device_attr->max_ah			= resp->max_ah;
+	device_attr->max_fmr			= resp->max_fmr;
+	device_attr->max_map_per_fmr		= resp->max_map_per_fmr;
+	device_attr->max_srq			= resp->max_srq;
+	device_attr->max_srq_wr			= resp->max_srq_wr;
+	device_attr->max_srq_sge		= resp->max_srq_sge;
+	device_attr->max_pkeys			= resp->max_pkeys;
+	device_attr->local_ca_ack_delay		= resp->local_ca_ack_delay;
+	device_attr->phys_port_cnt		= resp->phys_port_cnt;
+}
+
 int ibv_cmd_query_device(struct ibv_context *context,
 			 struct ibv_device_attr *device_attr,
 			 uint64_t *raw_fw_ver,
@@ -81,46 +127,51 @@ int ibv_cmd_query_device(struct ibv_context *context,
 	(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	memset(device_attr->fw_ver, 0, sizeof device_attr->fw_ver);
-	*raw_fw_ver			       = resp.fw_ver;
-	device_attr->node_guid 		       = resp.node_guid;
-	device_attr->sys_image_guid 	       = resp.sys_image_guid;
-	device_attr->max_mr_size 	       = resp.max_mr_size;
-	device_attr->page_size_cap 	       = resp.page_size_cap;
-	device_attr->vendor_id 		       = resp.vendor_id;
-	device_attr->vendor_part_id 	       = resp.vendor_part_id;
-	device_attr->hw_ver 		       = resp.hw_ver;
-	device_attr->max_qp 		       = resp.max_qp;
-	device_attr->max_qp_wr 		       = resp.max_qp_wr;
-	device_attr->device_cap_flags 	       = resp.device_cap_flags;
-	device_attr->max_sge 		       = resp.max_sge;
-	device_attr->max_sge_rd 	       = resp.max_sge_rd;
-	device_attr->max_cq 		       = resp.max_cq;
-	device_attr->max_cqe 		       = resp.max_cqe;
-	device_attr->max_mr 		       = resp.max_mr;
-	device_attr->max_pd 		       = resp.max_pd;
-	device_attr->max_qp_rd_atom 	       = resp.max_qp_rd_atom;
-	device_attr->max_ee_rd_atom 	       = resp.max_ee_rd_atom;
-	device_attr->max_res_rd_atom 	       = resp.max_res_rd_atom;
-	device_attr->max_qp_init_rd_atom       = resp.max_qp_init_rd_atom;
-	device_attr->max_ee_init_rd_atom       = resp.max_ee_init_rd_atom;
-	device_attr->atomic_cap 	       = resp.atomic_cap;
-	device_attr->max_ee 		       = resp.max_ee;
-	device_attr->max_rdd 		       = resp.max_rdd;
-	device_attr->max_mw 		       = resp.max_mw;
-	device_attr->max_raw_ipv6_qp 	       = resp.max_raw_ipv6_qp;
-	device_attr->max_raw_ethy_qp 	       = resp.max_raw_ethy_qp;
-	device_attr->max_mcast_grp 	       = resp.max_mcast_grp;
-	device_attr->max_mcast_qp_attach       = resp.max_mcast_qp_attach;
-	device_attr->max_total_mcast_qp_attach = resp.max_total_mcast_qp_attach;
-	device_attr->max_ah 		       = resp.max_ah;
-	device_attr->max_fmr 		       = resp.max_fmr;
-	device_attr->max_map_per_fmr 	       = resp.max_map_per_fmr;
-	device_attr->max_srq 		       = resp.max_srq;
-	device_attr->max_srq_wr 	       = resp.max_srq_wr;
-	device_attr->max_srq_sge 	       = resp.max_srq_sge;
-	device_attr->max_pkeys 		       = resp.max_pkeys;
-	device_attr->local_ca_ack_delay        = resp.local_ca_ack_delay;
-	device_attr->phys_port_cnt	       = resp.phys_port_cnt;
+	copy_query_dev_fields(device_attr, &resp, raw_fw_ver);
+
+	return 0;
+}
+
+int ibv_cmd_query_device_ex(struct ibv_context *context,
+			    const struct ibv_query_device_ex_input *input,
+			    struct ibv_device_attr_ex *attr, size_t attr_size,
+			    uint64_t *raw_fw_ver,
+			    struct ibv_query_device_ex *cmd,
+			    size_t cmd_core_size,
+			    size_t cmd_size,
+			    struct ibv_query_device_resp_ex *resp,
+			    size_t resp_core_size,
+			    size_t resp_size)
+{
+	int err;
+
+	if (input && input->comp_mask)
+		return EINVAL;
+
+	if (attr_size < offsetof(struct ibv_device_attr_ex, comp_mask) +
+			sizeof(attr->comp_mask))
+		return EINVAL;
+
+	if (resp_core_size < offsetof(struct ibv_query_device_resp_ex,
+				      response_length) +
+			     sizeof(resp->response_length))
+		return EINVAL;
+
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size,
+			       QUERY_DEVICE_EX, resp, resp_core_size,
+			       resp_size);
+	cmd->comp_mask = 0;
+	cmd->reserved = 0;
+	memset(attr->orig_attr.fw_ver, 0, sizeof(attr->orig_attr.fw_ver));
+	err = write(context->cmd_fd, cmd, cmd_size);
+	if (err != cmd_size)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	copy_query_dev_fields(&attr->orig_attr, &resp->base, raw_fw_ver);
+	/* Report back supported comp_mask bits. For now no comp_mask bit is
+	 * defined */
+	attr->comp_mask = resp->comp_mask & 0;
 
 	return 0;
 }
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 9f0ec69de183..3b40a0fbb80f 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -9,6 +9,7 @@ IBVERBS_1.0 {
 		ibv_get_async_event;
 		ibv_ack_async_event;
 		ibv_query_device;
+		ibv_query_device_ex;
 		ibv_query_port;
 		ibv_query_gid;
 		ibv_query_pkey;
@@ -37,6 +38,7 @@ IBVERBS_1.0 {
 		ibv_detach_mcast;
 		ibv_cmd_get_context;
 		ibv_cmd_query_device;
+		ibv_cmd_query_device_ex;
 		ibv_cmd_query_port;
 		ibv_cmd_query_gid;
 		ibv_cmd_query_pkey;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
