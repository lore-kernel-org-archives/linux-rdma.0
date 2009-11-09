From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/6]  SRP recreates qp/cq resources at reconnecting
 to target
Date: Mon, 09 Nov 2009 13:31:30 -0800
Message-ID: <4AF88A32.2000209@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030604020906040305030904"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------030604020906040305030904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Recreating qp, cq when reconnect to target instead of re-use them.
We need this so that we don't have to wait on disconnect connection

Signed-of-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------030604020906040305030904
Content-Type: text/plain;
 name="srp_1_recreate_res_at_reconnect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_1_recreate_res_at_reconnect.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index dfa14de..e44939a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -535,10 +535,10 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 
 static int srp_reconnect_target(struct srp_target_port *target)
 {
-	struct ib_qp_attr qp_attr;
 	struct srp_request *req, *tmp;
-	struct ib_wc wc;
 	int ret;
+	struct ib_cq *old_cq;
+	struct ib_qp *old_qp;
 
 	spin_lock_irq(target->scsi_host->host_lock);
 	if (target->state != SRP_TARGET_LIVE) {
@@ -557,17 +557,17 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	qp_attr.qp_state = IB_QPS_RESET;
-	ret = ib_modify_qp(target->qp, &qp_attr, IB_QP_STATE);
-	if (ret)
-		goto err;
-
-	ret = srp_init_qp(target, target->qp);
-	if (ret)
+	old_qp = target->qp;
+	old_cq = target->cq;
+	ret = srp_create_target_ib(target);
+	if (ret) {
+		target->qp = old_qp;
+		target->cq = old_cq;
 		goto err;
+	}
 
-	while (ib_poll_cq(target->cq, 1, &wc) > 0)
-		; /* nothing */
+	ib_destroy_qp(old_qp);
+	ib_destroy_cq(old_cq);
 
 	spin_lock_irq(target->scsi_host->host_lock);
 	list_for_each_entry_safe(req, tmp, &target->req_queue, list)

--------------030604020906040305030904--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
