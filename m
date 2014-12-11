From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 06/17] IB/core: Add support for extended query device caps
Date: Thu, 11 Dec 2014 17:04:15 +0200
Message-ID: <1418310266-9584-7-git-send-email-haggaie@mellanox.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Add extensible query device capabilities verb to allow adding new features.
ib_uverbs_ex_query_device is added and copy_query_dev_fields is used to copy
capability fields to be used by both ib_uverbs_query_device and
ib_uverbs_ex_query_device.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 124 +++++++++++++++++++++++-----------
 drivers/infiniband/core/uverbs_main.c |   3 +-
 include/rdma/ib_verbs.h               |   5 +-
 include/uapi/rdma/ib_user_verbs.h     |  14 +++-
 5 files changed, 103 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 643c08a025a5..b716b0815644 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -258,5 +258,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
+IB_UVERBS_DECLARE_EX_CMD(query_device);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5ba2a86aab6a..c7a43624c96b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -378,6 +378,52 @@ err:
 	return ret;
 }
 
+static void copy_query_dev_fields(struct ib_uverbs_file *file,
+				  struct ib_uverbs_query_device_resp *resp,
+				  struct ib_device_attr *attr)
+{
+	resp->fw_ver		= attr->fw_ver;
+	resp->node_guid		= file->device->ib_dev->node_guid;
+	resp->sys_image_guid	= attr->sys_image_guid;
+	resp->max_mr_size	= attr->max_mr_size;
+	resp->page_size_cap	= attr->page_size_cap;
+	resp->vendor_id		= attr->vendor_id;
+	resp->vendor_part_id	= attr->vendor_part_id;
+	resp->hw_ver		= attr->hw_ver;
+	resp->max_qp		= attr->max_qp;
+	resp->max_qp_wr		= attr->max_qp_wr;
+	resp->device_cap_flags	= attr->device_cap_flags;
+	resp->max_sge		= attr->max_sge;
+	resp->max_sge_rd	= attr->max_sge_rd;
+	resp->max_cq		= attr->max_cq;
+	resp->max_cqe		= attr->max_cqe;
+	resp->max_mr		= attr->max_mr;
+	resp->max_pd		= attr->max_pd;
+	resp->max_qp_rd_atom	= attr->max_qp_rd_atom;
+	resp->max_ee_rd_atom	= attr->max_ee_rd_atom;
+	resp->max_res_rd_atom	= attr->max_res_rd_atom;
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
@@ -398,47 +444,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 		return ret;
 
 	memset(&resp, 0, sizeof resp);
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
+	copy_query_dev_fields(file, &resp, &attr);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -3253,3 +3259,39 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
+
+int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
+			      struct ib_udata *ucore,
+			      struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_query_device_resp resp;
+	struct ib_uverbs_ex_query_device  cmd;
+	struct ib_device_attr attr;
+	struct ib_device *device;
+	int err;
+
+	device = file->device->ib_dev;
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.reserved)
+		return -EINVAL;
+
+	err = device->query_device(device, &attr);
+	if (err)
+		return err;
+
+	memset(&resp, 0, sizeof(resp));
+	copy_query_dev_fields(file, &resp.base, &attr);
+	resp.comp_mask = 0;
+
+	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
+	if (err)
+		return err;
+
+	return 0;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 71ab83fde472..974025028790 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -122,7 +122,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *ucore,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
-	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
+	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
+	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 470a011d6fa4..97a999f9e4d8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1662,7 +1662,10 @@ static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t
 
 static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
 {
-	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
+	size_t copy_sz;
+
+	copy_sz = min_t(size_t, len, udata->outlen);
+	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0;
 }
 
 /**
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 26daf55ff76e..e8a96071e352 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -90,8 +90,9 @@ enum {
 };
 
 enum {
+	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
+	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
 };
 
 /*
@@ -201,6 +202,17 @@ struct ib_uverbs_query_device_resp {
 	__u8  reserved[4];
 };
 
+struct ib_uverbs_ex_query_device {
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
+struct ib_uverbs_ex_query_device_resp {
+	struct ib_uverbs_query_device_resp base;
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
 struct ib_uverbs_query_port {
 	__u64 response;
 	__u8  port_num;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
