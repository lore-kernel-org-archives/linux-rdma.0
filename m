From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/7] IB/srp: Fix srp_map_data() error paths
Date: Tue, 27 Oct 2015 15:03:08 -0700
Message-ID: <562FF49C.2060009@sandisk.com>
References: <562FF404.7000504@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562FF404.7000504-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ensure that req->nmdesc is set correctly in srp_map_sg() if mapping
fails. Avoid that mapping failure causes a memory descriptor leak.
Report srp_map_sg() failure to the caller.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6d17fe2..fb6b654 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1473,7 +1473,6 @@ static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
 		}
 	}
 
-	req->nmdesc = state->nmdesc;
 	ret = 0;
 
 out:
@@ -1594,7 +1593,10 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 				   target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
-	srp_map_sg(&state, ch, req, scat, count);
+	ret = srp_map_sg(&state, ch, req, scat, count);
+	req->nmdesc = state.nmdesc;
+	if (ret < 0)
+		goto unmap;
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
@@ -1617,7 +1619,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 						!target->allow_ext_sg)) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     "Could not fit S/G list into SRP_CMD\n");
-		return -EIO;
+		ret = -EIO;
+		goto unmap;
 	}
 
 	count = min(state.ndesc, target->cmd_sg_cnt);
@@ -1635,7 +1638,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
 				  idb_len, &idb_rkey);
 		if (ret < 0)
-			return ret;
+			goto unmap;
 		req->nmdesc++;
 	} else {
 		idb_rkey = target->global_mr->rkey;
@@ -1661,6 +1664,10 @@ map_complete:
 		cmd->buf_fmt = fmt;
 
 	return len;
+
+unmap:
+	srp_unmap_data(scmnd, ch, req, true);
+	return ret;
 }
 
 /*
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
