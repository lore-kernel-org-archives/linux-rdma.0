From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 17/26] IB/srp: Remove srp_finish_mapping
Date: Tue, 13 Oct 2015 19:11:40 +0300
Message-ID: <1444752709-15429-18-git-send-email-sagig@mellanox.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444752709-15429-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No callers left, remove it.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6d399378928d..d4a5a9b86390 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1368,16 +1368,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	return n;
 }
 
-static int srp_finish_mapping(struct srp_map_state *state,
-			      struct srp_rdma_ch *ch)
-{
-	struct srp_target_port *target = ch->target;
-	struct srp_device *dev = target->srp_host->srp_dev;
-
-	return dev->use_fast_reg ? srp_map_finish_fr(state, ch) :
-				   srp_map_finish_fmr(state, ch);
-}
-
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_rdma_ch *ch,
 			    struct scatterlist *sg, int sg_index)
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
