From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/3] IB/srpt: Fix the RDMA completion handlers
Date: Thu, 31 Dec 2015 09:56:43 +0100
Message-ID: <5684EDCB.30606@sandisk.com>
References: <5684ED4B.2010303@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684ED4B.2010303-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the following kernel crash is triggered when processing
an RDMA completion:

BUG: unable to handle kernel paging request at 0000000100000198
IP: [<ffffffff810a4ea2>] __lock_acquire+0xa2/0x560
Call Trace:
 [<ffffffff810a53c2>] lock_acquire+0x62/0x80
 [<ffffffff8151bd33>] _raw_spin_lock_irqsave+0x43/0x60
 [<ffffffffa04fd437>] srpt_rdma_read_done+0x57/0x120 [ib_srpt]
 [<ffffffffa0144dd3>] __ib_process_cq+0x43/0xc0 [ib_core]
 [<ffffffffa0145115>] ib_cq_poll_work+0x25/0x70 [ib_core]
 [<ffffffff8107184d>] process_one_work+0x1bd/0x460
 [<ffffffff81073148>] worker_thread+0x118/0x420
 [<ffffffff81078454>] kthread+0xe4/0x100
 [<ffffffff8151cbbf>] ret_from_fork+0x3f/0x70

Fixes: commit 59fae4deaad3 ("IB/srpt: chain RDMA READ/WRITE requests").
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 105512d..b42cf0d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1395,7 +1395,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_rdma_ch *ch = cq->cq_context;
 	struct srpt_send_ioctx *ioctx =
-		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
 	WARN_ON(ioctx->n_rdma <= 0);
 	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
@@ -1418,7 +1418,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 static void srpt_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_send_ioctx *ioctx =
-		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		pr_info("RDMA_WRITE for ioctx 0x%p failed with status %d\n",
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
