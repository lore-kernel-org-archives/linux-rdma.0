From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 04/11] IB/srp: Fix srp_map_data() error paths
Date: Fri, 22 Apr 2016 14:13:35 -0700
Message-ID: <571A93FF.8020102@sandisk.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ensure that req->nmdesc is set correctly in srp_map_sg() if mapping
fails. Avoid that mapping failure causes a memory descriptor leak.
Report srp_map_sg() failure to the caller.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2f8ab5c..1354a09 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1428,8 +1428,6 @@ static int srp_map_sg_fmr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	if (ret)
 		return ret;
 
-	req->nmdesc = state->nmdesc;
-
 	return 0;
 }
 
@@ -1454,8 +1452,6 @@ static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 			state->sg = sg_next(state->sg);
 	}
 
-	req->nmdesc = state->nmdesc;
-
 	return 0;
 }
 
@@ -1475,8 +1471,6 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 			     target->global_mr->rkey);
 	}
 
-	req->nmdesc = state->nmdesc;
-
 	return 0;
 }
 
@@ -1610,11 +1604,14 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 
 	memset(&state, 0, sizeof(state));
 	if (dev->use_fast_reg)
-		srp_map_sg_fr(&state, ch, req, scat, count);
+		ret = srp_map_sg_fr(&state, ch, req, scat, count);
 	else if (dev->use_fmr)
-		srp_map_sg_fmr(&state, ch, req, scat, count);
+		ret = srp_map_sg_fmr(&state, ch, req, scat, count);
 	else
-		srp_map_sg_dma(&state, ch, req, scat, count);
+		ret = srp_map_sg_dma(&state, ch, req, scat, count);
+	req->nmdesc = state.nmdesc;
+	if (ret < 0)
+		goto unmap;
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
@@ -1637,7 +1634,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 						!target->allow_ext_sg)) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     "Could not fit S/G list into SRP_CMD\n");
-		return -EIO;
+		ret = -EIO;
+		goto unmap;
 	}
 
 	count = min(state.ndesc, target->cmd_sg_cnt);
@@ -1655,7 +1653,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
 				  idb_len, &idb_rkey);
 		if (ret < 0)
-			return ret;
+			goto unmap;
 		req->nmdesc++;
 	} else {
 		idb_rkey = cpu_to_be32(target->global_mr->rkey);
@@ -1681,6 +1679,10 @@ map_complete:
 		cmd->buf_fmt = fmt;
 
 	return len;
+
+unmap:
+	srp_unmap_data(scmnd, ch, req);
+	return ret;
 }
 
 /*
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
