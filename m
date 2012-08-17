From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Two more ib_srp patches
Date: Fri, 17 Aug 2012 09:50:18 +0000
Message-ID: <502E13DA.2030603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Dave,

I think I have found two additional (longstanding) ib_srp issues. Do the
patches below make sense to you ? If so, do you prefer that I post these
as individual patches or that I merge these in the patch called "[PATCH
01/20] ib_srp: Fix a race condition" ?

Thanks,

Bart.

[PATCH 1/2] ib_srp: Fix use-after-free in srp_reset_req()

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index f5e2180..42b7ef6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -806,9 +806,9 @@ static void srp_reset_req(struct srp_target_port
*target, struct srp_request *re
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);

 	if (scmnd) {
+		srp_free_req(target, req, scmnd, 0);
 		scmnd->result = DID_RESET << 16;
 		scmnd->scsi_done(scmnd);
-		srp_free_req(target, req, scmnd, 0);
 	}
 }



[PATCH 2/2] ib_srp: Avoid that aborted requests cause I/O to hang

---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 42b7ef6..7ae5a00 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1927,6 +1927,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 			  SRP_TSK_ABORT_TASK);
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
+	scmnd->scsi_done(scmnd);

 	return SUCCESS;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
