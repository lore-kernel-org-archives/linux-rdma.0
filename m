From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 03/15] IB/srp: Avoid that srp_reset_host() is skipped after
 a TL error
Date: Fri, 28 Jun 2013 14:49:08 +0200
Message-ID: <51CD8644.5080600@acm.org>
References: <51CD856A.3010102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD856A.3010102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SCSI error handler assumes that the transport layer is
operational if an eh_abort_handler() returns SUCCESS. Hence let
srp_abort() only return SUCCESS if sending the ABORT TASK task
management function succeeded. This patch avoids that the SCSI
error handler skips the srp_reset_host() call after a transport
layer error.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 035167b..8c95262 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1746,18 +1746,22 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	int ret;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
 	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
-	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
-			  SRP_TSK_ABORT_TASK);
+	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+			      SRP_TSK_ABORT_TASK) == 0)
+		ret = SUCCESS;
+	else
+		ret = FAILED;
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
 
-	return SUCCESS;
+	return ret;
 }
 
 static int srp_reset_device(struct scsi_cmnd *scmnd)
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
