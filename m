From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 3/5] IB/core: Extend atomic operations
Date: Mon,  3 Nov 2014 10:02:44 +0200
Message-ID: <1415001766-8366-4-git-send-email-eli@mellanox.com>
References: <1415001766-8366-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415001766-8366-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Further enhance the extended atomic operations support as was introduced
in commit 5e80ba8ff0bd "IB/core: Add support for masked atomic operations".

1. Allow arbitrary argument sizes. The original extended atomics commit defined
64 bits arguments. This patch allows arbitrary arguments which are power of 2
bytes in size.

2. Add the option to define response for atomic operations in network order.
enum ib_atomic_cap is extended to have big endian variants.

The device attributes struct defines three new fields:

log_atomic_arg_sizes - is a bit mask which encodes which argument sizes are
supported. A set bit at location n (zero based) means an argument of size 2 ^ n
is supported.

max_fa_bit_boundary - Max fetch and add bit boundary. Multi field fetch and add
operations use a bit mask that defines bit locations where carry bit is not
passed to the next higher order bit. So, if this field has the value 64, it
means that the max value subject to fetch and add is 64 bits which means no
carry from bit 63 to 64 or from bit 127 to 128 etc.

log_max_atomic_inline - atomic arguments can be inline in the WQE or be
referenced through a memory key. This value defines the max inline argument
size possible.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 16 +++++++++++++++-
 include/rdma/ib_verbs.h              |  7 ++++++-
 include/uapi/rdma/ib_user_verbs.h    | 14 ++++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index da3fd8cdd86e..f66686e40ae6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -445,6 +445,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 
 	memset(&resp, 0, sizeof resp);
 	copy_query_dev_fields(file, &resp, &attr);
+	if (resp.atomic_cap > IB_ATOMIC_GLOB)
+		resp.atomic_cap = IB_ATOMIC_NONE;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -3281,7 +3283,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	if (cmd.comp_mask)
+	if (cmd.comp_mask & ~IB_UVERBS_EX_QUERY_DEV_MAX_MASK)
 		return -EINVAL;
 
 	err = device->query_device(device, &attr);
@@ -3292,6 +3294,18 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	copy_query_dev_fields(file, &resp.base, &attr);
 	resp.comp_mask = 0;
 
+	if (cmd.comp_mask & IB_UVERBS_EX_QUERY_DEV_MASKED_ATOMIC) {
+		resp.atomics.masked_atomic_cap = attr.masked_atomic_cap;
+		resp.atomics.log_atomic_arg_sizes = attr.log_atomic_arg_sizes;
+		resp.atomics.max_fa_bit_boundary = attr.max_fa_bit_boundary;
+		resp.atomics.log_max_atomic_inline = attr.log_max_atomic_inline;
+		resp.comp_mask |= IB_UVERBS_EX_QUERY_DEV_MASKED_ATOMIC;
+	} else {
+		resp.atomics.masked_atomic_cap = IB_ATOMIC_NONE;
+		resp.atomics.log_atomic_arg_sizes = 0;
+		resp.atomics.max_fa_bit_boundary = 0;
+		resp.atomics.log_max_atomic_inline = 0;
+	}
 	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
 	if (err)
 		return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 470a011d6fa4..7f1d20a3f4c7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -140,7 +140,9 @@ enum ib_signature_guard_cap {
 enum ib_atomic_cap {
 	IB_ATOMIC_NONE,
 	IB_ATOMIC_HCA,
-	IB_ATOMIC_GLOB
+	IB_ATOMIC_GLOB,
+	IB_ATOMIC_HCA_REPLY_BE,
+	IB_ATOMIC_GLOB_REPLY_BE,
 };
 
 struct ib_device_attr {
@@ -186,6 +188,9 @@ struct ib_device_attr {
 	u8			local_ca_ack_delay;
 	int			sig_prot_cap;
 	int			sig_guard_cap;
+	u32			log_atomic_arg_sizes; /* bit-mask of supported sizes */
+	u32			max_fa_bit_boundary;
+	u32			log_max_atomic_inline;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index ed8c3d9da42c..ec98fe636f2b 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -202,13 +202,27 @@ struct ib_uverbs_query_device_resp {
 	__u8  reserved[4];
 };
 
+enum {
+	IB_UVERBS_EX_QUERY_DEV_MASKED_ATOMIC	= 1 << 0,
+	IB_UVERBS_EX_QUERY_DEV_LAST		= 1 << 1,
+	IB_UVERBS_EX_QUERY_DEV_MAX_MASK		= IB_UVERBS_EX_QUERY_DEV_LAST - 1,
+};
+
 struct ib_uverbs_ex_query_device {
 	__u32 comp_mask;
 };
 
+struct ib_uverbs_ex_atomic_caps {
+	__u32 masked_atomic_cap;
+	__u32 log_atomic_arg_sizes; /* bit-mask of supported sizes */
+	__u32 max_fa_bit_boundary;
+	__u32 log_max_atomic_inline;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
+	struct ib_uverbs_ex_atomic_caps atomics;
 };
 
 struct ib_uverbs_query_port {
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
