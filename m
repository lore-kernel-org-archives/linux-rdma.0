From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/8] IB/srp: Add srp_terminate_io()
Date: Tue, 20 Aug 2013 14:45:11 +0200
Message-ID: <521364D7.3040007@acm.org>
References: <521363EA.8080906@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521363EA.8080906-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Finish all outstanding I/O requests after fast_io_fail_tmo expired,
which speeds up failover in a multipath setup. This patch is a
reworked version of a patch from Sebastian Riemer.

Reported-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index de49088..37dd3fb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -688,17 +688,29 @@ static void srp_free_req(struct srp_target_port *target,
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
-static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
+static void srp_finish_req(struct srp_target_port *target,
+			   struct srp_request *req, int result)
 {
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
 
 	if (scmnd) {
 		srp_free_req(target, req, scmnd, 0);
-		scmnd->result = DID_RESET << 16;
+		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 	}
 }
 
+static void srp_terminate_io(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+	int i;
+
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
+		srp_finish_req(target, req, DID_TRANSPORT_FAILFAST << 16);
+	}
+}
+
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct Scsi_Host *shost = target->scsi_host;
@@ -725,8 +737,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
-		if (req->scmnd)
-			srp_reset_req(target, req);
+		srp_finish_req(target, req, DID_RESET << 16);
 	}
 
 	INIT_LIST_HEAD(&target->free_tx);
@@ -1784,7 +1795,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
-			srp_reset_req(target, req);
+			srp_finish_req(target, req, DID_RESET << 16);
 	}
 
 	return SUCCESS;
@@ -2616,6 +2627,7 @@ static void srp_remove_one(struct ib_device *device)
 
 static struct srp_function_template ib_srp_transport_functions = {
 	.rport_delete		 = srp_rport_delete,
+	.terminate_rport_io	 = srp_terminate_io,
 };
 
 static int __init srp_init_module(void)
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
