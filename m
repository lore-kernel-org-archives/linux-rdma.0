From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] IB/srp: Remove an unused argument
Date: Mon, 26 Sep 2016 12:57:10 -0700
Message-ID: <3aa07053-fc94-6ea7-83bc-0b12711c3161@sandisk.com>
References: <c5bd10df-225d-df4c-c765-97551348dbbd@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c5bd10df-225d-df4c-c765-97551348dbbd-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 513f2ec..06bb7a9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1402,7 +1402,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 static int srp_map_sg_entry(struct srp_map_state *state,
 			    struct srp_rdma_ch *ch,
-			    struct scatterlist *sg, int sg_index)
+			    struct scatterlist *sg)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
@@ -1455,7 +1455,7 @@ static int srp_map_sg_fmr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	state->fmr.end = req->fmr_list + ch->target->mr_per_cmd;
 
 	for_each_sg(scat, sg, count, i) {
-		ret = srp_map_sg_entry(state, ch, sg, i);
+		ret = srp_map_sg_entry(state, ch, sg);
 		if (ret)
 			return ret;
 	}
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
