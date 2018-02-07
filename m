From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH] rxe: Fix structure layouts for 32/64 bit compat
Date: Wed, 7 Feb 2018 16:41:53 -0700
Message-ID: <20180207234153.GA14067@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rxe driver structure layouts have implicit padding which differs
depending on 32 bit or 64 bit mode, meaning rxe does not work if a 32
bit userspace is used on a 64 bit kernel.

They do work if the kernel and user space are the same bit width.

Since this is an ABI break change the ABI version. Unfortunately, the
userspace driver does not handle the ABI version properly, so this will
not stop any broken user spaces, but it does let us fix userspace to
work properly in future.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.h   | 6 +++++-
 include/uapi/rdma/rdma_user_rxe.h | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

This is marked RFC to pause and give some thought to the best
solution, here is my first suggestion.

If we go this way, the userspace patch would be something like:

static const struct verbs_device_ops rxe_dev_ops = {
	.name = "rxe",
-	.match_min_abi_version = 0,
-	.match_max_abi_version = INT_MAX,
+	.match_min_abi_version = (sizeof(void *) == 8?1:2),
+	.match_max_abi_version = 2,

Then 32 builds of the kernel and rdma-core would demand to both be
updated to work correctly.

I can't see any easy solution that lets existing 32 user/32 kernel
users survive unchanged while still allowing compat for 32 user/64
kernel mode.

The few places I know of that are likely to be 32 bit, like ARM cores,
already generally don't work with rxe because rxe has broken use of
the cache APIs. So I don't actually think there is a 32 bit user of
rxe..

diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index 7d232611303f40..d6cce6b6d88034 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -59,7 +59,11 @@
 #include "rxe_verbs.h"
 #include "rxe_loc.h"
 
-#define RXE_UVERBS_ABI_VERSION		(1)
+/*
+ * Version 1 and Version 2 are identical on 64 bit machines, but on 32 bit
+ * machines Version 2 has a different struct layout.
+ */
+#define RXE_UVERBS_ABI_VERSION		(sizeof(void *) == 8?1:2)
 
 #define IB_PHYS_STATE_LINK_UP		(5)
 #define IB_PHYS_STATE_LINK_DOWN		(3)
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index e3e6852b58eb45..b501deb18d8184 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -58,6 +58,8 @@ struct rxe_global_route {
 struct rxe_av {
 	__u8			port_num;
 	__u8			network_type;
+	__u16			reserved1;
+	__u32			reserved2;
 	struct rxe_global_route	grh;
 	union {
 		struct sockaddr_in	_sockaddr_in;
@@ -84,6 +86,7 @@ struct rxe_send_wr {
 			__u64	compare_add;
 			__u64	swap;
 			__u32	rkey;
+			__u32	reserved;
 		} atomic;
 		struct {
 			__u32	remote_qpn;
@@ -93,7 +96,7 @@ struct rxe_send_wr {
 		struct {
 			struct ib_mr *mr;
 			__u32        key;
-			int          access;
+			__u32        access;
 		} reg;
 	} wr;
 };
@@ -116,6 +119,7 @@ struct rxe_dma_info {
 	__u32			cur_sge;
 	__u32			num_sge;
 	__u32			sge_offset;
+	__u32			reserved;
 	union {
 		__u8		inline_data[0];
 		struct rxe_sge	sge[0];
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
