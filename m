From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 01/20] IB/core: Add flags for on demand paging support
Date: Sun,  2 Mar 2014 12:49:19 +0200
Message-ID: <1393757378-16412-2-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* Add a configuration option for enable on-demand paging support in the
  infiniband subsystem (CONFIG_INFINIBAND_ON_DEMAND_PAGING). In a later patch,
  this configuration option will select the MMU_NOTIFIER configuration option
  to enable mmu notifiers.
* Add a flag for on demand paging (ODP) support in the IB device capabilities.
* Add a flag to request ODP MR in the access flags to reg_mr.
* Fail registrations done with the ODP flag when the low-level driver doesn't
  support this.
* Change the conditions in which an MR will be writable to explicitly
  specify the access flags. This is to avoid making an MR writable just
  because it is an ODP MR.
* Add a query_odp_caps verb to query from user-space for ODP capabilities.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            | 10 ++++++
 drivers/infiniband/core/umem.c        |  8 +++--
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 63 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  5 ++-
 include/rdma/ib_verbs.h               | 28 ++++++++++++++--
 include/uapi/rdma/ib_user_verbs.h     | 18 +++++++++-
 7 files changed, 126 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 7708939..089a2c2 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -38,6 +38,16 @@ config INFINIBAND_USER_MEM
 	depends on INFINIBAND_USER_ACCESS != n
 	default y
 
+config INFINIBAND_ON_DEMAND_PAGING
+	bool "InfiniBand on-demand paging support"
+	depends on INFINIBAND_USER_MEM
+	default y
+	---help---
+	  On demand paging support for the InfiniBand subsystem.
+	  Together with driver support this allows registration of
+	  memory regions without pinning their pages, fetching the
+	  pages on demand instead.
+
 config INFINIBAND_ADDR_TRANS
 	bool
 	depends on INFINIBAND
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index a3a2e9c..1fba9d3 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -106,13 +106,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->offset    = addr & ~PAGE_MASK;
 	umem->page_size = PAGE_SIZE;
 	/*
-	 * We ask for writable memory if any access flags other than
-	 * "remote read" are set.  "Local write" and "remote write"
+	 * We ask for writable memory if any of the following
+	 * access flags are set.  "Local write" and "remote write"
 	 * obviously require write access.  "Remote atomic" can do
 	 * things like fetch and add, which will modify memory, and
 	 * "MW bind" can change permissions by binding a window.
 	 */
-	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
+	umem->writable  = !!(access &
+		(IB_ACCESS_LOCAL_WRITE   | IB_ACCESS_REMOTE_WRITE |
+		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
 
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   = 1;
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a283274..d1cefc8 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -257,5 +257,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
+IB_UVERBS_DECLARE_EX_CMD(query_odp_caps);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203e..2795d86 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -947,6 +947,22 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 
+
+	if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+		struct ib_device_attr attr;
+		ret = ib_query_device(pd->device, &attr);
+		if (ret || !(attr.device_cap_flags &
+				IB_DEVICE_ON_DEMAND_PAGING)) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+#else
+		ret = -EINVAL;
+		goto err_put;
+#endif
+	}
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1160,6 +1176,53 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+int ib_uverbs_ex_query_odp_caps(struct ib_uverbs_file *file,
+				struct ib_udata *ucore,
+				struct ib_udata *uhw)
+{
+	struct ib_uverbs_query_odp_caps		cmd;
+	struct ib_uverbs_query_odp_caps_resp	resp;
+	struct ib_device_attr			attr;
+	int err;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	if (ucore->outlen < sizeof(resp))
+		return -ENOSPC;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	ucore->inbuf += sizeof(cmd);
+	ucore->inlen -= sizeof(cmd);
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	err = ib_query_device(file->device->ib_dev, &attr);
+
+	if (err)
+		return err;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.comp_mask = 0;
+	resp.general_caps = attr.odp_caps.general_caps;
+	resp.per_transport_caps.rc_odp_caps =
+		attr.odp_caps.per_transport_caps.rc_odp_caps;
+	resp.per_transport_caps.uc_odp_caps =
+		attr.odp_caps.per_transport_caps.uc_odp_caps;
+	resp.per_transport_caps.ud_odp_caps =
+		attr.odp_caps.per_transport_caps.ud_odp_caps;
+
+	err = ib_copy_to_udata(ucore,
+			       &resp, sizeof(resp));
+	return err;
+}
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 				      const char __user *buf, int in_len,
 				      int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08219fb..a767298 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -121,7 +121,10 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *ucore,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
-	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
+	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	[IB_USER_VERBS_EX_CMD_QUERY_ODP_CAPS]	= ib_uverbs_ex_query_odp_caps,
+#endif
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index edfe0d5..129261c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -123,7 +123,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
-	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
+	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
 };
 
 enum ib_signature_prot_cap {
@@ -143,6 +144,27 @@ enum ib_atomic_cap {
 	IB_ATOMIC_GLOB
 };
 
+enum ib_odp_general_cap_bits {
+	IB_ODP_SUPPORT = 1 << 0,
+};
+
+enum ib_odp_transport_cap_bits {
+	IB_ODP_SUPPORT_SEND	= 1 << 0,
+	IB_ODP_SUPPORT_RECV	= 1 << 1,
+	IB_ODP_SUPPORT_WRITE	= 1 << 2,
+	IB_ODP_SUPPORT_READ	= 1 << 3,
+	IB_ODP_SUPPORT_ATOMIC	= 1 << 4,
+};
+
+struct ib_odp_caps {
+	uint64_t general_caps;
+	struct {
+		uint32_t  rc_odp_caps;
+		uint32_t  uc_odp_caps;
+		uint32_t  ud_odp_caps;
+	} per_transport_caps;
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -186,6 +208,7 @@ struct ib_device_attr {
 	u8			local_ca_ack_delay;
 	int			sig_prot_cap;
 	int			sig_guard_cap;
+	struct ib_odp_caps	odp_caps;
 };
 
 enum ib_mtu {
@@ -1076,7 +1099,8 @@ enum ib_access_flags {
 	IB_ACCESS_REMOTE_READ	= (1<<2),
 	IB_ACCESS_REMOTE_ATOMIC	= (1<<3),
 	IB_ACCESS_MW_BIND	= (1<<4),
-	IB_ZERO_BASED		= (1<<5)
+	IB_ZERO_BASED		= (1<<5),
+	IB_ACCESS_ON_DEMAND     = (1<<6),
 };
 
 struct ib_phys_buf {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index cbfdd4c..b8a478d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -91,7 +91,8 @@ enum {
 
 enum {
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
+	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_EX_CMD_QUERY_ODP_CAPS,
 };
 
 /*
@@ -280,6 +281,21 @@ struct ib_uverbs_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ib_uverbs_query_odp_caps {
+	__u64 comp_mask;
+};
+
+struct ib_uverbs_query_odp_caps_resp {
+	__u64 comp_mask;
+	__u64 general_caps;
+	struct {
+		__u32 rc_odp_caps;
+		__u32 uc_odp_caps;
+		__u32 ud_odp_caps;
+	} per_transport_caps;
+	__u32 reserved;
+};
+
 struct ib_uverbs_alloc_mw {
 	__u64 response;
 	__u32 pd_handle;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
