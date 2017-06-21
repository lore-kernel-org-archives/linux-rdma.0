From: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: don't use WR keys/addrs for 0 byte reads
Date: Wed, 21 Jun 2017 19:55:43 +0530
Message-ID: <1498055143-15035-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, venkatesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Only use the read sge lkey/addr and the remote rkey/addr if the
length of the read is not zero. Otherwise the read response might
be treated as the RTR read response and not delivered to the
application. Or worse Terminator hardware will fail a 0B read
if the STAG is 0 even if the read length is 0.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 8e4154b..dacdfb5 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -570,7 +570,7 @@ static int build_rdma_read(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 {
 	if (wr->num_sge > 1)
 		return -EINVAL;
-	if (wr->num_sge) {
+	if (wr->num_sge && wr->sg_list[0].length) {
 		wqe->read.stag_src = cpu_to_be32(rdma_wr(wr)->rkey);
 		wqe->read.to_src_hi = cpu_to_be32((u32)(rdma_wr(wr)->remote_addr
 							>> 32));
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
