From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Thu, 20 Feb 2014 11:52:23 +0100
Message-ID: <5305DE67.9070805@acm.org>
References: <5305DE01.7030004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5305DE01.7030004-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not log SCSI command failures that are the result of a transport
layer failure, a SCSI abort or SCSI reset. This patch is a slightly
modified version of a patch posted by Sebastian Riemer in March 2013
(see also http://thread.gmane.org/gmane.linux.drivers.rdma/15020/).

This patch avoids that a system becomes unresponsive during failover
of a large number of LUNs when kernel messages are logged to a serial
console.

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fba52d2..b3ca4d6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -827,6 +827,7 @@ static void srp_finish_req(struct srp_target_port *target,
 
 	if (scmnd) {
 		srp_free_req(target, req, scmnd, 0);
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1517,6 +1518,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	result = srp_chkready(target->rport);
 	if (unlikely(result)) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 		goto unlock_rport;
@@ -2011,6 +2013,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	else
 		ret = FAILED;
 	srp_free_req(target, req, scmnd, 0);
+	scmnd->request->cmd_flags |= REQ_QUIET;
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
