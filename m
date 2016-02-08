From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 1/7] Update ibv_post_send manual page
Date: Mon,  8 Feb 2016 14:43:16 +0200
Message-ID: <1454935402-15192-2-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update man page to:
- Align the ibv_send_wr structure according to the infiniband/verbs.h
- Include IBV_QPT_XRC_SEND supported opcodes.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ibv_post_send.3 | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index eeea078..26bbd06 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -60,8 +60,18 @@ uint32_t        remote_qkey;    /* Q_Key number of the destination QP */
 } ud;
 .in -8
 } wr;
+union {
+.in +8
+struct {
+.in +8
+uint32_t remote_srqn;            /* Number of the remote SRQ */
+.in -8
+} xrc;
+.in -8
+} qp_type;
 .in -8
 };
+.fi
 .sp
 .nf
 struct ibv_sge {
@@ -76,15 +86,15 @@ uint32_t                lkey;                   /* Key of the local Memory Regio
 Each QP Transport Service Type supports a specific set of opcodes, as shown in the following table:
 .PP
 .nf
-OPCODE                      | IBV_QPT_UD | IBV_QPT_UC | IBV_QPT_RC
+OPCODE                      | IBV_QPT_UD | IBV_QPT_UC | IBV_QPT_RC | IBV_QPT_XRC_SEND
 \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-\-+\-\-\-\-\-\-\-\-\-\-\-
-IBV_WR_SEND                 |     X      |     X      |     X
-IBV_WR_SEND_WITH_IMM        |     X      |     X      |     X
-IBV_WR_RDMA_WRITE           |            |     X      |     X
-IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X
-IBV_WR_RDMA_READ            |            |            |     X
-IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X
-IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X
+IBV_WR_SEND                 |     X      |     X      |     X     |     X
+IBV_WR_SEND_WITH_IMM        |     X      |     X      |     X     |     X
+IBV_WR_RDMA_WRITE           |            |     X      |     X     |     X
+IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X      |     X     |     X
+IBV_WR_RDMA_READ            |            |            |     X     |     X
+IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X     |     X
+IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X     |     X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It is either 0 or the bitwise \s-1OR\s0 of one or more of the following flags:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
