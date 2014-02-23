From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB/srp: Fix crash when unmapping data loop
Date: Sun, 23 Feb 2014 14:19:48 +0200
Message-ID: <1393157990-25020-2-git-send-email-sagig@mellanox.com>
References: <1393157990-25020-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157990-25020-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When unmapping request data, it is unsafe automatically
decrement req->nfmr regardless of it's value since IO and
reconnect flow may run concurrently resulting in req->nfmr = -1
and falsely call ib_fmr_pool_unmap.

Fix the loop condition to to be greater then zero (which
explicitely means that FMRs were used on this request)
and only increment when needed.

This crash is easily reproduceable with SRIOV OR Connect-IB
(where FMRs are not supported)

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 529b6bc..0e20bfb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -766,8 +766,11 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		return;
 
 	pfmr = req->fmr_list;
-	while (req->nfmr--)
+
+	while (req->nfmr > 0) {
 		ib_fmr_pool_unmap(*pfmr++);
+		req->nfmr--;
+	}
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
 			scmnd->sc_data_direction);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
