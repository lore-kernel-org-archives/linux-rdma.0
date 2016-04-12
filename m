From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/srp: Fix a debug kernel crash
Date: Tue, 12 Apr 2016 14:39:18 -0700
Message-ID: <570D6B06.8080204@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the following BUG() is triggered against a debug
kernel:

kernel BUG at include/linux/scatterlist.h:92!
RIP: 0010:[<ffffffffa0467199>]  [<ffffffffa0467199>] srp_map_idb+0x199/0x1a0 [ib_srp]
Call Trace:
 [<ffffffffa04685fa>] srp_map_data+0x84a/0x890 [ib_srp]
 [<ffffffffa0469674>] srp_queuecommand+0x1e4/0x610 [ib_srp]
 [<ffffffff813f5a5e>] scsi_dispatch_cmd+0x9e/0x180
 [<ffffffff813f8b07>] scsi_request_fn+0x477/0x610
 [<ffffffff81298ffe>] __blk_run_queue+0x2e/0x40
 [<ffffffff81299070>] blk_delay_work+0x20/0x30
 [<ffffffff81071f07>] process_one_work+0x197/0x480
 [<ffffffff81072239>] worker_thread+0x49/0x490
 [<ffffffff810787ea>] kthread+0xea/0x100
 [<ffffffff8159b632>] ret_from_fork+0x22/0x40

Fixes: f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7672b19..30c3dfc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1503,7 +1503,7 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 
 	if (dev->use_fast_reg) {
 		state.sg = idb_sg;
-		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
+		sg_init_one(idb_sg, req->indirect_desc, idb_len);
 		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
