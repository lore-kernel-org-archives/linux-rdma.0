From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] Add support for extended query device capabilities
Date: Thu, 27 Aug 2015 18:22:33 +0300
Message-ID: <1440688955-7709-2-git-send-email-haggaie@mellanox.com>
References: <1440688955-7709-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440688955-7709-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the verb ibv_query_device_ex which is extensible and allows following
commits to add new features to define additional properties.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |   3 +-
 examples/devinfo.c            |  16 ++++--
 include/infiniband/driver.h   |   9 ++++
 include/infiniband/kern-abi.h |  26 +++++++++-
 include/infiniband/verbs.h    |  28 ++++++++++
 man/ibv_query_device_ex.3     |  47 +++++++++++++++++
 src/cmd.c                     | 118 ++++++++++++++++++++++++++++--------------
 src/libibverbs.map            |   2 +
 8 files changed, 202 insertions(+), 47 deletions(-)
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
index afa8c853868f..95e8f83753ca 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -208,6 +208,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
 	struct ibv_device_attr device_attr;
+	struct ibv_device_attr_ex attrx;
 	struct ibv_port_attr port_attr;
 	int rc = 0;
 	uint8_t port;
@@ -219,11 +220,18 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		rc = 1;
 		goto cleanup;
 	}
-	if (ibv_query_device(ctx, &device_attr)) {
-		fprintf(stderr, "Failed to query device props\n");
-		rc = 2;
-		goto cleanup;
+
+	if (ibv_query_device_ex(ctx, &attrx)) {
+		attrx.comp_mask = 0;
+		if (ibv_query_device(ctx, &device_attr)) {
+			fprintf(stderr, "Failed to query device props\n");
+			rc = 2;
+			goto cleanup;
+		}
+	} else {
+		device_attr = attrx.orig_attr;
 	}
+
 	if (ib_port && ib_port > device_attr.phys_port_cnt) {
 		fprintf(stderr, "Invalid port requested for device\n");
 		/* rc = 3 is taken by failure to clean up */
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5cc092bf9bd5..b78093ae6a8e 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -105,6 +105,15 @@ int ibv_cmd_query_device(struct ibv_context *context,
 			 struct ibv_device_attr *device_attr,
 			 uint64_t *raw_fw_ver,
 			 struct ibv_query_device *cmd, size_t cmd_size);
+int ibv_cmd_query_device_ex(struct ibv_context *context,
+			    struct ibv_device_attr_ex *attr,
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
index 91b45d837239..af2a1bebf683 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -101,12 +101,20 @@ enum {
 
 #define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul
 
+/* use this mask for creating extended commands that
+   correspond to old commands */
+#define IB_USER_VERBS_CMD_EXTENDED_MASK \
+	(IB_USER_VERBS_CMD_FLAG_EXTENDED << \
+	 IB_USER_VERBS_CMD_FLAGS_SHIFT)
+
 
 enum {
 	IB_USER_VERBS_CMD_CREATE_FLOW = (IB_USER_VERBS_CMD_FLAG_EXTENDED <<
 					 IB_USER_VERBS_CMD_FLAGS_SHIFT) +
 					IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW
+	IB_USER_VERBS_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+						IB_USER_VERBS_CMD_QUERY_DEVICE,
 };
 
 /*
@@ -240,6 +248,19 @@ struct ibv_query_device_resp {
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
+	__u64 reserved[3];
+};
+
 struct ibv_query_port {
 	__u32 command;
 	__u16 in_words;
@@ -1001,7 +1022,8 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
 	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1
+	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
+	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 28e1586b0c96..ff806bf8555d 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -168,6 +168,16 @@ struct ibv_device_attr {
 	uint8_t			phys_port_cnt;
 };
 
+struct ibv_device_attr_ex {
+	struct ibv_device_attr	orig_attr;
+	uint32_t		comp_mask;
+};
+
+struct ibv_device_attr_ex_resp {
+	struct ibv_device_attr	orig_attr;
+	uint32_t		comp_mask;
+};
+
 enum ibv_mtu {
 	IBV_MTU_256  = 1,
 	IBV_MTU_512  = 2,
@@ -977,6 +987,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_device_ex)(struct ibv_context *context,
+			       struct ibv_device_attr_ex *attr);
 	int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
 	int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
 	struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
@@ -1400,6 +1412,22 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_query_device_ex - Get extended device properties
+ */
+static inline int
+ibv_query_device_ex(struct ibv_context *context,
+		    struct ibv_device_attr_ex *attr)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, query_device_ex);
+	if (!vctx || !vctx->query_device_ex)
+		return -ENOSYS;
+
+	return vctx->query_device_ex(context, attr);
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
index 45ea06ff4705..47f1acd33d68 100644
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
@@ -81,46 +127,38 @@ int ibv_cmd_query_device(struct ibv_context *context,
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
+			    struct ibv_device_attr_ex *attr,
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
+	copy_query_dev_fields(&attr->orig_attr,
+			      (struct ibv_query_device_resp *)resp,
+			      raw_fw_ver);
+	attr->comp_mask = 0;
 
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
