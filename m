From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 2/6] IB/srp: Align to generic logging helpers
Date: Wed, 13 May 2015 12:35:01 +0300
Message-ID: <1431509705-16337-3-git-send-email-sagig@mellanox.com>
References: <1431509705-16337-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431509705-16337-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..667df9d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -253,7 +253,8 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
 
 static void srp_qp_event(struct ib_event *event, void *context)
 {
-	pr_debug("QP event %d\n", event->event);
+	pr_debug("QP event %s (%d)\n",
+		 ib_event_msg(event->event), event->event);
 }
 
 static int srp_init_qp(struct srp_target_port *target,
@@ -1932,17 +1933,18 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 	if (target->connected && !target->qp_in_error) {
 		if (wr_id & LOCAL_INV_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "LOCAL_INV failed with status %d\n",
-				     wc_status);
+				     "LOCAL_INV failed with status %s (%d)\n",
+				     ib_wc_status_msg(wc_status), wc_status);
 		} else if (wr_id & FAST_REG_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "FAST_REG_MR failed status %d\n",
-				     wc_status);
+				     "FAST_REG_MR failed status %s (%d)\n",
+				     ib_wc_status_msg(wc_status), wc_status);
 		} else {
 			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed %s status %d for iu %p\n",
+				     PFX "failed %s status %s (%d) for iu %p\n",
 				     send_err ? "send" : "receive",
-				     wc_status, (void *)(uintptr_t)wr_id);
+				     ib_wc_status_msg(wc_status), wc_status,
+				     (void *)(uintptr_t)wr_id);
 		}
 		queue_work(system_long_wq, &target->tl_err_work);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
