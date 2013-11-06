From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for -next v2 7/7] IB/core: re-enable create_flow/destroy_flow uverbs
Date: Wed,  6 Nov 2013 23:21:50 +0100
Message-ID: <2bf5ffec000afc2c3cc4c783b498a4d9eb71d210.1383773832.git.ydroneaud@opteya.com>
References: <cover.1383773832.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This commit revert "IB/core: Temporarily disable create_flow/destroy_flow uverbs"
(commit d3bebb918d78755da505f56727cdde2d9c8adbe2).
Since the uverbs extensions functionality was experimental for v3.12,
this patch re-enables the support for them and flow-steering
for v3.13.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            | 11 -----------
 drivers/infiniband/core/uverbs.h      |  4 ----
 drivers/infiniband/core/uverbs_cmd.c  |  4 ----
 drivers/infiniband/core/uverbs_main.c |  5 -----
 drivers/infiniband/hw/mlx4/main.c     |  2 --
 include/uapi/rdma/ib_user_verbs.h     |  6 ------
 6 files changed, 32 deletions(-)

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
index 24adccb..bdc842e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -242,8 +242,6 @@ IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
-
 #define IB_UVERBS_DECLARE_EX_CMD(name)				\
 	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
 				struct ib_udata *ucore,		\
@@ -252,6 +250,4 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
-
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8ea9aa5..e35877d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -54,9 +54,7 @@ static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
 static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
 static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 /*
  * The ib_uobject locking scheme is as follows:
@@ -2593,7 +2591,6 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
@@ -2821,7 +2818,6 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 
 	return ret ? ret : 0;
 }
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 				struct ib_uverbs_create_xsrq *cmd,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 189d99e..3438694 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -117,14 +117,12 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *ucore,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 static void ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device);
@@ -633,8 +631,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
-
 	} else if (flags == IB_USER_VERBS_CMD_FLAG_EXTENDED) {
 		__u32 command;
 
@@ -701,7 +697,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 
 		return written_count;
 	}
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4be29fe..1aad9b3 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1691,11 +1691,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 		ibdev->ib_dev.uverbs_ex_cmd_mask	|=
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 	}
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 6ace125..cbfdd4c 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -89,12 +89,10 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP,
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 enum {
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -137,14 +135,12 @@ struct ib_uverbs_cmd_hdr {
 	__u16 out_words;
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 struct ib_uverbs_ex_cmd_hdr {
 	__u64 response;
 	__u16 provider_in_words;
 	__u16 provider_out_words;
 	__u32 cmd_hdr_reserved;
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 struct ib_uverbs_get_context {
 	__u64 response;
@@ -707,7 +703,6 @@ struct ib_uverbs_detach_mcast {
 	__u64 driver_data[0];
 };
 
-#ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 struct ib_uverbs_flow_spec_hdr {
 	__u32 type;
 	__u16 size;
@@ -802,7 +797,6 @@ struct ib_uverbs_destroy_flow  {
 	__u32 comp_mask;
 	__u32 flow_handle;
 };
-#endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
 
 struct ib_uverbs_create_srq {
 	__u64 response;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
