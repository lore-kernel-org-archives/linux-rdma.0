From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp: Let srp_abort() return FAST_IO_FAIL if TL offline
Date: Wed, 10 Jul 2013 17:36:35 +0200
Message-ID: <51DD7F83.4070402@acm.org>
References: <1373391385-4978-1-git-send-email-roland@kernel.org> <51DD714D.4080001@profitbricks.com> <CAG4TOxNeJWDWdZv+8nXzE1ektybkTEX0xNYh_S64-Gh4ocTD_A@mail.gmail.com> <51DD7F10.1040104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51DD7F10.1040104-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the transport layer is offline it is more appropriate to let
srp_abort() return FAST_IO_FAIL instead of SUCCESS.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reported-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 9d8b46e..f93baf8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1753,8 +1753,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
-			      SRP_TSK_ABORT_TASK) == 0 ||
-	    target->transport_offline)
+			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
 	else if (target->transport_offline)
 		ret = FAST_IO_FAIL;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
