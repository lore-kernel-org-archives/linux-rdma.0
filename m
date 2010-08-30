From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/5 v7] IB/srp: Introduce list_first_entry()
Date: Mon, 30 Aug 2010 21:27:40 +0200
Message-ID: <201008302127.40667.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduces the list_first_entry() macro in ib_srp, which makes the source code
slightly more descriptive. The list_first_entry() macro itself was introduced
in kernel 2.6.22.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2de894e..a2935e3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1157,7 +1157,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
 				   DMA_TO_DEVICE);
 
-	req = list_entry(target->free_reqs.next, struct srp_request, list);
+	req = list_first_entry(&target->free_reqs, struct srp_request, list);
 
 	scmnd->scsi_done     = done;
 	scmnd->result        = 0;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
