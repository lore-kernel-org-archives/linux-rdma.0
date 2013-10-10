From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: temporarily disable create_flow/destroy_flow uverbs
Date: Thu, 10 Oct 2013 11:10:55 +0200
Message-ID: <1381396255-13005-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

create_flow/destroy_flow uverbs are under review and should
be considered too experimental at this point.

To not expose to userspace such experimental feature,
the data structure and code is temporarily disabled for v3.12.

The feature will be enabled after proper cleanup for v3.13.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---

Or,
You will probably don't like this patch ... but I think they're too many
reasons to not push create_flow/destroy_flow uverbs in its current form
for v3.12.
This patch is short, simpler so it's a good candidate for v3.12.
Pushing all the other "important" ones is probably going to be
badly seen by Linus.

Regards.

 drivers/infiniband/core/uverbs.h      | 2 ++
 drivers/infiniband/core/uverbs_cmd.c  | 4 ++++
 drivers/infiniband/core/uverbs_main.c | 6 ++++++
 drivers/infiniband/hw/mlx4/main.c     | 2 ++
 include/uapi/rdma/ib_user_verbs.h     | 6 ++++++
 5 files changed, 20 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d040b87..45602e6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -217,7 +217,9 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
+#if 0
 IB_UVERBS_DECLARE_CMD(create_flow);
 IB_UVERBS_DECLARE_CMD(destroy_flow);
+#endif
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f2b81b9..805e613 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -54,7 +54,9 @@ static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
 static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
 static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
+#if 0
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
+#endif
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
@@ -2599,6 +2601,7 @@ out_put:
 	return ret ? ret : in_len;
 }
 
+#if 0
 static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
@@ -2824,6 +2827,7 @@ ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
+#endif
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 				struct ib_uverbs_create_xsrq *cmd,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 75ad86c..d78e013 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -115,8 +115,10 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
+#if 0
 	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
 	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
+#endif
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -605,6 +607,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
 		return -ENOSYS;
 
+#if 0
 	if (hdr.command >= IB_USER_VERBS_CMD_THRESHOLD) {
 		struct ib_uverbs_cmd_hdr_ex hdr_ex;
 
@@ -621,6 +624,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						     (hdr_ex.out_words +
 						      hdr_ex.provider_out_words) * 4);
 	} else {
+#endif
 		if (hdr.in_words * 4 != count)
 			return -EINVAL;
 
@@ -628,7 +632,9 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						     buf + sizeof(hdr),
 						     hdr.in_words * 4,
 						     hdr.out_words * 4);
+#if 0
 	}
+#endif
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d6c5a73..c2dc4aa 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1691,9 +1691,11 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
 
+#if 0
 		ibdev->ib_dev.uverbs_cmd_mask	|=
 			(1ull << IB_USER_VERBS_CMD_CREATE_FLOW) |
 			(1ull << IB_USER_VERBS_CMD_DESTROY_FLOW);
+#endif
 	}
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0b233c5..4347c30 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -87,8 +87,10 @@ enum {
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
 	IB_USER_VERBS_CMD_OPEN_QP,
+#if 0
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW
+#endif
 };
 
 /*
@@ -126,6 +128,7 @@ struct ib_uverbs_cmd_hdr {
 	__u16 out_words;
 };
 
+#if 0
 struct ib_uverbs_cmd_hdr_ex {
 	__u32 command;
 	__u16 in_words;
@@ -134,6 +137,7 @@ struct ib_uverbs_cmd_hdr_ex {
 	__u16 provider_out_words;
 	__u32 cmd_hdr_reserved;
 };
+#endif
 
 struct ib_uverbs_get_context {
 	__u64 response;
@@ -696,6 +700,7 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
+#if 0
 struct ib_kern_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
@@ -780,6 +785,7 @@ struct ib_uverbs_destroy_flow  {
 	__u32 comp_mask;
 	__u32 flow_handle;
 };
+#endif
 
 struct ib_uverbs_create_srq {
 	__u64 response;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
