From: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH libibverbs 3/3] Add Send with invalidate support
Date: Thu,  5 Feb 2015 13:10:37 +0200
Message-ID: <1423134637-14438-4-git-send-email-majd@mellanox.com>
References: <1423134637-14438-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423134637-14438-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Send with invalidate can be used to invalidate a remote memory region or memory
window. The complete details are specified in the InfiniBand Architecture
Specifications, section 9.4.1.1.

According to the specs, the following objects can be invalidated:

1. Memory Window type 2
2. Physical MR
3. Fast register MR

The invalidation is done by posting a send work request, where the opcode is
IBV_WR_SEND_WITH_INV and the immediate data contain's the R_key.

Upon success, the responder's work completion will contain the invalidated R_key
in it's immediate data.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |   11 ++++++++---
 man/ibv_post_send.3        |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index dcee050..b9a930f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -294,7 +294,8 @@ enum ibv_wc_opcode {
 
 enum ibv_wc_flags {
 	IBV_WC_GRH		= 1 << 0,
-	IBV_WC_WITH_IMM		= 1 << 1
+	IBV_WC_WITH_IMM		= 1 << 1,
+	IBV_WC_WITH_INV		= 1 << 2
 };
 
 struct ibv_wc {
@@ -303,7 +304,10 @@ struct ibv_wc {
 	enum ibv_wc_opcode	opcode;
 	uint32_t		vendor_err;
 	uint32_t		byte_len;
-	uint32_t		imm_data;	/* in network byte order */
+	/* When (wc_flags & IBV_WC_WITH_IMM): Immediate data (network byte order).
+	 * When (wc_flags & IBV_WC_WITH_INV): Stores the invalidated R_Key.
+	 */
+	uint32_t		imm_data;
 	uint32_t		qp_num;
 	uint32_t		src_qp;
 	int			wc_flags;
@@ -636,7 +640,8 @@ enum ibv_wr_opcode {
 	IBV_WR_ATOMIC_CMP_AND_SWP,
 	IBV_WR_ATOMIC_FETCH_AND_ADD,
 	IBV_WR_LOCAL_INV,
-	IBV_WR_BIND_MW
+	IBV_WR_BIND_MW,
+	IBV_WR_SEND_WITH_INV
 };
 
 enum ibv_send_flags {
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index 0d599ad..891cf4a 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -115,6 +115,7 @@ IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X
 IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X
 IBV_WR_LOCAL_INV            |            |     X      |     X
 IBV_WR_BIND_MW              |            |     X      |     X
+IBV_WR_SEND_WITH_INV        |            |     X      |     X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
