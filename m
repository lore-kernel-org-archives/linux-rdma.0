From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/7] IB/srp: Rename work request ID labels
Date: Tue, 27 Oct 2015 15:02:11 -0700
Message-ID: <562FF463.40107@sandisk.com>
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

Work request IDs in the SRP initiator driver are either a pointer or a
value that is not a valid pointer. Since the local invalidate and fast
registration work requests IDs are not used as masks drop the suffix
"mask" from their name.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
 drivers/infiniband/ulp/srp/ib_srp.h | 7 +++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c1faf70..1aa9a4c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1049,7 +1049,7 @@ static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr = {
 		.opcode		    = IB_WR_LOCAL_INV,
-		.wr_id		    = LOCAL_INV_WR_ID_MASK,
+		.wr_id		    = LOCAL_INV_WR_ID,
 		.next		    = NULL,
 		.num_sge	    = 0,
 		.send_flags	    = 0,
@@ -1325,7 +1325,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	memset(&wr, 0, sizeof(wr));
 	wr.opcode = IB_WR_FAST_REG_MR;
-	wr.wr_id = FAST_REG_WR_ID_MASK;
+	wr.wr_id = FAST_REG_WR_ID;
 	wr.wr.fast_reg.iova_start = state->base_dma_addr;
 	wr.wr.fast_reg.page_list = desc->frpl;
 	wr.wr.fast_reg.page_list_len = state->npages;
@@ -1940,11 +1940,11 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 	}
 
 	if (ch->connected && !target->qp_in_error) {
-		if (wr_id & LOCAL_INV_WR_ID_MASK) {
+		if (wr_id == LOCAL_INV_WR_ID) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
 				     "LOCAL_INV failed with status %s (%d)\n",
 				     ib_wc_status_msg(wc_status), wc_status);
-		} else if (wr_id & FAST_REG_WR_ID_MASK) {
+		} else if (wr_id == FAST_REG_WR_ID) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
 				     "FAST_REG_MR failed status %s (%d)\n",
 				     ib_wc_status_msg(wc_status), wc_status);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 3608f2e..1c6a715 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -67,10 +67,9 @@ enum {
 
 	SRP_MAX_PAGES_PER_MR	= 512,
 
-	LOCAL_INV_WR_ID_MASK	= 1,
-	FAST_REG_WR_ID_MASK	= 2,
-
-	SRP_LAST_WR_ID		= 0xfffffffcU,
+	LOCAL_INV_WR_ID		= 1,
+	FAST_REG_WR_ID		= 2,
+	SRP_LAST_WR_ID		= 3,
 };
 
 enum srp_target_state {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
