From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 1/8] IB/core: re-enable create_flow/destroy_flow uverbs
Date: Wed, 30 Oct 2013 11:52:44 +0200
Message-ID: <1383126771-7658-2-git-send-email-matanb@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit revert "IB/core: Temporarily disable create_flow/destroy_flow uverbs"
(commit d3bebb918d78755da505f56727cdde2d9c8adbe2).
Since the uverbs extensions functionality was experimental for v3.12,
this patch re-enables the support for them and flow-steering
for v3.13.
The following patches in this series will apply the suggested fixes.


Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            | 11 -----------
 drivers/infiniband/core/uverbs.h      |  2 --
 drivers/infiniband/core/uverbs_cmd.c  |  4 ----
 drivers/infiniband/core/uverbs_main.c |  6 ------
 drivers/infiniband/hw/mlx4/main.c     |  2 --
 include/uapi/rdma/ib_user_verbs.h     |  6 ------
 6 files changed, 31 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b84791f..5ceda71 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -31,17 +31,6 @@ config INFINIBAND_USER_ACCESS
 	  libibverbs, libibcm and a hardware driver library from
 	  <http://www.openfabrics.org/git/>.
 
-config INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
-       bool "Experimental and unstable ABI for userspace access to flow steering verbs"
-       depends on INFINIBAND_USER_ACCESS
-       depends on STAGING
-	---help---
-	  The final ABI for userspace access to flow steering verbs
-	  has not been defined.  To use the current ABI, *WHICH WILL
-	  CHANGE IN THE FUTURE*, say Y here.
-
-	  If unsure, say N.
-
 config INFINIBAND_USER_MEM
 	bool
 	depends on INFINIBAND_USER_ACCESS != n
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d8f9c6c..d040b87 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -217,9 +217,7 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 IB_UVERBS_DECLARE_CMD(create_flow);
 IB_UVERBS_DECLARE_CMD(destroy_flow);
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5bb2a82d..ba207e1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -54,9 +54,7 @@ static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
 static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
 static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
@@ -2604,7 +2602,6 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
@@ -2830,7 +2827,6 @@ ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 				struct ib_uverbs_create_xsrq *cmd,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2df31f6..75ad86c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -115,10 +115,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
 	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -607,7 +605,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
 		return -ENOSYS;
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	if (hdr.command >= IB_USER_VERBS_CMD_THRESHOLD) {
 		struct ib_uverbs_cmd_hdr_ex hdr_ex;
 
@@ -624,7 +621,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						     (hdr_ex.out_words +
 						      hdr_ex.provider_out_words) * 4);
 	} else {
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 		if (hdr.in_words * 4 != count)
 			return -EINVAL;
 
@@ -632,9 +628,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						     buf + sizeof(hdr),
 						     hdr.in_words * 4,
 						     hdr.out_words * 4);
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	}
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f061264..d6c5a73 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1691,11 +1691,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 		ibdev->ib_dev.uverbs_cmd_mask	|=
 			(1ull << IB_USER_VERBS_CMD_CREATE_FLOW) |
 			(1ull << IB_USER_VERBS_CMD_DESTROY_FLOW);
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 	}
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index e3ddd86..0b233c5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -87,10 +87,8 @@ enum {
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
 	IB_USER_VERBS_CMD_OPEN_QP,
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 };
 
 /*
@@ -128,7 +126,6 @@ struct ib_uverbs_cmd_hdr {
 	__u16 out_words;
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 struct ib_uverbs_cmd_hdr_ex {
 	__u32 command;
 	__u16 in_words;
@@ -137,7 +134,6 @@ struct ib_uverbs_cmd_hdr_ex {
 	__u16 provider_out_words;
 	__u32 cmd_hdr_reserved;
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 struct ib_uverbs_get_context {
 	__u64 response;
@@ -700,7 +696,6 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 struct ib_kern_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
@@ -785,7 +780,6 @@ struct ib_uverbs_destroy_flow  {
 	__u32 comp_mask;
 	__u32 flow_handle;
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 struct ib_uverbs_create_srq {
 	__u64 response;
-- 
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
