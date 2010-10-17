From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 5/5] IB/srp: Introduce list_first_entry()
Date: Sat, 16 Oct 2010 23:25:25 -0400
Message-ID: <1287285925-11710-6-git-send-email-dillowda@ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287285925-11710-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Introduces the list_first_entry() macro in ib_srp, which makes the source code
slightly more descriptive. The list_first_entry() macro itself was introduced
in kernel 2.6.22.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4df8275..9b4bc5a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1151,7 +1151,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
 				   DMA_TO_DEVICE);
 
-	req = list_entry(target->free_reqs.next, struct srp_request, list);
+	req = list_first_entry(&target->free_reqs, struct srp_request, list);
 
 	scmnd->scsi_done     = done;
 	scmnd->result        = 0;
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
