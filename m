From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Wed, 19 Aug 2015 18:37:32 +0200
Message-ID: <1440002254-795-2-git-send-email-hch@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440002254-795-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have many WR opcodes that are only supported in kernel space
and/or require optional information to be copied into the WR
structure.  Reject all those not explicitly handled so that we
can't pass invalid information to drivers.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a15318a..f9f3921 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2372,6 +2372,12 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		next->send_flags = user_wr->send_flags;
 
 		if (is_ud) {
+			if (next->opcode != IB_WR_SEND &&
+			    next->opcode != IB_WR_SEND_WITH_IMM) {
+				ret = -EINVAL;
+				goto out_put;
+			}
+
 			next->wr.ud.ah = idr_read_ah(user_wr->wr.ud.ah,
 						     file->ucontext);
 			if (!next->wr.ud.ah) {
@@ -2413,7 +2419,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				next->wr.atomic.rkey = user_wr->wr.atomic.rkey;
 				break;
 			default:
-				break;
+				ret = -EINVAL;
+				goto out_put;
 			}
 		}
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
