From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ofa-general][PATCH 1/4] SRP fail-over faster
Date: Mon, 12 Oct 2009 15:56:51 -0700
Message-ID: <4AD3B433.7040803@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080908030403050801070704"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080908030403050801070704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------080908030403050801070704
Content-Type: message/rfc822;
 name="[ofa-general][PATCH 1/4] SRP fail-over faster,.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[ofa-general][PATCH 1/4] SRP fail-over faster,.eml"

Message-ID: <4AD3B1CD.1010106-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 12 Oct 2009 15:46:37 -0700
From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: OF General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
CC: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ofa-general][PATCH 1/4] SRP fail-over faster,
Content-Type: multipart/mixed;
 boundary="------------050408070809030801040300"

This is a multi-part message in MIME format.
--------------050408070809030801040300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Recreating qp, cq at reconnect instead of re-use them. We need this so 
that we don't have to wait on disconnect connection

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>



--------------050408070809030801040300
Content-Type: text/plain;
 name="srp_1_recreate_at_reconnect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_1_recreate_at_reconnect.patch"

---
 drivers/infiniband/ulp/srp/ib_srp.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
@@ -537,10 +537,10 @@ static void srp_reset_req(struct srp_tar
 
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
@@ -559,17 +559,17 @@ static int srp_reconnect_target(struct s
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

--------------050408070809030801040300--


--------------080908030403050801070704--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
