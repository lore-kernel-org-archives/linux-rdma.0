From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 11/14] IB/srp: Fail SCSI commands silently
Date: Wed, 12 Jun 2013 15:33:10 +0200
Message-ID: <51B87896.8020008@acm.org>
References: <51B87501.4070005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87501.4070005-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Avoid that path failover in a multipath setup causes the SCSI layer
to generate kernel messages about SCSI command failures. This patch
speeds up SRP initiator operation significantly when monitoring
kernel messages over a serial port.

[bvanassche: Changed patch description]
Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7cf44e1..dbedac9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -787,6 +787,7 @@ static void srp_finish_req(struct srp_target_port *target,
 
 	if (scmnd) {
 		srp_free_req(target, req, scmnd, 0);
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1467,6 +1468,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	result = srp_chkready(target->rport);
 	if (unlikely(result)) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1868,6 +1870,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	else
 		ret = FAILED;
 	srp_free_req(target, req, scmnd, 0);
+	scmnd->request->cmd_flags |= REQ_QUIET;
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
