From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 for-next 01/16] IB/core: Add an extended user verb to query device attributes
Date: Thu,  3 Jul 2014 11:44:14 +0300
Message-ID: <1404377069-20585-2-git-send-email-haggaie@mellanox.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a new extended verb to query device attributes. It allows
extendeding the device attributes in a forward and backward compatible way.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 120 ++++++++++++++++++++++------------
 drivers/infiniband/core/uverbs_main.c |   3 +-
 include/uapi/rdma/ib_user_verbs.h     |  10 +++
 4 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a283274..db0cf8f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -257,5 +257,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
+IB_UVERBS_DECLARE_EX_CMD(query_device);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203e..a5fb347 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -378,6 +378,55 @@ err:
 	return ret;
 }
 
+static void ib_uverbs_query_device_assign(
+		struct ib_uverbs_query_device_resp *resp,
+		struct ib_device_attr *attr,
+		struct ib_uverbs_file *file)
+{
+	memset(resp, 0, sizeof(*resp));
+
+	resp->fw_ver			= attr->fw_ver;
+	resp->node_guid			= file->device->ib_dev->node_guid;
+	resp->sys_image_guid		= attr->sys_image_guid;
+	resp->max_mr_size		= attr->max_mr_size;
+	resp->page_size_cap		= attr->page_size_cap;
+	resp->vendor_id			= attr->vendor_id;
+	resp->vendor_part_id		= attr->vendor_part_id;
+	resp->hw_ver			= attr->hw_ver;
+	resp->max_qp			= attr->max_qp;
+	resp->max_qp_wr			= attr->max_qp_wr;
+	resp->device_cap_flags		= attr->device_cap_flags;
+	resp->max_sge			= attr->max_sge;
+	resp->max_sge_rd		= attr->max_sge_rd;
+	resp->max_cq			= attr->max_cq;
+	resp->max_cqe			= attr->max_cqe;
+	resp->max_mr			= attr->max_mr;
+	resp->max_pd			= attr->max_pd;
+	resp->max_qp_rd_atom		= attr->max_qp_rd_atom;
+	resp->max_ee_rd_atom		= attr->max_ee_rd_atom;
+	resp->max_res_rd_atom		= attr->max_res_rd_atom;
+	resp->max_qp_init_rd_atom	= attr->max_qp_init_rd_atom;
+	resp->max_ee_init_rd_atom	= attr->max_ee_init_rd_atom;
+	resp->atomic_cap		= attr->atomic_cap;
+	resp->max_ee			= attr->max_ee;
+	resp->max_rdd			= attr->max_rdd;
+	resp->max_mw			= attr->max_mw;
+	resp->max_raw_ipv6_qp		= attr->max_raw_ipv6_qp;
+	resp->max_raw_ethy_qp		= attr->max_raw_ethy_qp;
+	resp->max_mcast_grp		= attr->max_mcast_grp;
+	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
+	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
+	resp->max_ah			= attr->max_ah;
+	resp->max_fmr			= attr->max_fmr;
+	resp->max_map_per_fmr		= attr->max_map_per_fmr;
+	resp->max_srq			= attr->max_srq;
+	resp->max_srq_wr		= attr->max_srq_wr;
+	resp->max_srq_sge		= attr->max_srq_sge;
+	resp->max_pkeys			= attr->max_pkeys;
+	resp->local_ca_ack_delay	= attr->local_ca_ack_delay;
+	resp->phys_port_cnt		= file->device->ib_dev->phys_port_cnt;
+}
+
 ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 			       const char __user *buf,
 			       int in_len, int out_len)
