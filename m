From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] IB/srp: Make mapping failures easier to debug
Date: Mon, 21 Nov 2016 13:57:41 -0800
Message-ID: <4b5302b8-26f3-91ad-ceab-3b48c5692e37@sandisk.com>
References: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make it easier to figure out what is going on if memory mapping
fails because more memory regions than mr_per_cmd are needed.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 81cb27f..bb9d73d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1274,8 +1274,12 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 	struct ib_pool_fmr *fmr;
 	u64 io_addr = 0;
 
-	if (state->fmr.next >= state->fmr.end)
+	if (state->fmr.next >= state->fmr.end) {
+		shost_printk(KERN_ERR, ch->target->scsi_host,
+			     PFX "Out of MRs (mr_per_cmd = %d)\n",
+			     ch->target->mr_per_cmd);
 		return -ENOMEM;
+	}
 
 	WARN_ON_ONCE(!dev->use_fmr);
 
@@ -1331,8 +1335,12 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	u32 rkey;
 	int n, err;
 
-	if (state->fr.next >= state->fr.end)
+	if (state->fr.next >= state->fr.end) {
+		shost_printk(KERN_ERR, ch->target->scsi_host,
+			     PFX "Out of MRs (mr_per_cmd = %d)\n",
+			     ch->target->mr_per_cmd);
 		return -ENOMEM;
+	}
 
 	WARN_ON_ONCE(!dev->use_fast_reg);
 
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
