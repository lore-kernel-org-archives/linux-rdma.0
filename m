From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/8] verbs: Annoate ibv_send_wr with endian
Date: Wed, 12 Jul 2017 15:17:36 -0600
Message-ID: <1499894262-10761-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499894262-10761-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This follows the scheme of used in the wc by introducing a
transparent union in ibv_send_wr to indicate the invalidate_rkey
is in host endian.

Fixes: 32186550 ("verbs: Add be annotations to public headers")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/man/ibv_post_send.3 | 7 ++++++-
 libibverbs/verbs.h             | 9 ++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libibverbs/man/ibv_post_send.3 b/libibverbs/man/ibv_post_send.3
index ebbbb806882eca..d0ee275329d3ce 100644
--- a/libibverbs/man/ibv_post_send.3
+++ b/libibverbs/man/ibv_post_send.3
@@ -35,7 +35,12 @@ struct ibv_sge         *sg_list;                /* Pointer to the s/g array */
 int                     num_sge;                /* Size of the s/g array */
 enum ibv_wr_opcode      opcode;                 /* Operation type */
 int                     send_flags;             /* Flags of the WR properties */
-uint32_t                imm_data;               /* Immediate data (in network byte order) */
+union {
+.in +8
+__be32                  imm_data;               /* Immediate data (in network byte order) */
+uint32_t                invalidate_rkey;        /* Remote rkey to invalidate */
+.in -8
+};
 union {
 .in +8
 struct {
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 997ef248b26b62..ed251fd28c0729 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -941,7 +941,14 @@ struct ibv_send_wr {
 	int			num_sge;
 	enum ibv_wr_opcode	opcode;
 	int			send_flags;
-	__be32			imm_data;
+	/* When opcode is *_WITH_IMM: Immediate data in network byte order.
+	 * When opcode is *_INV: Stores the rkey to invalidate
+	 */
+	union
+	{
+		__be32			imm_data;
+		uint32_t		invalidate_rkey;
+	};
 	union {
 		struct {
 			uint64_t	remote_addr;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