@@ -397,48 +446,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	memset(&resp, 0, sizeof resp);
-
-	resp.fw_ver 		       = attr.fw_ver;
-	resp.node_guid 		       = file->device->ib_dev->node_guid;
-	resp.sys_image_guid 	       = attr.sys_image_guid;
-	resp.max_mr_size 	       = attr.max_mr_size;
-	resp.page_size_cap 	       = attr.page_size_cap;
-	resp.vendor_id 		       = attr.vendor_id;
-	resp.vendor_part_id 	       = attr.vendor_part_id;
-	resp.hw_ver 		       = attr.hw_ver;
-	resp.max_qp 		       = attr.max_qp;
-	resp.max_qp_wr 		       = attr.max_qp_wr;
-	resp.device_cap_flags 	       = attr.device_cap_flags;
-	resp.max_sge 		       = attr.max_sge;
-	resp.max_sge_rd 	       = attr.max_sge_rd;
-	resp.max_cq 		       = attr.max_cq;
-	resp.max_cqe 		       = attr.max_cqe;
-	resp.max_mr 		       = attr.max_mr;
-	resp.max_pd 		       = attr.max_pd;
-	resp.max_qp_rd_atom 	       = attr.max_qp_rd_atom;
-	resp.max_ee_rd_atom 	       = attr.max_ee_rd_atom;
-	resp.max_res_rd_atom 	       = attr.max_res_rd_atom;
-	resp.max_qp_init_rd_atom       = attr.max_qp_init_rd_atom;
-	resp.max_ee_init_rd_atom       = attr.max_ee_init_rd_atom;
-	resp.atomic_cap 	       = attr.atomic_cap;
-	resp.max_ee 		       = attr.max_ee;
-	resp.max_rdd 		       = attr.max_rdd;
-	resp.max_mw 		       = attr.max_mw;
-	resp.max_raw_ipv6_qp 	       = attr.max_raw_ipv6_qp;
-	resp.max_raw_ethy_qp 	       = attr.max_raw_ethy_qp;
-	resp.max_mcast_grp 	       = attr.max_mcast_grp;
-	resp.max_mcast_qp_attach       = attr.max_mcast_qp_attach;
-	resp.max_total_mcast_qp_attach = attr.max_total_mcast_qp_attach;
-	resp.max_ah 		       = attr.max_ah;
-	resp.max_fmr 		       = attr.max_fmr;
-	resp.max_map_per_fmr 	       = attr.max_map_per_fmr;
-	resp.max_srq 		       = attr.max_srq;
-	resp.max_srq_wr 	       = attr.max_srq_wr;
-	resp.max_srq_sge 	       = attr.max_srq_sge;
-	resp.max_pkeys 		       = attr.max_pkeys;
-	resp.local_ca_ack_delay        = attr.local_ca_ack_delay;
-	resp.phys_port_cnt	       = file->device->ib_dev->phys_port_cnt;
+	ib_uverbs_query_device_assign(&resp, &attr, file);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -3158,3 +3166,31 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
+
+int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
+			      struct ib_udata *ucore,
+			      struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_query_device_resp resp;
+	struct ib_uverbs_ex_query_device cmd;
+	struct ib_device_attr attr;
+	int err;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	memset(&resp, 0, sizeof(resp));
+	err = ib_query_device(file->device->ib_dev, &attr);
+	if (err)
+		return err;
+
+	ib_uverbs_query_device_assign(&resp.base, &attr, file);
+
+	resp.comp_mask = 0;
+
+	err = ib_copy_to_udata(ucore,
+			       &resp, sizeof(resp));
+
+	return err;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08219fb..b7d3c3a 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -121,7 +121,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *ucore,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
-	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
+	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
+	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index cbfdd4c..03052b4 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -90,6 +90,7 @@ enum {
 };
 
 enum {
+	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
 };
@@ -798,6 +799,15 @@ struct ib_uverbs_destroy_flow  {
 	__u32 flow_handle;
 };
 
+struct ib_uverbs_ex_query_device {
+	__u64 comp_mask;
+};
+
+struct ib_uverbs_ex_query_device_resp {
+	struct ib_uverbs_query_device_resp base;
+	__u64 comp_mask;
+};
+
 struct ib_uverbs_create_srq {
 	__u64 response;
 	__u64 user_handle;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
