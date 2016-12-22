From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/8] qedr: ignore inline flag in read verbs
Date: Thu, 22 Dec 2016 14:40:37 +0200
Message-ID: <1482410440-2297-6-git-send-email-Ram.Amrani@cavium.com>
References: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the current implementation a read verb with IB_SEND_INLINE may be
illegally configured.
In this fix we ignore the inline bit in the case of a read verb.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index e95b19f..16bbdfe 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2630,7 +2630,9 @@ static u32 qedr_prepare_sq_rdma_data(struct qedr_dev *dev,
 	rwqe2->r_key = cpu_to_le32(rdma_wr(wr)->rkey);
 	DMA_REGPAIR_LE(rwqe2->remote_va, rdma_wr(wr)->remote_addr);
 
-	if (wr->send_flags & IB_SEND_INLINE) {
+	if (wr->send_flags & IB_SEND_INLINE &&
+	    (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
+	     wr->opcode == IB_WR_RDMA_WRITE)) {
 		u8 flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_RDMA_WQE_1ST_INLINE_FLG, 1);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
