From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 06/28] i40iw: Avoid gcc warning -Wint-to-pointer-cast
Date: Mon,  5 Sep 2016 15:07:56 -0600
Message-ID: <1473109698-31408-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A u64 value needs to be casted to uintptr_t before being converted
back into a pointer, otherwise gcc produces warning on a 32 bit
build.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libi40iw/src/i40iw_uverbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libi40iw/src/i40iw_uverbs.c b/libi40iw/src/i40iw_uverbs.c
index da23e4c9f413..db69b66c1e90 100644
--- a/libi40iw/src/i40iw_uverbs.c
+++ b/libi40iw/src/i40iw_uverbs.c
@@ -858,7 +858,7 @@ int i40iw_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr, struct ibv
 				info.op_type = I40IW_OP_TYPE_SEND;
 
 			if (ib_wr->send_flags & IBV_SEND_INLINE) {
-				info.op.inline_send.data = (void *)ib_wr->sg_list[0].addr;
+			  info.op.inline_send.data = (void *)(uintptr_t)ib_wr->sg_list[0].addr;
 				info.op.inline_send.len = ib_wr->sg_list[0].length;
 				ret = iwuqp->qp.ops.iw_inline_send(&iwuqp->qp, &info,
 								   ib_wr->wr.rdma.rkey, false);
@@ -881,7 +881,7 @@ int i40iw_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr, struct ibv
 			info.op_type = I40IW_OP_TYPE_RDMA_WRITE;
 
 			if (ib_wr->send_flags & IBV_SEND_INLINE) {
-				info.op.inline_rdma_write.data = (void *)ib_wr->sg_list[0].addr;
+			  info.op.inline_rdma_write.data = (void *)(uintptr_t)ib_wr->sg_list[0].addr;
 				info.op.inline_rdma_write.len = ib_wr->sg_list[0].length;
 				info.op.inline_rdma_write.rem_addr.tag_off = ib_wr->wr.rdma.remote_addr;
 				info.op.inline_rdma_write.rem_addr.len = ib_wr->sg_list->length;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
